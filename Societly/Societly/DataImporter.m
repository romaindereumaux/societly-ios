//
//  DataImporter.m
//  Societly
//
//  Created by Lauri Eskor on 23/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "DataImporter.h"
#import "Database.h"
#import "Database+Question.h"
#import "Database+QuestionSet.h"

#define kKeyQuestionId @"questionId"
#define kKeyQUestionText @"questionText"

@implementation DataImporter

+ (void)importQuestions {
    
    NSString *filePath =[[NSBundle mainBundle] pathForResource:@"questions" ofType:@"json"];
    
    NSError *error;
    NSString *fileContents = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    
    if(error) {
        NSLog(@"Error reading file: %@",error.localizedDescription);
    }
    
    NSDictionary *questionSetDictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:[fileContents dataUsingEncoding:NSUTF8StringEncoding] options:0 error:NULL];
    
    NSString *questionSetId = [questionSetDictionary objectForKey:@"questionSetId"];
    QuestionSet *set = [[Database sharedInstance] questionSetWithId:questionSetId];
    
    if (set) {
        return;
    }
    
    if (!set) {
        set = [QuestionSet insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
        set.setId = questionSetId;
        set.userId = @"base";
    }
    
    NSArray *questionsArray = [questionSetDictionary objectForKey:@"questions"];
    for (NSDictionary *questionDictionary in questionsArray) {
        NSString *questionId = [questionDictionary objectForKey:kKeyQuestionId];
        NSString *questionText = [questionDictionary objectForKey:kKeyQUestionText];
        Question *question = [Question insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
        question.questionId = questionId;
        question.name = questionText;
        [set addQuestionsObject:question];
    }
    
    [[Database sharedInstance] saveContext:nil];
}

@end
