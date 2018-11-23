//
//  NetworkManager+States.h
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "NetworkManager.h"

@interface NetworkManager (States)
- (void)listStatesWithSuccess:(ArraySuccessBlock)success andFailure:(FailureBlock)failure;

@end
