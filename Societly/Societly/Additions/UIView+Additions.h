//
//  UIView+Additions.h
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//


@interface UIView (Additions)

/** 
 Make view round
 **/
- (void)makeRound;

/** 
 Add card rounded corners
 **/
- (void)addCardCorners;

/** 
 Add rounded shadow to view
 **/
- (void)addCardShadow;

/** 
 Add rounded border to view
 **/
- (void)addLabelBorderWithWidth:(CGFloat)borderWidth andColor:(UIColor *)color;

/** 
 Add rectangular border to view
 **/
- (void)addRectBorder;

/** 
 Round view corners
 **/
- (void)roundCornersWithRadius:(CGFloat)radius;

/** 
 return angle of rotation for a view depending on the distance to superview's center
 **/
+ (double)angleOfRotationForView:(UIView *)view;

@end
