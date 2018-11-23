//
//  ManhattanDistance.m
//  Societly
//
//  Created by Lauri Eskor on 24/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ManhattanDistance.h"

@implementation ManhattanDistance

+ (CGFloat)distanceBetween:(NSArray *)firstArray and:(NSArray *)secondArray withWeights:(NSArray *)weights {
    CGFloat manhattanDistance = 0;
    
    // Don't enter calculation if
    if ([firstArray count] != [secondArray count]) {
        return 0;
    }
    
    if (weights && [firstArray count] != [weights count]) {
        return 0;
    }
    
    //First calculate abs of difference of each pair of positions. If weights are enabled multiply by weight.
    NSMutableArray *distancesArray = [NSMutableArray array];
    for (int i = 0; i < [firstArray count]; i++) {
        NSInteger firstPosition = [firstArray[i] integerValue];
        NSInteger secondPosition = [secondArray[i] integerValue];
        CGFloat distance = labs(firstPosition - secondPosition);
        
        if (weights) {
            CGFloat weight = [self weightForType:[weights[i] integerValue]];
            distance = distance * weight;
        }
        
        [distancesArray addObject:[NSNumber numberWithFloat:distance]];
    }
    
    // Claculate sum of distances. Divide by weight if weights are enabled.
    CGFloat sumDistances = 0;
    CGFloat sumWeights = 0;
    
    for (int i = 0; i < [firstArray count]; i++) {
        CGFloat distance = [distancesArray[i] floatValue];
        
        // Skip distances, where one position is PositionTypeSkip.
        NSInteger firstPosition = [firstArray[i] integerValue];
        NSInteger secondPosition = [secondArray[i] integerValue];

        if (firstPosition != PositionTypeSkip && secondPosition != PositionTypeSkip) {
            sumDistances += distance;
            
            if (weights) {
                CGFloat weight = [ManhattanDistance weightForType:[weights[i] floatValue]];
                sumWeights += weight;
            }
        }
    }
    
    // Calculate manhattan distance of positions.
    CGFloat nonNormalizedDistance = sumDistances;
    if (weights) {
        nonNormalizedDistance = sumDistances / sumWeights;
    } else {
        nonNormalizedDistance = sumDistances * 1.0 / [distancesArray count];
    }
    
    manhattanDistance = 100 - nonNormalizedDistance;
    return manhattanDistance;
}

+ (NSString *)stringForPosition:(PositionType)position {
    NSString *returnString;
    switch (position) {
        case PositionTypeNeutral:
            returnString = NSLocalizedString(@"neutral", nil);
            break;
        case PositionTypeYes:
            returnString = NSLocalizedString(@"agree", nil);
            break;
            
        case PositionTypeNo:
            returnString = NSLocalizedString(@"disagree", nil);
            break;
            
        case PositionTypeRatherNo:
            returnString = NSLocalizedString(@"tend to disagree", nil);
            break;
            
        case PositionTypeRatherYes:
            returnString = NSLocalizedString(@"tend to agree", nil);
            break;
            
        case PositionTypeSkip:
            returnString = [NSLocalizedString(@"skip", nil) capitalizedString];
            break;
            
        case PositionTypeNothing:
            returnString = NSLocalizedString(@"no answer", nil);
            break;
            
        default:
            break;
    }
    
    return returnString;
}

+ (CGFloat)weightForType:(WeightType)type {
    CGFloat returnValue;
    switch (type) {
        case WeightTypeImportant:
            returnValue = 2;
            break;
        case WeightTypeNeutral:
            returnValue = 1;
            break;
        case WeightTypeNotImportant:
            returnValue = 0.5;
            break;
            
        default:
            break;
    }
    return returnValue;
}

@end
