//
//  Database+QuestionSet.h
//  Societly
//
//  Created by Lauri Eskor on 24/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Database.h"
#import "QuestionSet.h"

@interface Database (QuestionSet)

- (QuestionSet *)questionSetWithId:(NSString *)questionSetId;

/** 
 Return questionset with id for user.
 **/
- (QuestionSet *)questionSetWithId:(NSString *)questionSetId andUser:(NSString *)userId;

/** 
 Return questionset for current user. Create if it is not present.
 **/
- (QuestionSet *)userQuestionSet;

/** 
 Return questionSet with no userId
 **/
- (QuestionSet *)latestQuestionSet;

/** 
 Return copy of questionSet where userId is set to |userId|. Return questionSet if it is already present
 **/
- (QuestionSet *)questionSetWithSet:(QuestionSet *)questionSet andUserId:(NSString *)userId;

// Add questionSet from backend response to database. This will create a new questionSet if there is no default questionset.
- (void)addQuestionSetFromArray:(NSArray *)array;

@end
