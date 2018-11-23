//
//  CandidateListCell.h
//  Societly
//
//  Created by Lauri Eskor on 29/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Candidate.h"

@interface CandidateListCell : UITableViewCell

- (void)configureWithCandidate:(Candidate *)candidate andPrecent:(CGFloat)precent forIndex:(NSInteger)index;

@end
