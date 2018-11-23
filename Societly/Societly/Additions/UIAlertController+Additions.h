//
//  UIAlertController+Additions.h
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (Additions)

+ (UIAlertController *)errorAlertForError:(NSError *)error;
+ (UIAlertController *)errorAlertForError:(NSError *)error handler:(void (^)(UIAlertAction *action))handler;
@end
