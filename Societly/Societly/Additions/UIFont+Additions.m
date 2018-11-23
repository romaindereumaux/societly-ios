//
//  UIFont+Additions.m
//  Societly
//
//  Created by Lauri Eskor on 26/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "UIFont+Additions.h"

@implementation UIFont (Additions)

+ (UIFont *)themeNavigationBarSmallFont {
  return [self themeRegularFontWithSize:17];
}

+ (UIFont *)themeNavigationBarLargeFont {
  return [self themeLightFontWithSize:26];
}

+ (UIFont *)themeTextfieldTextFont {
    return [self themeRegularFontWithSize:22];
}

+ (UIFont *)themeLightFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"Montserrat-Light" size:size];
}

+ (UIFont *)themeRegularFontWithSize:(CGFloat)size {
  return [UIFont fontWithName:@"Montserrat-Regular" size:size];
}
@end
