//
//  PickerView.h
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol PickerViewDelegate;

@interface PickerView : UIView
@property (nonatomic, strong) NSArray *itemTitles;
@property (nonatomic, strong) NSString *selectedItemTitle;
@property (nonatomic, strong) NSString *pickerTitle;
@property (nonatomic, strong) id<PickerViewDelegate> delegate;
@end

@protocol PickerViewDelegate <NSObject>
- (void)picker:(PickerView *)pickerView selectedTitle:(NSString *)title;

@end
