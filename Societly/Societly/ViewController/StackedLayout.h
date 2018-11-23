//
//  StackedLayout.h
//  Societly
//
//  Created by Lauri Eskor on 06/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ManhattanDistance.h"

@protocol StackedLayoutDelegate <NSObject>

- (void)cardChangedStateWithIndex:(NSInteger)cardIndex;
- (PositionType)positionForCardWithIndex:(NSInteger)cardIndex;
- (void)swipedCardWithIndex:(NSInteger)index toPosition:(PositionType)position;
- (void)swipingCell:(UICollectionViewCell *)cell toPosition:(PositionType)position withDistanceFromCenter:(CGFloat)distance;

/** Called when pan starts and ends **/
- (void)fingerDown:(BOOL)fingerDown;

@end

@interface StackedLayout : UICollectionViewFlowLayout <UIGestureRecognizerDelegate>

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, weak) id <StackedLayoutDelegate> delegate;

- (void)scrollToPreviousCard;
- (void)scrollToNextCard;

/**
 Return position that corresponds to a center point.
 **/
+ (PositionType)positionWithCenterPoint:(CGPoint)centerPoint fromCenterPoint:(CGPoint)originalCenterPoint;

/** 
 Return final frame for |position|
 **/
+ (CGRect)frameForPosition:(PositionType)position withStartingFrame:(CGRect)startingFrame;


- (void)panRecognized:(UIPanGestureRecognizer *)recognizer;

@end
