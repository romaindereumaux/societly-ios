//
//  ComparisonTableViewCell.h
//  Societly
//
//  Created by Lauri Eskor on 02/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ManhattanDistance.h"

@interface ComparisonTableViewCell : UITableViewCell

- (void)configureWithQuestion:(NSString *)question leftLabelPosition:(PositionType)leftPosition rightPosition:(PositionType)rightPosition andQuestonNumber:(NSInteger)number;

@end
