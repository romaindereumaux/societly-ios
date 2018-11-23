//
//  UIColor+Additions.h
//  Societly
//
//  Created by Lauri Eskor on 23/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ManhattanDistance.h"

@interface UIColor (Additions)

/** 
 Return color with modified alpha to give stronger and lighter versions of same color.
 **/

+ (UIColor *)colorForPosition:(PositionType)position andAlpha:(CGFloat)alpha;

/** 
 Theme colors
 **/
+ (UIColor *)themeDarkTextColor;
+ (UIColor *)themeLightDarkTextColor;
+ (UIColor *)themeGreenColor;
+ (UIColor *)themeRedColor;
+ (UIColor *)themeYellowColor;
+ (UIColor *)themeGreyColor;
+ (UIColor *)themeWhiteTextColor;
+ (UIColor *)themeWhiteDarkColor;
+ (UIColor *)themeGrayBackgroundColor;
+ (UIColor *)themeLightGreyBackground;
+ (UIColor *)themePickerTextColor;

+ (UIColor *)themeSliderEmptyTrackColor;
+ (UIColor *)themeSliderFullTrackColor;
+ (UIColor *)themeImageOverlayColor;
/** 
 Return a random color
 **/
+ (UIColor *)randomColor;
@end
