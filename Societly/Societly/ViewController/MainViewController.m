//
//  MainViewController.m
//  Societly
//
//  Created by Lauri Eskor on 18/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "MainViewController.h"
#import "EmailViewController.h"

#import "Defaults.h"

#import "UIColor+Additions.h"
#import "UIView+Additions.h"
#import "DataImporter.h"
#import "TutorialCard.h"

#import "Database+Question.h"
#import "Database+QuestionSet.h"
#import "Database+Candidate.h"

#import "NetworkManager+Candidates.h"
#import "NetworkManager+Questions.h"

#import "Candidate.h"
#import "CandidateListViewController.h"

#import "StackView.h"
#import "StackedLayout.h"
#import "CGRectUtility.h"

@interface MainViewController () <StackViewDelegate>

@property (weak, nonatomic) IBOutlet StackView *stackView;
@property (weak, nonatomic) IBOutlet TutorialCard *tutorialView;

@property (strong, nonatomic) QuestionSet *userQuestionSet;

@property (nonatomic, assign) BOOL viewDidAppear;

@property (nonatomic, assign) CGRect tutorialViewStartingFrame;
@end

@implementation MainViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.stackView setDelegate:self];
  
  QuestionSet *questionSet = [[Database sharedInstance] userQuestionSet];
  NSInteger firstUnansweredQuestion = [questionSet indexOfFirstUnansweredQuestion];

  [self showTutorialView:(firstUnansweredQuestion == 0)];
  
  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panRecognized:)];
  [self.tutorialView addGestureRecognizer:panRecognizer];
  [Defaults setFirstQuestionDate:[NSDate date]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];
  self.viewDidAppear = NO;
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  if (!self.viewDidAppear) {
    [self.stackView reloadCardsScrollToFirstUnanswered:YES];
  }
  self.tutorialViewStartingFrame = self.tutorialView.frame;
  [self.tutorialView addShadow];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  // Card library is not very configurable for navigationcontroller.
  // This hack ensures cards are in correct place if view is appeared.
  self.viewDidAppear = YES;
}

- (void)showResultsTableview {
    if ([Defaults getSessionCookie]) {
        
        [[NetworkManager sharedInstance] sendAnswersForEmail:nil withSuccess:^{
            CandidateListViewController *candidateListViewController = [[CandidateListViewController alloc] initWithNibName:NSStringFromClass([CandidateListViewController class]) bundle:nil];
            [self.navigationController pushViewController:candidateListViewController animated:YES];
        } andFailure:^(NSError *error) {
            // Submission failed
            NSLog(@"Submission failed %@", error.localizedDescription);
            CandidateListViewController *candidateListViewController = [[CandidateListViewController alloc] initWithNibName:NSStringFromClass([CandidateListViewController class]) bundle:nil];
            [self.navigationController pushViewController:candidateListViewController animated:YES];
        }];

    } else {
        EmailViewController *emailViewController = [[EmailViewController alloc] initWithNibName:NSStringFromClass([EmailViewController class]) bundle:nil];
        [self.navigationController pushViewController:emailViewController animated:YES];
    }
}

#pragma mark - Pan gesture handling
#pragma mark - Recognizer handling
- (void)panRecognized:(UIPanGestureRecognizer *)recognizer {
  
  if (recognizer.state == UIGestureRecognizerStateChanged) {
    CGPoint translation = [recognizer translationInView:self.tutorialView];
    
    CGPoint centerOfOriginalFrame = [CGRectUtility centerOfRect:self.tutorialViewStartingFrame];
    CGFloat newCenterX = centerOfOriginalFrame.x + translation.x;
    CGFloat newCenterY = centerOfOriginalFrame.y + translation.y;
    
    self.tutorialView.center = CGPointMake(newCenterX, newCenterY);
    self.tutorialView.transform = CGAffineTransformMakeRotation([UIView angleOfRotationForView:self.tutorialView]);
  } else {
    CGFloat deltaX = self.tutorialView.center.x - self.view.center.x;
    CGFloat deltaY = self.tutorialView.center.y - self.view.center.y;
    
    // Snap back if not dragged far enough
    BOOL shouldSnapBack = (fabs(deltaX) < self.view.frame.size.width / 3 && fabs(deltaY) < self.view.frame.size.height / 3);
    
    if (shouldSnapBack) {
      [UIView animateWithDuration:0.5 animations:^{
        self.tutorialView.transform = CGAffineTransformIdentity;
        [self.tutorialView setFrame:self.tutorialViewStartingFrame];
      }];
    } else {
      PositionType position = [StackedLayout positionWithCenterPoint:self.tutorialView.center fromCenterPoint:self.view.center];
      CGRect finalRect = [StackedLayout frameForPosition:position withStartingFrame:self.tutorialViewStartingFrame];
      [UIView animateWithDuration:0.2 animations:^{
        self.tutorialView.transform = CGAffineTransformIdentity;
        [self.tutorialView setFrame:finalRect];
      } completion:^(BOOL finished) {
        [self showTutorialView:NO];
        [self.tutorialView setFrame:self.tutorialViewStartingFrame];
      }];
    }
  }
}

#pragma mark - StackViewDelegate
- (void)lastCardWasSwiped {
  [self showResultsTableview];
}

- (void)pressedPreviousInFirstCard {
  [self showTutorialView:YES];
}

- (void)pressedNext {
  [self showTutorialView:NO];
}

- (void)showTutorialView:(BOOL)showTutorialView {
  [self.stackView setTutorialVisible:showTutorialView];
  [self.tutorialView setHidden:!showTutorialView];
}

@end
