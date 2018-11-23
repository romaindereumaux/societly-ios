//
//  NavigationHelper.h
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NavigationHelper : NSObject
+ (void)setupFirstViewOnWindow:(UIWindow *)window;
+ (void)setMainViewOnNavController:(UINavigationController *)navigationController;
+ (void) setViewControllerAfterLogin:(UINavigationController *) navigationController;

@end
