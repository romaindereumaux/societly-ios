//
//  CGRectUtility.m
//  Societly
//
//  Created by Lauri Eskor on 23/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CGRectUtility.h"

@implementation CGRectUtility

+ (CGPoint)centerOfRect:(CGRect)rect {
  CGFloat x = rect.origin.x + rect.size.width / 2;
  CGFloat y = rect.origin.y + rect.size.height / 2;
  return CGPointMake(x, y);
}

@end
