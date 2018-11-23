//
//  UIView+Additions.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "UIView+Additions.h"
#import "UIColor+Additions.h"
@implementation UIView (Additions)

- (void)addCardCorners {
  self.layer.cornerRadius = 11.0f;
  self.layer.borderWidth = 1.0f;
  self.layer.borderColor = [UIColor clearColor].CGColor;
  self.layer.masksToBounds = YES;
}

- (void)addCardShadow {
  UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:11];
  self.layer.shadowColor = [UIColor themeDarkTextColor].CGColor;
  self.layer.backgroundColor = [UIColor clearColor].CGColor;
  self.layer.shadowOffset = CGSizeZero;
  self.layer.shadowOpacity = 0.2;
  self.layer.shadowRadius = 11;
  self.layer.shadowPath = shadowPath.CGPath;
  self.layer.masksToBounds = NO;
}

- (void)removeCardShadow {
  self.layer.shadowRadius = 0;
}

- (void)addLabelBorderWithWidth:(CGFloat)borderWidth andColor:(UIColor *)color {
  self.layer.borderColor = color.CGColor;
  self.layer.borderWidth = borderWidth;
  self.layer.cornerRadius = 5;
  self.layer.masksToBounds = YES;
}

- (void)makeRound {
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = self.bounds.size.width / 2;
}

- (void)addRectBorder {
  self.layer.borderColor = [UIColor whiteColor].CGColor;
  self.layer.borderWidth = 1;
  
}

- (void)roundCornersWithRadius:(CGFloat)radius {
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = radius;
}

+ (double)angleOfRotationForView:(UIView *)view {
  double result = 0;
  
  CGFloat yDelta = view.superview.frame.size.height + view.frame.size.height;
  double multiplier = (view.center.x - view.superview.frame.size.width / 2) / (yDelta - view.center.y);
  result = atan(multiplier);
  return result;
}

@end
