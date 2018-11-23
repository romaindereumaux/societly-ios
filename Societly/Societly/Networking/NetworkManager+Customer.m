//
//  NetworkManager+Customer.m
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "NetworkManager+Customer.h"
#import "Defaults.h"
#import "QuestionSet.h"
#import "Question.h"
#import "Database+QuestionSet.h"

@implementation NetworkManager (Customer)

- (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:kKeyEmail];
    [params setObject:password forKey:kKeyPassword];

    [self POST:kPathCustomers parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MLLog(@"Got post result: %@", responseObject);
        [self saveCookie:task];
        success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)signUpWithToken:(NSString *)accessToken andProvider:(NSString *)provider withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:accessToken forKey:kKeyAccessToken];
    [params setObject:provider forKey:kKeyProvider];
    
    [self POST:kPathCustomers parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        MLLog(@"Got post result: %@", responseObject);
        [self saveCookie:task];
        success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:kKeyEmail];
    [params setObject:password forKey:kKeyPassword];
    
    [self POST:kPathLogin parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {

        MLLog(@"Got post result: %@", responseObject);
        [self saveCookie:task];
        success();
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void)signInWithToken:(NSString *)accessToken andProvider:(NSString *)provider withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure {
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  [params setObject:accessToken forKey:kKeyAccessToken];
  [params setObject:provider forKey:kKeyProvider];
  [params setObject:@"postmessage" forKey:@"redirect_uri"];
  [self POST:kPathLogin parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
    MLLog(@"Got post result: %@", responseObject);
    [self saveCookie:task];
    success();
  } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
    failure(error);
  }];
}

- (void)logOutWithSuccess:(DictionarySuccessBlock)success andFailure:(FailureBlock)failure {
    [self GET:kPathLogout parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        MLLog(@"Got get result: %@", responseObject);
        [Defaults removeSessionCookie];
        
        [self.requestSerializer setValue:nil forHTTPHeaderField:@"Cookie"];
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failure(error);
    }];
}


//http://api.societly.com/default/en/customers/current/submissions
- (void) getLatestSubmissionwithSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure {
    
    [self.requestSerializer setValue:[Defaults getSessionCookie] forHTTPHeaderField:@"Cookie"];
    [self GET:kPathSubmissionPrivate parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {

        NSLog(@"List of subs: %@", responseObject);
        NSString *clientHach = @"";
        
        if ([responseObject isKindOfClass:[NSArray class]] && [(NSArray *)responseObject count] > 0) {
            clientHach = [[responseObject objectAtIndex:0] objectForKey:@"client_hash"];
        } else {
            success();
            return;
        }
        
        NSString *urlPathForLatestSubmission = [NSString stringWithFormat:@"%@/%@",kPathSubmissionPublic,clientHach];
       
        [self GET:urlPathForLatestSubmission parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            
            NSArray *answersArray;
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
               answersArray = [[responseObject objectAtIndex:0] objectForKey:kKeyAnswers];
            } else {
               answersArray = [responseObject objectForKey:kKeyAnswers];
            }
            
            QuestionSet *currentQuestionSet = [[Database sharedInstance] userQuestionSet];
            
            for (NSDictionary *answerDictionary in answersArray) {
                NSString *questionId = [NSString stringWithFormat:@"%@",[answerDictionary objectForKey:kKeyQuestionId]] ;
                Question *question = [currentQuestionSet questionWithId:questionId];
                if (!question) {
                    question = [Question insertInManagedObjectContext:[[Database sharedInstance] managedObjectContext]];
                    question.questionId = questionId;
                    [currentQuestionSet addQuestionsObject:question];
                }
                
                question.answerValue = [[answerDictionary objectForKey:kKeyAnswer] integerValue];
                [[Database sharedInstance] saveContext:nil];
            }
        
            success();
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            failure(error);
        }];
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        failure(error);
    }];
}

- (void) saveCookie:(NSURLSessionDataTask *) task {

    NSHTTPURLResponse *response = (NSHTTPURLResponse *)[task response];
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionary = [response allHeaderFields];
        [Defaults setSessionCookie:[dictionary objectForKey:@"Set-Cookie"]]; // Save the session cookie to reuse later on.
    }
}

@end
