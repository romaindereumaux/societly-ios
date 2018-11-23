//
//  CandidateSlider.m
//  Societly
//
//  Created by Lauri Eskor on 01/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CandidateSlider.h"

@implementation CandidateSlider

- (CGRect)trackRectForBounds:(CGRect)bounds {
    CGRect newBounds = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width, 5);
    return newBounds;
}


@end
