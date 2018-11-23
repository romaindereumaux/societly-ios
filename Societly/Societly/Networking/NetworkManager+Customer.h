//
//  NetworkManager+Customer.h
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Customer)
- (void)signUpWithEmail:(NSString *)email andPassword:(NSString *)password withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure;
- (void)signUpWithToken:(NSString *)accessToken andProvider:(NSString *)provider withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure;
- (void)signInWithEmail:(NSString *)email andPassword:(NSString *)password withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure;
- (void)signInWithToken:(NSString *)accessToken andProvider:(NSString *)provider withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure;
- (void)logOutWithSuccess:(DictionarySuccessBlock)success andFailure:(FailureBlock)failure;

- (void)getLatestSubmissionwithSuccess:(EmptyBlock) success andFailure:(FailureBlock) failure;
@end
