//
//  CandidateListFooter.h
//  Societly
//
//  Created by Lauri Eskor on 01/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

@protocol CandidateListFooterDelegate <NSObject>

- (void)resetPressed;

@end


@interface CandidateListFooter : UITableViewHeaderFooterView

@property (nonatomic, assign) id <CandidateListFooterDelegate> delegate;

@end
