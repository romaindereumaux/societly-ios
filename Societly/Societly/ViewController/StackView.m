//
//  StackView.m
//  Societly
//
//  Created by Lauri Eskor on 06/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "StackView.h"
#import "StackedCollectionViewCell.h"
#import "StackedLayout.h"

#import "Question.h"
#import "Database+QuestionSet.h"
#import "UIColor+Additions.h"

#import "PureLayout.h"
#import "StackedCollectionViewCell.h"

@interface StackView () <UICollectionViewDataSource, UICollectionViewDelegate, StackedLayoutDelegate, TopBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) QuestionSet *userQuestionSet;
@property (nonatomic, strong) NSArray *questionsArray;
@end

@implementation StackView

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
  UIView *subView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
  subView.frame = self.bounds;
  [self addSubview:subView];
  [self setUserInteractionEnabled:YES];
  
  UINib *cardNib = [UINib nibWithNibName:NSStringFromClass([StackedCollectionViewCell class]) bundle:nil];
  [self.collectionView registerNib:cardNib forCellWithReuseIdentifier:NSStringFromClass([StackedCollectionViewCell class])];
  
  StackedLayout *layout = [StackedLayout new];
  [layout setDelegate:self];
  [self.collectionView setCollectionViewLayout:layout];

  UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:layout action:@selector(panRecognized:)];
  [self.collectionView addGestureRecognizer:panRecognizer];
  [panRecognizer setDelegate:layout];

  [self.topBar setDelegate:self];
}

- (void)setTutorialVisible:(BOOL)tutorialVisible {
  _tutorialVisible = tutorialVisible;
  
  // If tutorial is visible, modify top bar element visibility and
  // Disable card gesture recognizer.
  [self.topBar.previousButton setHidden:tutorialVisible];
  if (!tutorialVisible) {
    [self setUserInteractionEnabled:YES];
    [self reloadCardsScrollToFirstUnanswered:NO];
  } else {
    [self setUserInteractionEnabled:NO];
    [self.topBar.nextButton setHidden:NO];
    self.topBar.titleLabel.text = @"";
  }
}

- (void)reloadCardsScrollToFirstUnanswered:(BOOL)scroll {

  self.userQuestionSet = [[Database sharedInstance] userQuestionSet];
  NSInteger startingIndex;
  
  if (scroll) {
    startingIndex = [self.userQuestionSet indexOfFirstUnansweredQuestion];
  } else {
    startingIndex = 0;
  }
  
  if (startingIndex == [self.userQuestionSet.questions count]) {
    startingIndex -= 1;
  }
  if (startingIndex == 0 && !self.tutorialVisible) {
    [self.topBar.nextButton setHidden:YES];
  }
  
  [self.topBar setTotalQuestions:[self.userQuestionSet.questions count]];
  [self setQuestionsArray:[self.userQuestionSet sortedQuestionsIncludeSkipped:YES]];
  
  [[self layout] setIndex:startingIndex];
  
  if (!self.tutorialVisible) {
    [self.topBar setCurrentQuestion:startingIndex + 1];
  }
}

#pragma mark - TopBarDelegate
- (StackedLayout *)layout {
  StackedLayout *stackedLayout = (StackedLayout *)self.collectionView.collectionViewLayout;
  return stackedLayout;
}

- (void)previousPressed {
  if ([[self layout] index] > 0) {
    [[self layout] scrollToPreviousCard];
  } else {
    [self.topBar.previousButton setHidden:YES];
    [self.delegate pressedPreviousInFirstCard];
  }
}

- (void)nextPressed {
  // Don't scroll to next card if tutorial is the current card
  if (!self.tutorialVisible) {
    [[self layout] scrollToNextCard];
  } else {
    [self.delegate pressedNext];
  }
}

#pragma mark - StackedLayoutDelegate
- (void)fingerDown:(BOOL)fingerDown {
  [self.topBar setUserInteractionEnabled:!fingerDown];
}

- (void)cardChangedStateWithIndex:(NSInteger)cardIndex {
  if (cardIndex < [self.userQuestionSet.questions count] && !self.tutorialVisible) {
    [self.topBar setCurrentQuestion:cardIndex + 1];
  }
  NSInteger startingIndex = [self.userQuestionSet indexOfFirstUnansweredQuestion];
  
  // Don't let scroll past first unanswered question
  if (!self.tutorialVisible) {
    [self.topBar.nextButton setHidden:cardIndex == startingIndex];
  }

  // Dont't let scroll past maximum card number
  if (cardIndex + 1 == self.topBar.totalQuestions && !self.tutorialVisible) {
    [self.topBar.nextButton setHidden:YES];
  }
}

- (PositionType)positionForCardWithIndex:(NSInteger)cardIndex {
  Question *question = [self.questionsArray objectAtIndex:cardIndex];
  return question.answerValue;
}

- (void)swipingCell:(UICollectionViewCell *)cell toPosition:(PositionType)position withDistanceFromCenter:(CGFloat)distance {
  if ([cell isKindOfClass:[StackedCollectionViewCell class]]) {
    [(StackedCollectionViewCell *)cell swipingToPosition:position withDistanceFromCenter:distance];
  }
}

- (void)swipedCardWithIndex:(NSInteger)index toPosition:(PositionType)position {
  if (index < [self.questionsArray count]) {
    Question *question = [self.questionsArray objectAtIndex:index];
    [question setAnswerValue:position];
    [[Database sharedInstance] saveContext:nil];
    
    // If this is the last card, show results screen.
    if (index == [self.questionsArray count] - 1) {
      [self.delegate lastCardWasSwiped];
    }
  }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  return [self.questionsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  StackedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([StackedCollectionViewCell class])  forIndexPath:indexPath];
  
  Question *question = [self.questionsArray objectAtIndex:indexPath.item];
  
  [cell.label setText:question.name];
  [cell configureWithPosition:question.answerValue];
  
  return cell;
}

#pragma mark - IB support
- (void)drawRect:(CGRect)rect {
#if TARGET_INTERFACE_BUILDER
  UIFont* font = [UIFont fontWithName:@"Arial" size:15];
  UIColor* textColor = [UIColor redColor];
  NSDictionary* stringAttrs = @{ UITextAttributeFont : font, UITextAttributeTextColor : textColor };
  NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"Stack view" attributes:stringAttrs];
  
  [attrStr drawAtPoint:CGPointMake(10.f, 10.f)];
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGRect viewFrame = self.bounds;
  CGContextSetLineWidth(context, 2);
  CGRectInset(viewFrame, 10, 10);
  [[UIColor greenColor] set];
  UIRectFrame(viewFrame);
#endif
}

@end
