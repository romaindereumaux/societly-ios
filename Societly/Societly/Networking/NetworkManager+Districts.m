//
//  NetworkManager+Districts.m
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "NetworkManager+Districts.h"
#import "Database+District.h"

@implementation NetworkManager (Districts)

- (void)listDistrictsWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure {
  NSString *path = [NSString stringWithFormat:@"%@?per_page=%i", kPathDistricts, 250];
  
  [self GET:path parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
    MLLog(@"Response: %@", responseObject);
    if ([responseObject isKindOfClass:[NSArray class]]) {
      
      NSArray *responseArray = (NSArray *)responseObject;
      MLLog(@"Loaded %i districts", responseArray.count);
      
      [[Database sharedInstance] addDistrictsFromArray:responseArray];
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
