//
//  NetworkManager.h
//  Societly
//
//  Created by Lauri Eskor on 25/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "AFHTTPSessionManager.h"
#import "NetworkConstants.h"

@interface NetworkManager : AFHTTPSessionManager

+ (NetworkManager *)sharedInstance;

@end
