//
//  CompassViewController.m
//  Societly
//
//  Created by Lauri Eskor on 02/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CompassViewController.h"
#import "LandingViewController.h"

#import "Database+QuestionSet.h"
#import "Database+Candidate.h"
#import "Database+District.h"
#import "Database+State.h"
#import "NetworkManager+Questions.h"
#import "NetworkManager+Candidates.h"
#import "NetworkManager+States.h"
#import "NetworkManager+Districts.h"

@interface CompassViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *compassImage;
@property (nonatomic, assign) BOOL stopAnimation;
@property (nonatomic, assign) NSInteger rotationDirection;
@end

@implementation CompassViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  self.rotationDirection = 1;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self rotateNeedle];
    // TODO clear database for old users to make sure they get new data
  [self downloadQuestionsIfNeeded];
}

// Download questions only if there are no questionsets in database
- (void)downloadQuestionsIfNeeded {
  QuestionSet *userQuestionSet = [[Database sharedInstance] userQuestionSet];
  if (userQuestionSet == nil) {
    [[NetworkManager sharedInstance] listQuestionsWithSuccess:^(NSArray *array) {
      [self downloadCandidatesIfNeeded];
    } andFailure:^(NSError *error) {
      MLLog(@"Network error %@", error);
    }];
  } else {
    [self downloadCandidatesIfNeeded];
  }
}

// Download candidates if there are no candidates in database
- (void)downloadCandidatesIfNeeded {
  NSArray *candidates = [[Database sharedInstance] listCandidates];
  if ([candidates count] == 0) {
    [[NetworkManager sharedInstance] listCandidatesWithSuccess:^(NSArray *array) {
        [self downloadStatesIfNeeded];
    } andFailure:^(NSError *error) {
      MLLog(@"Network error %@", error);
    }];
  } else {
      [self downloadStatesIfNeeded];
  }
}

- (void)downloadStatesIfNeeded {
    NSArray *states = [[Database sharedInstance] listStates];
    if ([states count] == 0) {
        [[NetworkManager sharedInstance] listStatesWithSuccess:^(NSArray *array) {
            [self downloadDistrictsIfNeeded];
            
        } andFailure:^(NSError *error) {
            MLLog(@"Network error %@", error);
        }];
    } else {
        [self downloadDistrictsIfNeeded];
    }
}

- (void)downloadDistrictsIfNeeded {
    NSArray *districts = [[Database sharedInstance] listDistricts];
    if ([districts count] == 0) {
        [[NetworkManager sharedInstance] listDistrictsWithSuccess:^(NSArray *array) {
            self.stopAnimation = YES;
            
        } andFailure:^(NSError *error) {
            MLLog(@"Network error %@", error);
        }];
    } else {
        self.stopAnimation = YES;
    }
}

- (void)openLandingViewController {
  LandingViewController *landingViewController = [[LandingViewController alloc] initWithNibName:NSStringFromClass([LandingViewController class]) bundle:nil];
  [self.navigationController pushViewController:landingViewController animated:YES];
}

- (void)rotateNeedle {
  // this spin completes 360 degrees every 2 seconds
  [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations: ^{
    NSInteger direction = self.rotationDirection * -1;
    self.rotationDirection = direction;
    self.compassImage.transform = CGAffineTransformRotate(self.compassImage.transform, direction * M_PI / 4);
  } completion: ^(BOOL finished) {
    if (finished) {
      if (!self.stopAnimation) {
        // if flag still set, keep spinning with constant speed
        [self rotateNeedle];
      } else {
        [self openLandingViewController];
      }
    }
  }];
}

@end
