//
//  StackedCollectionViewCell.m
//  Societly
//
//  Created by Lauri Eskor on 06/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "StackedCollectionViewCell.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"
#import "BorderLabel.h"
#import "PureLayout.h"

@interface StackedCollectionViewCell ()
@property (weak, nonatomic) IBOutlet BorderLabel *skipLabel;
@property (weak, nonatomic) IBOutlet BorderLabel *noLabel;
@property (weak, nonatomic) IBOutlet BorderLabel *yesLabel;
@property (weak, nonatomic) IBOutlet BorderLabel *neutralLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *positionView;

@end

@implementation StackedCollectionViewCell

- (void)awakeFromNib {
  [super awakeFromNib];
  self.translatesAutoresizingMaskIntoConstraints = NO;
  
  [self.contentView autoPinEdgesToSuperviewEdges];
  
  [self.yesLabel setHidden:YES];
  [self.noLabel setHidden:YES];
  [self.skipLabel setHidden:YES];
  [self.neutralLabel setHidden:YES];
  
  [self.yesLabel.label setTextColor:[UIColor themeDarkTextColor]];
  [self.noLabel.label setTextColor:[UIColor themeDarkTextColor]];
  [self.skipLabel.label setTextColor:[UIColor themeDarkTextColor]];
  [self.neutralLabel.label setTextColor:[UIColor themeDarkTextColor]];
  [self.label setTextColor:[UIColor themeDarkTextColor]];
  
  [self.yesLabel setText:[NSLocalizedString(@"agree", nil) uppercaseString] allowShrink:NO];
  [self.noLabel setText:[NSLocalizedString(@"disagree", nil) uppercaseString] allowShrink:NO];
  [self.skipLabel setText:[NSLocalizedString(@"skip", nil) uppercaseString] allowShrink:NO];
  [self.neutralLabel setText:[NSLocalizedString(@"neutral", nil) uppercaseString] allowShrink:NO];

  [self.contentView setBackgroundColor:[UIColor whiteColor]];
}

- (void)configureWithPosition:(PositionType)position {
  // Add rounded corners to contentView and rounded shadow to cell
  [self.contentView addCardCorners];
  [self addCardShadow];
  
  UIColor *toColor = [UIColor colorForPosition:position andAlpha:1];
  [self.positionView setAlpha:1];
  [self.containerView setBackgroundColor:toColor];
  [self showPositionLabelForPosition:position];
}

- (void)showPositionLabelForPosition:(PositionType)position {
  [self.yesLabel setHidden:!(position == PositionTypeYes)];
  [self.noLabel setHidden:!(position == PositionTypeNo)];
  [self.neutralLabel setHidden:!(position == PositionTypeNeutral)];
  [self.skipLabel setHidden:!(position == PositionTypeSkip)];
}

- (void)swipingToPosition:(PositionType)position withDistanceFromCenter:(CGFloat)distanceFromCenter {
  // For color alpha calculate sin() for distance. Distance must be converted to
  // 0..Pi/2 scale
  // This is different for horizontal and vertical swipes.

  CGFloat modifiedDistance = 0;
  if (position == PositionTypeYes || position == PositionTypeNo) {
    if (distanceFromCenter > self.frame.size.width / 2) {
      distanceFromCenter = self.frame.size.width / 2;
    }
    modifiedDistance = (M_PI / (self.frame.size.width)) * distanceFromCenter;
  } else {
    if (distanceFromCenter > self.frame.size.height / 2) {
      distanceFromCenter = self.frame.size.height / 2;
    }
    modifiedDistance = (M_PI / (self.frame.size.height)) * distanceFromCenter;
  }
  
  if (modifiedDistance > M_PI) {
    modifiedDistance = M_PI;
  }
  
  CGFloat colorAlpha = sinf(modifiedDistance);
  UIColor *toColor = [UIColor colorForPosition:position andAlpha:colorAlpha];

  [self showPositionLabelForPosition:position];
  [self.containerView setBackgroundColor:toColor];
  [self.positionView setAlpha:colorAlpha];
}


@end
