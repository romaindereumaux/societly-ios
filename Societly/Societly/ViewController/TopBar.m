//
//  TopBar.m
//  Societly
//
//  Created by Lauri Eskor on 30/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "TopBar.h"
#import "UIColor+Additions.h"
#import "UIFont+Additions.h"

@interface TopBar ()

@end

@implementation TopBar

@synthesize currentQuestion = _currentQuestion;

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
  }
  return self;
}

- (void)setup {
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
  UIView *subView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
  subView.frame = self.bounds;
  [self setBackgroundColor:[UIColor clearColor]];
  [self addSubview:subView];
  [self setUserInteractionEnabled:YES];
  
  [self.nextButton setTransform:CGAffineTransformMakeRotation(M_PI)];
  
  [self.titleLabel setTextColor:[UIColor whiteColor]];
  [self.titleLabel setFont:[UIFont themeNavigationBarLargeFont]];
}

- (void)refreshView {
  [self.titleLabel setText:[NSString stringWithFormat:@"%ld/%ld", (long)self.currentQuestion, (long)self.totalQuestions]];
}

- (void)useDarkColors {
  UIImage *backImage = [UIImage imageNamed:@"icn_back"];
  [self.previousButton setImage:backImage forState:UIControlStateNormal];

  [self.titleLabel setFont:[UIFont themeNavigationBarSmallFont]];

  [self.titleLabel setTextColor:[UIColor themeDarkTextColor]];
}

- (void)setCurrentQuestion:(NSInteger)currentQuestion {
  _currentQuestion = currentQuestion;
  
  [self refreshView];
}

- (IBAction)nextTapped:(id)sender {
  [self.delegate nextPressed];
}

- (IBAction)previousTapped:(id)sender {
  [self.delegate previousPressed];
}

#pragma mark - IB support
- (void)drawRect:(CGRect)rect {
#if TARGET_INTERFACE_BUILDER
  UIFont* font = [UIFont fontWithName:@"Arial" size:15];
  UIColor* textColor = [UIColor redColor];
  NSDictionary* stringAttrs = @{ UITextAttributeFont : font, UITextAttributeTextColor : textColor };
  NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:@"Top bar" attributes:stringAttrs];
  
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
