//
//  EmailViewController.m
//  Societly
//
//  Created by Lauri Eskor on 30/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "EmailViewController.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"
#import "CandidateListViewController.h"

#import "Database+QuestionSet.h"

#import "NetworkManager+Questions.h"

#import "MBProgressHUD.h"
#import "TopBar.h"

@interface EmailViewController () <TopBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pleaseEnterEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UIView *emailFieldView;
@property (weak, nonatomic) IBOutlet UIButton *continueButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;
@property (weak, nonatomic) IBOutlet TopBar *topBar;
@end

@implementation EmailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.pleaseEnterEmailLabel setTextColor:[UIColor themeLightDarkTextColor]];
  [self.pleaseEnterEmailLabel setText:NSLocalizedString(@"enter your email", nil)];
  
  NSAttributedString *emailPlaceholderString = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"email", nil) attributes:@{ NSForegroundColorAttributeName : [UIColor themeLightDarkTextColor] }];
  self.emailField.attributedPlaceholder = emailPlaceholderString;
  [self.emailFieldView addRectBorder];
  [self.continueButton setTitle:[NSLocalizedString(@"continue", nil) uppercaseString] forState:UIControlStateNormal];
  [self.continueButton roundCornersWithRadius:3];
  [self subscribeKeyboardNotifications];
  
  UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
  [self.contentView addGestureRecognizer:tapRecognizer];
  [self setAutomaticallyAdjustsScrollViewInsets:NO];
  
  [self.topBar setDelegate:self];
  [self.topBar.nextButton setHidden:YES];
  [self.topBar.titleLabel setText:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
  [super viewDidDisappear:animated];
  [self unsubscribeKeyboardNotifications];
}

- (void)subscribeKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)unsubscribeKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapFired:(UITapGestureRecognizer *)recognizer {
  [self.view endEditing:YES];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification {
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  
  // If active text field is hidden by keyboard, scroll it so it's visible
  // Your app might not need or want this behavior.
  CGRect continueButtonRect = [self.scrollView convertRect:self.continueButton.frame fromView:self.continueButton.superview];
  [self.scrollView scrollRectToVisible:continueButtonRect animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.scrollView.contentInset = contentInsets;
  self.scrollView.scrollIndicatorInsets = contentInsets;
  [self.scrollView scrollRectToVisible:self.contentView.frame animated:YES];
}

- (IBAction)continueTapped:(id)sender {
  if ([self.emailField.text length] == 0) {
    [self openCandidateListViewController];
  } else {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[NetworkManager sharedInstance] sendAnswersForEmail:self.emailField.text withSuccess:^{
      [self openCandidateListViewController];
    } andFailure:^(NSError *error) {
      [self openCandidateListViewController];
    }];
  }
}

- (IBAction)skipButtonTapped:(id)sender {
  [self openCandidateListViewController];
}

- (void)openCandidateListViewController {
  [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
  CandidateListViewController *candidateListViewController = [[CandidateListViewController alloc] initWithNibName:NSStringFromClass([CandidateListViewController class]) bundle:nil];
  [self.navigationController pushViewController:candidateListViewController animated:YES];
}

#pragma mark - TopBarDelegate
- (void)nextPressed {}
- (void)previousPressed {
  [self.navigationController popViewControllerAnimated:YES];
}

@end
