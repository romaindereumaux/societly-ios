//
//  NetworkManager+Candidates.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NetworkManager+Candidates.h"
#import "Database+Candidate.h"

@implementation NetworkManager (Candidates)

- (void)listCandidatesWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure {
  NSString *path = [NSString stringWithFormat:@"%@?per_page=%i", kPathCandidates, 250];
  [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    if ([responseObject isKindOfClass:[NSArray class]]) {
      NSArray *responseArray = (NSArray *)responseObject;
      MLLog(@"Loaded %lu candidates", (unsigned long)responseArray.count);
      [[Database sharedInstance] addCandidatesFromArray:responseArray];
      success(nil);
    } else {
      MLLog(@"Wrong type from network request");
      failure(nil);
    }
  } failure:^(NSURLSessionDataTask *task, NSError *error) {
    failure(error);
  }];
}

@end
