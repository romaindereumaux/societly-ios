//
//  ComparisonTableViewCell.m
//  Societly
//
//  Created by Lauri Eskor on 02/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ComparisonTableViewCell.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

CGFloat const kOnelineLabelHeight = 44;
CGFloat const kTwoLineLabelHeight = 68;

@interface ComparisonTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelHeight;
@property (weak, nonatomic) IBOutlet UILabel *questionNumberLabel;

@end

@implementation ComparisonTableViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.questionLabel setTextColor:[UIColor themeDarkTextColor]];
  [self.leftLabel setTextColor:[UIColor themeSliderFullTrackColor]];
  [self.rightLabel setTextColor:[UIColor themeSliderFullTrackColor]];
  [self.questionNumberLabel setTextColor:[UIColor themeLightDarkTextColor]];
}

- (void)configureWithQuestion:(NSString *)question leftLabelPosition:(PositionType)leftPosition rightPosition:(PositionType)rightPosition andQuestonNumber:(NSInteger)number {
  
  [self.questionLabel setText:question];
  [self.leftLabel setText:[[ManhattanDistance stringForPosition:leftPosition] uppercaseString]];
  [self.rightLabel setText:[[ManhattanDistance stringForPosition:rightPosition] uppercaseString]];
  
  NSString *questionNumberString = [NSString stringWithFormat:@"%ld", (long)number];
  [self.questionNumberLabel setText:questionNumberString];
  
  UIColor *comparsionColor;
  if (leftPosition == PositionTypeSkip) {
    comparsionColor = [UIColor themeSliderEmptyTrackColor];
  } else if (leftPosition == rightPosition) {
    comparsionColor = [UIColor themeGreenColor];
  } else if (labs(leftPosition - rightPosition) == 25) {
    comparsionColor = [UIColor themeYellowColor];
  } else {
    comparsionColor = [UIColor themeRedColor];
  }
  
  [self.leftLabel setBackgroundColor:comparsionColor];
  [self.rightLabel setBackgroundColor:comparsionColor];
  
  CGFloat labelHeight = kOnelineLabelHeight;
  if (rightPosition == PositionTypeRatherNo || rightPosition == PositionTypeRatherYes) {
    labelHeight = kTwoLineLabelHeight;
  }
  self.labelHeight.constant = labelHeight;
  [self setNeedsUpdateConstraints];
}


@end
