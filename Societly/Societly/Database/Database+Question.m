//
//  Database+Question.m
//  Societly
//
//  Created by Lauri Eskor on 23/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Database+Question.h"
#import "Database+QuestionSet.h"
#import "ManhattanDistance.h"

@implementation Database (Question)

- (NSArray *)allQuestions {
    NSArray *questionsArray = [self listCoreObjectsNamed:NSStringFromClass([Question class])];
    return questionsArray;
}

- (Question *)copyOfCuestion:(Question *)question {
    Question *resultQuestion = [Question insertInManagedObjectContext:self.managedObjectContext];
    resultQuestion.questionId = [question.questionId copy];
    resultQuestion.name = [question.name copy];
    resultQuestion.sortingIndex = [question.sortingIndex copy];
    resultQuestion.answerValue = PositionTypeNothing;
    resultQuestion.questionDescription = question.questionDescription;
    return resultQuestion;
}

// A question dictionary:
//{
//    description = "Description of question 1";
//    id = 1;
//    name = "Social security should be privatized";
//    params =     {
//        10 = 0;
//        11 = 1;
//        12 = 0;
//        13 = 0;
//        5 = "-1";
//        6 = 1;
//        7 = 0;
//        8 = 0;
//        9 = 0;
//        "xy-lc" = 0;
//        "xy-lr" = 1;
//    };
//    position = 1;
//},
- (Question *)questionFromDictionary:(NSDictionary *)questionDictionary {
    Question *question = [Question insertInManagedObjectContext:self.managedObjectContext];
    [question setQuestionId:[[questionDictionary objectForKey:kKeyId] stringValue]];
    [question setQuestionDescription:[questionDictionary objectForKey:kKeyDescription]];
    [question setName:[questionDictionary objectForKey:kKeyName]];
    [question setSortingIndex:[questionDictionary objectForKey:kKeySortingIndex]];
    return question;
}

@end
