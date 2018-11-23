//
//  StackedCollectionViewCell.h
//  Societly
//
//  Created by Lauri Eskor on 06/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ManhattanDistance.h"

@interface StackedCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)configureWithPosition:(PositionType)position;
- (void)swipingToPosition:(PositionType)position withDistanceFromCenter:(CGFloat)distanceFromCenter;

@end
