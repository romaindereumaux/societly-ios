//
//  CandidateListViewController.m
//  Societly
//
//  Created by Lauri Eskor on 30/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CandidateListViewController.h"
#import "ComparisonViewController.h"
#import "LandingViewController.h"
#import "MainViewController.h"

#import "CandidateListCell.h"
#import "EmptySectionCell.h"
#import "CandidateListFooter.h"
#import "PureLayout.h"
#import "CandidatesSectionHeader.h"

#import "Database+Candidate.h"
#import "Database+QuestionSet.h"
#import "Database+State.h"
#import "Database+District.h"

#import "NetworkManager+Customer.h"

#import "ManhattanDistance.h"
#import "TopBar.h"
#import "Defaults.h"

typedef NS_ENUM(NSUInteger, CandidateListSection) {
  CandidateListSectionPresidental = 0,
  CandidateListSectionSenate,
  CandidateListSectionHoR,
};

@interface CandidateListViewController () <UITableViewDataSource, UITableViewDelegate, CandidateListFooterDelegate, TopBarDelegate, PickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL didLayoutSubviews;
@property (nonatomic, strong) NSArray *presidentalCandidatesArray;
@property (nonatomic, strong) NSArray *stateCandidatesArray;
@property (nonatomic, strong) NSArray *districtCandidatesArray;

@property (nonatomic, strong) NSArray *states;
@property (nonatomic, strong) NSArray *stateNames;
@property (nonatomic, strong) NSArray *districts;
@property (nonatomic, strong) NSArray *districtNames;
@property (weak, nonatomic) IBOutlet TopBar *topBar;

@property (strong, nonatomic) NSString *selectedState;
@property (strong, nonatomic) NSString *selectedDistrict;

@end

@implementation CandidateListViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardDidShowNotification object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardDidHideNotification object:nil];
  
  UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([CandidateListCell class]) bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([CandidateListCell class])];
  
  cellNib = [UINib nibWithNibName:NSStringFromClass([EmptySectionCell class]) bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([EmptySectionCell class])];
  
  UINib *footer = [UINib nibWithNibName:NSStringFromClass([CandidateListFooter class]) bundle:nil];
  [self.tableView registerNib:footer forHeaderFooterViewReuseIdentifier:NSStringFromClass([CandidateListFooter class])];

  BOOL isLoggedIn = [Defaults getSessionCookie];
  if (isLoggedIn) {
    [self.topBar.nextButton setTransform:CGAffineTransformMakeRotation(M_PI)];
    [self.topBar.nextButton setImage:[UIImage imageNamed:@"logOut"] forState:UIControlStateNormal];
  } else {
    [self.topBar.nextButton setHidden:YES];
  }
  [self.topBar.titleLabel setText:@"Results"];
  [self.topBar setDelegate:self];
  [self.topBar useDarkColors];
  [self.topBar setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self setAutomaticallyAdjustsScrollViewInsets:NO];
  [self.navigationController setNavigationBarHidden:YES animated:NO];
  [self.tableView setRowHeight:UITableViewAutomaticDimension];
  [self.tableView setEstimatedRowHeight:88];
  [self.tableView setSectionFooterHeight:150];
  [self.tableView reloadData];
  
  [self calculateDistancesForPresidentalCandidates];
    
  [self loadStates];
}

- (void)loadStates {
  self.states = [[Database sharedInstance] listStatesWithCandidates];

  NSMutableArray *stateNames = [[NSMutableArray alloc] init];
  for (State *state in self.states) {
    [stateNames addObject:state.name];
  }
  self.stateNames = stateNames;
}

- (void)loadDistricts {
  self.districts = [[Database sharedInstance] listDistrictsWithCandidatesForState:[self selectedStateId]];
  NSMutableArray *districtNames = [[NSMutableArray alloc] init];
  for (District *district in self.districts) {
    [districtNames addObject:district.name];
  }
  self.districtNames = districtNames;
}

- (NSString *)selectedStateId {
  NSUInteger index = [self.stateNames indexOfObject:self.selectedState];
  if (index == NSNotFound) {
    return nil;
  }
  State *state = self.states[index];
  NSString *stateId = state.stateId;
  return stateId;
}

- (NSString *)selectedDistrictId {
  NSUInteger index = [self.districtNames indexOfObject:self.selectedDistrict];
  if (index == NSNotFound) {
    return nil;
  }
  District *district = self.districts[index];
  NSString *districtId = district.districtId;
  return districtId;
}

- (void)calculateDistancesForPresidentalCandidates {
  NSArray *candidatesArray = [[Database sharedInstance] listPresidentalCandidates];
  [self calculateDistancesForCandidates:candidatesArray];
  self.presidentalCandidatesArray = [[Database sharedInstance] listPresidentalCandidates];
}

- (void)calculateDistancesForSenateCandidates {
  NSString *stateId = [self selectedStateId];

  if (stateId == nil) {
    self.stateCandidatesArray = @[];
    
  } else {
    NSArray *candidatesArray = [[Database sharedInstance] listSenateCandidatesForState:stateId];
    [self calculateDistancesForCandidates:candidatesArray];
    self.stateCandidatesArray = [[Database sharedInstance] listSenateCandidatesForState:stateId];
  }
}

- (void)calculateDistancesForHoRCandidates {
  NSString *districtId = [self selectedDistrictId];
  NSString *stateId = [self selectedStateId];
  if (stateId == nil || districtId == nil) {
    self.districtCandidatesArray = @[];
  } else {
    NSArray *candidatesArray = [[Database sharedInstance] listHorCandidatesForState:stateId andDistrict:districtId];
    [self calculateDistancesForCandidates:candidatesArray];
    self.districtCandidatesArray = [[Database sharedInstance] listHorCandidatesForState:stateId andDistrict:districtId];
  }
}

- (void)calculateDistancesForCandidates:(NSArray *)candidatesArray {
  // If this calculation is too slow move it to background operation
  
  QuestionSet *userSet = [[Database sharedInstance] userQuestionSet];
  NSArray *userPositionsArray = [userSet positionsArray];
  for (Candidate *candidate in candidatesArray) {
    NSArray *candidatePositionsArray = [candidate.questionSet positionsArray];
    CGFloat distance = [ManhattanDistance distanceBetween:userPositionsArray and:candidatePositionsArray withWeights:nil];
    candidate.distanceFromUserValue = distance;
  }
  
  [[Database sharedInstance] saveContext:nil];
}

- (void)setSelectedState:(NSString *)selectedState {
  _selectedState = selectedState;
  [self calculateDistancesForSenateCandidates];
  [self loadDistricts];
  
  if ((selectedState.length > 0 && self.stateCandidatesArray.count == 0) || (self.districts.count == 1)) {
    // Automatically selecting first district
    District *district = [self.districts firstObject];
    self.selectedDistrict = district.name;
  } else {
    self.selectedDistrict = nil;
  }
  
  [self.tableView reloadData];
}

- (void)setSelectedDistrict:(NSString *)selectedDistrict {
  _selectedDistrict = selectedDistrict;
  [self calculateDistancesForHoRCandidates];
  [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.districts.count > 0) {
    return 3;
    
  } else {
    return 2;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == CandidateListSectionSenate && self.stateCandidatesArray.count == 0 && self.selectedState.length > 0) {
    return 1;
  }
  
  NSArray *candidates = [self arrayForSection:section];

  return [candidates count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == CandidateListSectionPresidental) {
    return 43.0f;
  }
  return 120.0f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  CandidatesSectionHeader* sectionHeader = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CandidatesSectionHeader class]) owner:self options:nil] objectAtIndex:0];
  
  sectionHeader.picker.delegate = self;
  
  if (section == CandidateListSectionPresidental) {
    sectionHeader.titleLabel.text = NSLocalizedString(@"Presidental", nil);
    
  } else if (section == CandidateListSectionSenate) {
    sectionHeader.titleLabel.text = NSLocalizedString(@"Senate", nil);
    sectionHeader.picker.selectedItemTitle = self.selectedState;
    sectionHeader.picker.itemTitles = self.stateNames;
    sectionHeader.picker.pickerTitle = NSLocalizedString(@"Pick a state", nil);
    
  } else if (section == CandidateListSectionHoR) {
    sectionHeader.titleLabel.text = NSLocalizedString(@"House of Representatives", nil);
    sectionHeader.picker.selectedItemTitle = self.selectedDistrict;

    sectionHeader.picker.itemTitles = self.districtNames;
    sectionHeader.picker.pickerTitle = NSLocalizedString(@"Pick a district", nil);
  }
  
  sectionHeader.picker.tag = section;
  
  return sectionHeader;
}

- (NSArray *)arrayForSection:(NSInteger)section {
  if (section == CandidateListSectionPresidental) {
    return self.presidentalCandidatesArray;
  } else if(section == CandidateListSectionSenate) {
    return self.stateCandidatesArray;
  } else if(section == CandidateListSectionHoR) {
    return self.districtCandidatesArray;
  }
  
  return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.section == CandidateListSectionSenate && self.stateCandidatesArray.count == 0) {
    EmptySectionCell *cell = (EmptySectionCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmptySectionCell class]) forIndexPath:indexPath];
    cell.label.text = NSLocalizedString(@"No candidates", nil);
    return cell;
  }
  
  CandidateListCell *cell = (CandidateListCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CandidateListCell class]) forIndexPath:indexPath];
  
  NSArray *candidates = [self arrayForSection:indexPath.section];
  Candidate *candidate = [candidates objectAtIndex:indexPath.row];
  [cell configureWithCandidate:candidate andPrecent:candidate.distanceFromUserValue forIndex:indexPath.row + 1];
  return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

  if (section + 1 == [self numberOfSectionsInTableView:self.tableView]) {
    CandidateListFooter *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([CandidateListFooter class])];
    [footer setDelegate:self];
    return footer;
  }
  return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
  if (section + 1 == [self numberOfSectionsInTableView:self.tableView]) {
    return 190;
  }
  return CGFLOAT_MIN;
 }

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  NSArray *candidates = [self arrayForSection:indexPath.section];
  if (candidates.count > indexPath.row) {
    Candidate *candidate = [candidates objectAtIndex:indexPath.row];
    ComparisonViewController *comparisonViewController = [[ComparisonViewController alloc] initWithCandidate:candidate];
    [self.navigationController pushViewController:comparisonViewController animated:YES];
  }
}

#pragma mark - CandidateListFooterDelegate
- (void)resetPressed {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Restart", nil)
                                                    message:NSLocalizedString(@"Restarting will clear all your answers. Do you want to continue?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Restart",nil), nil];
    [alert show];
}

#pragma mark - TopBarDelegate
- (void)nextPressed {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Log out", nil)
                                                    message:NSLocalizedString(@"Are you sure you want to log out?", nil)
                                                   delegate:self
                                          cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                                          otherButtonTitles:NSLocalizedString(@"Log out",nil), nil];
    [alert show];
}

- (void)previousPressed {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - PickerViewDelegate
- (void)picker:(PickerView *)pickerView selectedTitle:(NSString *)title {
  if (pickerView.tag == 1) {
    self.selectedState = title;
    
  } else if (pickerView.tag == 2) {
    self.selectedDistrict = title;
  }
}

- (void)keyboardWillShow:(NSNotification*)aNotification {
  
  NSDictionary* info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
  
  UIEdgeInsets contentInsets = UIEdgeInsetsMake(0, 0, kbSize.height, 0);
  self.tableView.contentInset = contentInsets;
  self.tableView.scrollIndicatorInsets = contentInsets;
  
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
  UIEdgeInsets contentInsets = UIEdgeInsetsZero;
  self.tableView.contentInset = contentInsets;
  self.tableView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - AlerViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    if ([alertView.title isEqualToString:NSLocalizedString(@"Log out", nil)]) {
        if (buttonIndex == 1) {
            [[NetworkManager sharedInstance] logOutWithSuccess:^(NSDictionary *dictionary) {
                NSNumber *success = [dictionary objectForKey:@"success"];
                
                if (success == [NSNumber numberWithBool:1]) {
                    MLLog(@"logout success %@", dictionary);
                    
                    QuestionSet *userQuestionSet = [[Database sharedInstance] userQuestionSet];
                    [[[Database sharedInstance] managedObjectContext] deleteObject:userQuestionSet];
                    [[Database sharedInstance] saveContext:nil];
                    
                    LandingViewController *landingViewController = [[LandingViewController alloc] initWithNibName:NSStringFromClass([LandingViewController class]) bundle:nil];
                    [self.navigationController setViewControllers:@[landingViewController] animated:YES];
                }
                
            } andFailure:^(NSError *error) {
                MLLog(@"Failed logout %@", error);
                
            }];
        }
    } else if ([alertView.title isEqualToString:NSLocalizedString(@"Restart", nil)]) {
        
        if (buttonIndex == 1) {
            QuestionSet *userQuestionSet = [[Database sharedInstance] userQuestionSet];
            [[[Database sharedInstance] managedObjectContext] deleteObject:userQuestionSet];
            [[Database sharedInstance] saveContext:nil];
            
            if ([Defaults getSessionCookie]) {
                MainViewController *mainController = [[MainViewController alloc] initWithNibName:NSStringFromClass([MainViewController class]) bundle:nil];
                [self.navigationController setViewControllers:@[mainController] animated:YES];
                
            } else {
                LandingViewController *landingViewController = [[LandingViewController alloc] initWithNibName:NSStringFromClass([LandingViewController class]) bundle:nil];
                [self.navigationController setViewControllers:@[landingViewController] animated:YES];
            }
        }
    }
}


@end
