//
//  Defaults.m
//  Societly
//
//  Created by Lauri Eskor on 13/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "Defaults.h"

NSString *const kStartupDate = @"startDate";
NSString *const kFirstQuestionDate = @"firstQuestionDate";
NSString *const kLastVersion = @"lastVersion";
NSString *const kSessionCookie = @"sessionCookie";

@implementation Defaults

+ (void)setLaunchDate:(NSDate *)launchDate {
    [self putObject:launchDate forKey:kStartupDate];
}

+ (NSDate *)getLaunchDate {
    return [self getSettingForKey:kStartupDate withDefault:[NSDate date]];
}

+ (void)setFirstQuestionDate:(NSDate *)firstQuestionDate {
    [self putObject:firstQuestionDate forKey:kFirstQuestionDate];
}

+ (NSDate *)getFirstQuestionDate {
    return [self getSettingForKey:kFirstQuestionDate withDefault:[NSDate date]];
}

+ (void)setLastVersion:(NSString *)lastVersion {
    [self putObject:lastVersion forKey:kLastVersion];
}

+ (NSString *)getLastVersion {
    return [self getSettingForKey:kLastVersion withDefault:nil];
}

+(void) setSessionCookie:(NSString *) sessionCookie {
    [self putObject:sessionCookie forKey:kSessionCookie];
}

+(NSString *) getSessionCookie {
    return [self getSettingForKey:kSessionCookie withDefault:nil];
}

+(void) removeSessionCookie {
    [self putObject:nil forKey:kSessionCookie];
}

#pragma mark - Object save-retrieve
+ (void)putObject:(id)object forKey:(NSString *)key {
    if (!key ) {
        return;
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (!object) {
        [defaults removeObjectForKey:key];
    } else {
        [defaults setObject:object forKey:key];
    }
    [defaults synchronize];
}

+ (void)putBool:(BOOL)boolValue forKey:(NSString *)key {
    [[NSUserDefaults standardUserDefaults] setBool:boolValue forKey:key];
    BOOL success = [[NSUserDefaults standardUserDefaults] synchronize];
    if (!success) {
        MLLog(@"WARNING: Unable to save bool value %@ for key %@", boolValue ? @"YES" : @"NO", key);
    }
}

+ (id)getSettingForKey:(NSString *)key withDefault:(id)defaultValue {
    NSObject *result = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (!result) {
        
        // if default = nil, return nil and don't set default
        if (!defaultValue) {
            return nil;
        }
        
        [self putObject:defaultValue forKey:key];
        return defaultValue;
    } else {
        return result;
    }
}

+ (BOOL)getBoolForKey:(NSString *)key withDefault:(BOOL)defaultValue {
    BOOL result;
    NSObject *object = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (object) {
        result = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    } else {
        [self putBool:defaultValue forKey:key];
        result = defaultValue;
    }
    return result;
}

@end

