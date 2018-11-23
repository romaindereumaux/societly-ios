//
//  PickerInputView.h
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickerInputView : UIView
@property (strong, nonatomic) NSArray *titles;

- (void)setSelectedRow:(NSUInteger)row;
- (NSUInteger)selectedRow;
@end
