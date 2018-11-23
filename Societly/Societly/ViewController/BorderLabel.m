//
//  BorderLabel.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "BorderLabel.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"
#import "PureLayout.h"

@interface BorderLabel ()

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *constraints;

@end

@implementation BorderLabel
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}

- (void)setup {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
    UIView *subView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
    [self addSubview:subView];
    [subView autoPinEdgesToSuperviewEdges];
    
//    subView.frame = self.bounds;
    [self setUserInteractionEnabled:YES];
    
    self.borderWidth = 3;
    self.borderColor = [UIColor themeDarkTextColor];
}

- (void)setText:(NSString *)text allowShrink:(BOOL)allowShrink {
    [self.label setText:text];
    [self invalidateIntrinsicContentSize];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self addLabelBorderWithWidth:borderWidth andColor:self.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    [self setBorderWidth:self.borderWidth];
}

#pragma mark - IB support
- (void)drawRect:(CGRect)rect {
#if TARGET_INTERFACE_BUILDER
    UIFont* font = [UIFont fontWithName:@"Arial" size:15];
    UIColor* textColor = [UIColor redColor];
    NSDictionary* stringAttrs = @{ UITextAttributeFont : font, UITextAttributeTextColor : textColor };
    NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"Label" attributes:stringAttrs];
    
    [attrStr drawAtPoint:CGPointMake(10.f, 10.f)];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect viewFrame = self.bounds;
    CGContextSetLineWidth(context, 2);
    CGRectInset(viewFrame, 10, 10);
    [[UIColor greenColor] set];
    UIRectFrame(viewFrame);
#endif
}

@end
