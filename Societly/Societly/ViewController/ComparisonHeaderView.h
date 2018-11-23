//
//  ComparisonHeaderView.h
//  Societly
//
//  Created by Lauri Eskor on 02/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Candidate.h"

@interface ComparisonHeaderView : UITableViewHeaderFooterView

- (void)configureWithCandidate:(Candidate *)candidate;

@end
