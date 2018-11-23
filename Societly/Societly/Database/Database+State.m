//
//  Database+State.m
//  Societly
//
//  Created by Katrin Annuk on 27/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "Database+State.h"
#import "Database+Candidate.h"

@implementation Database (State)

- (NSArray *)listStates {
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    return [self listCoreObjectsNamed:NSStringFromClass([State class]) withPredicate:nil sortDescriptors:@[sortDescriptor]];
}

- (NSArray *)listStatesWithCandidates {
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K != %@", @"candidate", nil];

  return [self listCoreObjectsNamed:NSStringFromClass([State class]) withPredicate:predicate sortDescriptors:@[sortDescriptor]];
}

- (State *)stateWithId:(NSString *)stateId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K == %@", @"stateId", stateId];
    
    State *state = [self findCoreDataObjectNamed:NSStringFromClass([State class]) withPredicate:predicate];
    
    if (!state) {
        state = [State insertInManagedObjectContext:self.managedObjectContext];
        state.stateId = stateId;
    }
    
    [self saveContext:nil];
    return state;
}

- (void)addStatesFromArray:(NSArray *)statesArray {
    
    for (NSDictionary *stateDictionary in statesArray) {

        NSString *stateId = [[stateDictionary objectForKey:kKeyId] stringValue];
        State *state = [self stateWithId:stateId];
        
        state.stateId = stateId;
        state.name = [stateDictionary objectForKey:kKeyName];
        state.code = [stateDictionary objectForKey:kKeyCode];
      
      NSArray *candidates = [self listCandidatesForState:stateId];
      
      for (Candidate *candidate in candidates) {
        candidate.state = state;
      }
    }
    [self saveContext:nil];
}
@end
