//
//  Database+Candidate.h
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Database.h"
#import "Candidate.h"

@interface Database (Candidate)

/** Return candidate with given ID.
 If such candidate is not in the database, create new one
 **/
- (Candidate *)candidateWithId:(NSString *)candidateId;

/** 
 Return all candidates.
 **/
- (NSArray *)listCandidates;

/**
 Return candidates for level "country"
 **/
- (NSArray *)listPresidentalCandidates;

/**
 Return candidates for specific state and level "state"
 **/
- (NSArray *)listSenateCandidatesForState:(NSString *)stateId;

/**
 Return candidates for specific state and district, and level "district"
 **/
- (NSArray *)listHorCandidatesForState:(NSString *)stateId andDistrict:(NSString *)districtId;

- (NSArray *)listCandidatesForState:(NSString *)stateId;
- (NSArray *)listCandidatesForState:(NSString *)stateId andDistrict:(NSString *)districtId;

/**
 Add candidates from array of dictionaries downloaded from server.
 This array contains info about candidates as well as candidate answers.
 **/
- (void)addCandidatesFromArray:(NSArray *)candidatesArray;

@end
