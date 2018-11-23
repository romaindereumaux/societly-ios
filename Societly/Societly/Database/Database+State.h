//
//  Database+State.h
//  Societly
//
//  Created by Katrin Annuk on 27/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "Database.h"
#import "State.h"

@interface Database (State)
- (NSArray *)listStates;
- (NSArray *)listStatesWithCandidates;
- (State *)stateWithId:(NSString *)stateId;
- (void)addStatesFromArray:(NSArray *)statesArray;

@end
