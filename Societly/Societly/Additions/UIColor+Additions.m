//
//  UIColor+Additions.m
//  Societly
//
//  Created by Lauri Eskor on 23/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "UIColor+Additions.h"

@implementation UIColor (Additions)

+ (UIColor *)colorForPosition:(PositionType)position andAlpha:(CGFloat)alpha {
    UIColor *color;
    
    if (position == PositionTypeNo) {
        color = [UIColor themeRedColor];
    } else if (position == PositionTypeYes) {
        color = [UIColor themeGreenColor];
    } else if (position == PositionTypeNeutral) {
        color = [UIColor themeYellowColor];
    } else if (position == PositionTypeSkip) {
        color = [UIColor themeGreyColor];
    } else if (position == PositionTypeNothing) {
        color = [UIColor whiteColor];
    }

    if (position != PositionTypeNothing) {
        color = [color modifyFithAlpha:alpha];
    }

    return color;
}

+ (UIColor *)themeImageOverlayColor {
  return [self colorFromHexString:@"000440" andAlpha:0.6];
}

+ (UIColor *)themeDarkTextColor {
    return [self colorFromHexString:@"000440" andAlpha:1];
}

+ (UIColor *)themeLightDarkTextColor {
    return [self colorFromHexString:@"b1b1b1" andAlpha:1];
}

+ (UIColor *)themeGreenColor {
    return [self colorFromHexString:@"77f3b5" andAlpha:1];
}

+ (UIColor *)themeRedColor {
    return [self colorFromHexString:@"ff7777" andAlpha:1];
}

+ (UIColor *)themeYellowColor {
    return [self colorFromHexString:@"fff777" andAlpha:1];
}

+ (UIColor *)themeGreyColor {
    return [self colorFromHexString:@"b1b1b1" andAlpha:1];
}

+ (UIColor *)themeWhiteTextColor {
    return [self colorFromHexString:@"FFFFFF" andAlpha:1];
}

+ (UIColor *)themeWhiteDarkColor {
    return  [self colorFromHexString:@"FFFFFF" andAlpha:0.5];
}

+ (UIColor *)themeGrayBackgroundColor {
    return [self colorFromHexString:@"000440" andAlpha:0.6];
}

+ (UIColor *)themeSliderEmptyTrackColor {
    return [self colorFromHexString:@"d8d8d8" andAlpha:1];
}

+ (UIColor *)themeSliderFullTrackColor {
    return [self colorFromHexString:@"010942" andAlpha:1];
}

+ (UIColor *)themeLightGreyBackground {
  return [self colorFromHexString:@"e0e0e0" andAlpha:1];
}

+ (UIColor *)themePickerTextColor {
  return [self colorFromHexString:@"010941" andAlpha:1];
}

- (UIColor *)modifyFithAlpha:(CGFloat)alpha {
    return [self colorWithAlphaComponent:alpha];
}

+ (UIColor *)colorFromHexString:(NSString *)hexString andAlpha:(CGFloat)alpha {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:alpha];
}

+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end
