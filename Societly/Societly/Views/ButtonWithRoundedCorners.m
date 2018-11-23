//
//  ButtonWithRoundedCorners.m
//  Societly
//
//  Created by Katrin Annuk on 26/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "ButtonWithRoundedCorners.h"

@implementation ButtonWithRoundedCorners

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateColors];
}

- (void)initialize {
    self.layer.borderWidth = _borderWidth ? _borderWidth : 1;
    self.layer.borderColor = _borderColor ? _borderColor.CGColor : [UIColor clearColor].CGColor;
    self.layer.cornerRadius = _cornerRadius ? _cornerRadius : 6;
    self.clipsToBounds = YES;

    [self updateColors];
}

- (void)setDefaultBgColor:(UIColor *)defaultBgColor {
    _defaultBgColor = defaultBgColor;
    [self setBackgroundColor:[UIColor clearColor]];
    [self updateColors];
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    [self updateColors];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    
    [self updateColors];
}

- (void)updateColors {
    if (!self.isEnabled) {
        self.layer.backgroundColor = _disabledBgColor ? _disabledBgColor.CGColor : [UIColor whiteColor].CGColor;
    } else if(self.isHighlighted) {
        self.layer.backgroundColor = _highlightedBgColor ? _highlightedBgColor.CGColor : [UIColor whiteColor].CGColor;
    } else {
        self.layer.backgroundColor = _defaultBgColor ? _defaultBgColor.CGColor : [UIColor whiteColor].CGColor;
    }
}

@end
