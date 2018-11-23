//
//  ButtonWithRoundedCorners.h
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface ButtonWithRoundedCorners : UIButton
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable UIColor *defaultBgColor;
@property (nonatomic) IBInspectable UIColor *highlightedBgColor;
@property (nonatomic) IBInspectable UIColor *disabledBgColor;

@end
