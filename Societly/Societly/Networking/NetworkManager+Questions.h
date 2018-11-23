//
//  NetworkManager+Questions.h
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Questions)

- (void)listQuestionsWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure;

- (void)sendAnswersForEmail:(NSString *)email withSuccess:(EmptyBlock)success andFailure:(FailureBlock)failure;

@end
