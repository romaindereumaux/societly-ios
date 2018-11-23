//
//  NSLayoutConstraint+Additions.m
//  Societly
//
//  Created by Lauri Eskor on 13/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NSLayoutConstraint+Additions.h"

@implementation NSLayoutConstraint (Additions)

- (NSString *)description {
    NSString *identifier = self.identifier;
    return [NSString stringWithFormat:@"id %@, constant %1.0f", identifier, self.constant];
}

@end
