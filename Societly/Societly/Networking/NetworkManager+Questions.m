//
//  NetworkManager+Questions.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NetworkManager+Questions.h"
#import "Database+QuestionSet.h"
#import "Question.h"
#import "Defaults.h"

@implementation NetworkManager (Questions)

- (void)listQuestionsWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure {
    [self GET:kPathQuestions parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject isKindOfClass:[NSArray class]]) {
            [[Database sharedInstance] addQuestionSetFromArray:(NSArray *)responseObject];
            MLLog(@"Loaded %lu questions", (unsigned long)[(NSArray *)responseObject count]);
            success(nil);
        } else {
            failure(nil);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}

- (void)sendAnswersForEmail:(NSString *)email withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure {
    NSMutableDictionary *resultDictionary = [NSMutableDictionary dictionary];
    [resultDictionary setObject:@"mobile" forKey:@"publisher"];
    
    if (email) {
        [resultDictionary setObject:email forKey:@"email"];
    }
   
    QuestionSet *userQuestionSet = [[Database sharedInstance] userQuestionSet];
    NSArray *answersArray = [userQuestionSet resultsArray];
    [resultDictionary setObject:answersArray forKey:kKeyAnswers];
    
    NSTimeInterval startToResultTimeInterval = fabs([[Defaults getLaunchDate] timeIntervalSinceNow]);
    NSString *startToResultString = [NSString stringWithFormat:@"%1.0f", startToResultTimeInterval];
    [resultDictionary setObject:startToResultString forKey:@"start_to_result"];
    
    NSTimeInterval secondsToResultTimeInterval = fabs([[Defaults getFirstQuestionDate] timeIntervalSinceNow]);
    NSString *secondsToResultString = [NSString stringWithFormat:@"%1.0f", secondsToResultTimeInterval];
    [resultDictionary setObject:secondsToResultString forKey:@"seconds_to_result"];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
 
    // "2015-09-21 14:35:21"
    [dateFormatter setDateFormat:@"y-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:[Defaults getLaunchDate]];
    [resultDictionary setObject:dateString forKey:@"open_page_at"];
    
    [self POST:kPathPostResults parameters:resultDictionary success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MLLog(@"Got post result: %@", responseObject);
        success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
