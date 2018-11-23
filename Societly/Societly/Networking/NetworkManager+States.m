//
//  NetworkManager+States.m
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "NetworkManager+States.h"
#import "Database+State.h"

@implementation NetworkManager (States)

- (void)listStatesWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure {
  
  NSString *path = [NSString stringWithFormat:@"%@?per_page=%i", kPathStates, 250];
  [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    MLLog(@"Response: %@", responseObject);
    if ([responseObject isKindOfClass:[NSArray class]]) {
      
      NSArray *responseArray = (NSArray *)responseObject;
      MLLog(@"Loaded %i states", responseArray.count);
      
      [[Database sharedInstance] addStatesFromArray:responseArray];
      success(nil);
    } else {
      MLLog(@"Wrong type from network request");
      failure(nil);
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    MLLog(@"Error: %@", error);
    failure(error);
  }];
}
@end
