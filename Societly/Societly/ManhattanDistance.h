//
//  ManhattanDistance.h
//  Societly
//
//  Created by Lauri Eskor on 24/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

typedef NS_ENUM(NSInteger, PositionType) {
    PositionTypeNo = 0,
    PositionTypeRatherNo = 25,
    PositionTypeNeutral = 50,
    PositionTypeRatherYes = 75,
    PositionTypeYes = 100,
    PositionTypeSkip = -1,
    PositionTypeNothing = -2
};

typedef NS_ENUM(NSInteger, WeightType) {
    WeightTypeNotImportant = 0,
    WeightTypeNeutral = 1,
    WeightTypeImportant = 2
};

@interface ManhattanDistance : NSObject

/**
 Calculate Manhattan distance between two sets of answers.
 |fistArray| and |secondArray| are arrays of PositionType objects.
 |weights| is array or WeightType objects
 If element with index i of |firstArray| or |secondArray| is PositionTypeSkip,
 then elements with this index are not used in calculations.
 if |weights| == nil, don't use weigths.
 **/

+ (CGFloat)distanceBetween:(NSArray *)firstArray and:(NSArray *)secondArray withWeights:(NSArray *)weights;

/** 
 Return localized string for position
 **/
+ (NSString *)stringForPosition:(PositionType)position;
@end
