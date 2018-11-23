//
//  BorderLabel.h
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

IB_DESIGNABLE
@interface BorderLabel : UIView


@property (weak, nonatomic) IBOutlet UILabel *label;
@property (assign, nonatomic) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;

- (void)setText:(NSString *)text allowShrink:(BOOL)allowShrink;

@end
