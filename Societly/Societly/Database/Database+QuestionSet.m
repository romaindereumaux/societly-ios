//
//  Database+QuestionSet.m
//  Societly
//
//  Created by Lauri Eskor on 24/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Database+QuestionSet.h"
#import "Database+Question.h"

@implementation Database (QuestionSet)

- (QuestionSet *)questionSetWithId:(NSString *)questionSetId {
    return [self questionSetWithId:questionSetId andUser:@"base"];
}

- (QuestionSet *)questionSetWithId:(NSString *)questionSetId andUser:(NSString *)userId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"setId == %@ && userId == %@", questionSetId, userId];
    QuestionSet *set = (QuestionSet *)[self findCoreDataObjectNamed:NSStringFromClass([QuestionSet class]) withPredicate:predicate];
    return set;
}

- (QuestionSet *)userQuestionSet {
    QuestionSet *latestSet = [[Database sharedInstance] latestQuestionSet];
    if (!latestSet) {
        return nil;
    }
    QuestionSet *userQuestionSet = [[Database sharedInstance] questionSetWithId:latestSet.setId andUser:@"user"];
    if (!userQuestionSet) {
        userQuestionSet = [[Database sharedInstance] questionSetWithSet:latestSet andUserId:@"user"];
    }
    return userQuestionSet;
}

- (QuestionSet *)latestQuestionSet {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userId == %@", @"base"];
    QuestionSet *set = [self findCoreDataObjectNamed:NSStringFromClass([QuestionSet class]) withPredicate:predicate];
    
    return set;
}

- (QuestionSet *)questionSetWithSet:(QuestionSet *)questionSet andUserId:(NSString *)userId {
    QuestionSet *copyOfSet = [self questionSetWithId:questionSet.setId andUser:userId];
    
    if (!copyOfSet) {
        copyOfSet = [QuestionSet insertInManagedObjectContext:self.managedObjectContext];
        copyOfSet.setId = questionSet.setId;
        copyOfSet.userId = userId;
        
        for (Question *question in questionSet.questions) {
            Question *copyOfQuestion = [self copyOfCuestion:question];
            [copyOfSet addQuestionsObject:copyOfQuestion];
        }
        
        [self saveContext:self.managedObjectContext];
    }
    
    return copyOfSet;
}

- (void)addQuestionSetFromArray:(NSArray *)array {
    QuestionSet *questionSet = [self latestQuestionSet];
    if (questionSet) {
        return;
    }
    
    questionSet = [QuestionSet insertInManagedObjectContext:self.managedObjectContext];
    [questionSet setUserId:@"base"];
    
    for (NSDictionary *questionDictionary in array) {
        Question *question = [self questionFromDictionary:questionDictionary];
        [questionSet addQuestionsObject:question];
    }
    
    [self saveContext:nil];
}

@end
