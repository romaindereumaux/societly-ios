//
//  NavigationHelper.m
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "NavigationHelper.h"
#import "CompassViewController.h"
#import "MainViewController.h"
#import "EmailViewController.h"
#import "CandidateListViewController.h"
#include "Database+QuestionSet.h"
#import "Defaults.h"
#import "NetworkManager+Customer.h"

@implementation NavigationHelper

+ (void)setupFirstViewOnWindow:(UIWindow *)window {
    NSMutableArray *viewControllersArray = [NSMutableArray array];

    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];

    if (![appVersion isEqualToString:[Defaults getLastVersion]]) {
        // Data might have changed. Clearing database.
        MLLog(@"Clearing database because of new version");
        [[Database sharedInstance] resetDB];
        [Defaults setLastVersion:appVersion];
    }
    
    if (![Defaults getSessionCookie]) { // Is user logged in ?
        UIViewController *controller = [[CompassViewController alloc] initWithNibName:NSStringFromClass([CompassViewController class]) bundle:nil];
        [viewControllersArray addObject:controller];
    } else {
        
        [[NetworkManager sharedInstance] getLatestSubmissionwithSuccess:^{
            NSLog(@"getLatestSubmission success");
            QuestionSet *userQuestionSet = [[Database sharedInstance] userQuestionSet];

            // If user has answered all questions, open candidate list controller and cards view
            NSInteger totalQuestions = [userQuestionSet.questions count];
            NSInteger firstUnansweredQuestion = [userQuestionSet indexOfFirstUnansweredQuestion];
            if (totalQuestions == firstUnansweredQuestion) {
                UIViewController *candidateListController = [[CandidateListViewController alloc] initWithNibName:NSStringFromClass([CandidateListViewController class]) bundle:nil];
                [viewControllersArray addObject:candidateListController];
            } else {
                UIViewController *mainController = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
                [viewControllersArray addObject:mainController];
            }
    
            UINavigationController *navController = [UINavigationController new];
            
            [navController setViewControllers:viewControllersArray animated:NO];
            window.rootViewController = navController;
            return;
            
        } andFailure:^(NSError *error) {
            MLLog(@"Failed getting LatestSubmission %@", error);
        }];
    }
    
    UINavigationController *navController = [UINavigationController new];
    [navController setViewControllers:viewControllersArray animated:NO];
    window.rootViewController = navController;
}

+ (void)setMainViewOnNavController:(UINavigationController *)navigationController {
    MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
    [navigationController setViewControllers:@[mainViewController] animated:YES];
}

+ (void) setViewControllerAfterLogin:(UINavigationController *) navigationController {
 
    NSMutableArray *viewControllersArray = [NSMutableArray array];

    
    [[NetworkManager sharedInstance] getLatestSubmissionwithSuccess:^{
        NSLog(@"getLatestSubmissionwithSuccess");
        QuestionSet *userQuestionSet = [[Database sharedInstance] userQuestionSet];
        
        // If user has answered all questions, open candidate list controller and cards view
        NSInteger totalQuestions = [userQuestionSet.questions count];
        NSInteger firstUnansweredQuestion = [userQuestionSet indexOfFirstUnansweredQuestion];
        UIViewController *mainController = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
        [viewControllersArray addObject:mainController];

        if (totalQuestions == firstUnansweredQuestion) {
            UIViewController *candidateListController = [[CandidateListViewController alloc] initWithNibName:NSStringFromClass([CandidateListViewController class]) bundle:nil];
            [viewControllersArray addObject:candidateListController];
        }
        [navigationController setViewControllers:viewControllersArray animated:YES];

    } andFailure:^(NSError *error) {
        MLLog(@"Failed getLatestSubmissionwithSuccess %@", error);
        
        MainViewController *mainViewController = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
        [navigationController setViewControllers:@[mainViewController] animated:YES];
    }];
}

@end
