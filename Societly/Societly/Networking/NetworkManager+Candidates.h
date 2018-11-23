//
//  NetworkManager+Candidates.h
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (Candidates)

- (void)listCandidatesWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure;

@end
