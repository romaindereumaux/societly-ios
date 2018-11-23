//
//  LandingViewController.m
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "LandingViewController.h"
#import "SignUpViewController.h"
#import "SignInViewController.h"
#import "NavigationHelper.h"

@interface LandingViewController ()

@end

@implementation LandingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (IBAction)signInTapped:(id)sender {
    SignInViewController *viewController = [[SignInViewController alloc] initWithNibName:NSStringFromClass([SignInViewController class]) bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)signUpTapped:(id)sender {
    SignUpViewController *viewController = [[SignUpViewController alloc] initWithNibName:NSStringFromClass([SignUpViewController class]) bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)skipButtonTapped:(id)sender {
    [NavigationHelper setMainViewOnNavController:self.navigationController];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
