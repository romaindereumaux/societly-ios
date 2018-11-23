//
//  Defaults.h
//  Societly
//
//  Created by Lauri Eskor on 13/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

@interface Defaults : NSObject

+ (void)setLaunchDate:(NSDate *)launchDate;
+ (NSDate *)getLaunchDate;

+ (void)setFirstQuestionDate:(NSDate *)firstQuestionDate;
+ (NSDate *)getFirstQuestionDate;

+ (void)setLastVersion:(NSString *)lastVersion;
+ (NSString *)getLastVersion;

+(void) setSessionCookie:(NSString *) sessionCookie;
+(NSString *) getSessionCookie;
+(void) removeSessionCookie;

@end
