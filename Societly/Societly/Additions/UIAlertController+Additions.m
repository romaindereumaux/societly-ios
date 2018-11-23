//
//  UIAlertController+Additions.m
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "UIAlertController+Additions.h"

@implementation UIAlertController (Additions)

+ (UIAlertController *)errorAlertForError:(NSError *)error {
    return [self errorAlertForError:error handler:nil];
}

+ (UIAlertController *)errorAlertForError:(NSError *)error handler:(void (^)(UIAlertAction *action))handler {
    NSString *errorMessage = [error localizedDescription];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:handler]];
    
    return alert;
}
@end
