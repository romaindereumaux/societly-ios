//
//  NetworkManager.m
//  Societly
//
//  Created by Lauri Eskor on 25/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "NetworkManager.h"
#import "AFNetworkActivityLogger.h"

@implementation NetworkManager

static NetworkManager *sharedInstance = nil;

+ (NetworkManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[NetworkManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        [serializer setRemovesKeysWithNullValues:YES];
        sharedInstance.responseSerializer = serializer;
        
        sharedInstance.requestSerializer = [AFJSONRequestSerializer serializer];
        [sharedInstance.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        [sharedInstance.requestSerializer setAuthorizationHeaderFieldWithUsername:kApiUsername password:kApiPassword];
        
        [[AFNetworkActivityLogger sharedLogger] startLogging];
        [[AFNetworkActivityLogger sharedLogger] setLevel:AFLoggerLevelError];
        
        // Add disc cache
        
        NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:0 diskCapacity:100 * 1024 * 1024 diskPath:nil];
        [NSURLCache setSharedURLCache:sharedCache];
    }
    return sharedInstance;
}

@end
