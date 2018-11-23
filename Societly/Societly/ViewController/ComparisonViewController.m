//
//  ComparisonViewController.m
//  Societly
//
//  Created by Lauri Eskor on 02/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ComparisonViewController.h"
#import "ComparisonHeaderView.h"
#import "ComparisonTableViewCell.h"
#import "Question.h"
#import "Database+QuestionSet.h"
#import "TopBar.h"

@interface ComparisonViewController () <UITableViewDataSource, TopBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) Candidate *candidate;

@property (nonatomic, strong) NSArray *sortedCandidateQuestions;
@property (nonatomic, strong) NSArray *sortedUserQuestions;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

@property (weak, nonatomic) IBOutlet TopBar *topBar;
@end

@implementation ComparisonViewController

- (id)initWithCandidate:(Candidate *)candidate {
  self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
  if (self) {
    self.candidate = candidate;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UINib *headerNib = [UINib nibWithNibName:NSStringFromClass([ComparisonHeaderView class]) bundle:nil];
  [self.tableView registerNib:headerNib forHeaderFooterViewReuseIdentifier:NSStringFromClass([ComparisonHeaderView class])];
  
  UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([ComparisonTableViewCell class]) bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([ComparisonTableViewCell class])];
  
  [self setAutomaticallyAdjustsScrollViewInsets:NO];
  [self.tableView setRowHeight:UITableViewAutomaticDimension];
  [self.tableView setEstimatedRowHeight:200];
  [self.tableView setSectionHeaderHeight:152];
}

- (void)viewDidLayoutSubviews {
  self.topConstraint.constant = [self.topLayoutGuide length];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  [self.topBar.nextButton setHidden:YES];
  [self.topBar setDelegate:self];
  [self.topBar.titleLabel setText:@"Comparison"];
  [self.topBar useDarkColors];
  [self.topBar setBackgroundColor:[UIColor whiteColor]];

  
  // Remove user questions, that have 'skip' value from candidate answers
  
  // Comment out to show only non-skipped answers
  //    QuestionSet *userSet = [[Database sharedInstance] userQuestionSet];
  //    NSArray *allUserAnswers = [userSet sortedQuestionsIncludeSkipped:YES];
  //
  //    NSMutableArray *candidateQuestionsUserDidNotSkipp = [NSMutableArray array];
  //    for (int i = 0; i < [allUserAnswers count]; i++) {
  //        Question *userQuestion = allUserAnswers[i];
  //        if (userQuestion.answerValue != PositionTypeSkip) {
  //            Question *candidateQuestion = allCandidateQuestions[i];
  //            [candidateQuestionsUserDidNotSkipp addObject:candidateQuestion];
  //        }
  //    }
  
  self.sortedCandidateQuestions = [self.candidate.questionSet sortedQuestionsIncludeSkipped:YES];
  self.sortedUserQuestions = [[[Database sharedInstance] userQuestionSet] sortedQuestionsIncludeSkipped:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.sortedUserQuestions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  ComparisonTableViewCell *cell = (ComparisonTableViewCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ComparisonTableViewCell class]) forIndexPath:indexPath];
  
  Question *candidateQuestion = [self.sortedCandidateQuestions objectAtIndex:indexPath.row];
  Question *userQuestion = [self.sortedUserQuestions objectAtIndex:indexPath.row];
  
  [cell configureWithQuestion:userQuestion.name leftLabelPosition:userQuestion.answerValue rightPosition:candidateQuestion.answerValue andQuestonNumber:indexPath.row + 1];
  [cell layoutIfNeeded];
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  ComparisonHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ComparisonHeaderView class])];
  [header.contentView setBackgroundColor:[UIColor whiteColor]];
  [header configureWithCandidate:self.candidate];
  return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  return 188;
}

- (PositionType)randomPosition {
  NSInteger randomInt = arc4random() % 3;
  PositionType returnPosition;
  switch (randomInt) {
    case 0:
      returnPosition = PositionTypeNeutral;
      break;
    case 1:
      returnPosition = PositionTypeNo;
      break;
    case 2:
      returnPosition = PositionTypeYes;
      break;
      
    default:
      break;
  }
  return returnPosition;
}

#pragma mark - TopBar delegate
- (void)nextPressed {}

- (void)previousPressed {
  [self.navigationController popViewControllerAnimated:YES];
}
@end
