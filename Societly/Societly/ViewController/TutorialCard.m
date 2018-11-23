//
//  TutorialCard.m
//  Societly
//
//  Created by Lauri Eskor on 29/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "TutorialCard.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"

@interface TutorialCard ()
@property (weak, nonatomic) IBOutlet UILabel *skipLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *disagreeLabel;
@property (weak, nonatomic) IBOutlet UILabel *neutralLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *downArrow;
@property (weak, nonatomic) IBOutlet UIImageView *rightArrow;
@property (weak, nonatomic) IBOutlet UIImageView *upArrow;
@property (weak, nonatomic) IBOutlet UIImageView *leftArrow;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic, strong) UIView *subView;

@end

@implementation TutorialCard

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self setup];
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

- (void)setup {
  [self setTranslatesAutoresizingMaskIntoConstraints:NO];
  UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
  self.subView = [[nib instantiateWithOwner:self options:nil] objectAtIndex:0];
  self.subView.frame = self.bounds;
  [self.subView setClipsToBounds:YES];

  [self addSubview:self.subView];
  [self setUserInteractionEnabled:YES];
}

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self.agreeLabel setText:[NSLocalizedString(@"agree", nil) uppercaseString]];
  [self.disagreeLabel setText:[NSLocalizedString(@"disagree", nil) uppercaseString]];
  [self.skipLabel setText:[NSLocalizedString(@"skip", nil) uppercaseString]];
  [self.neutralLabel setText:[NSLocalizedString(@"neutral", nil) uppercaseString]];
  [self.agreeLabel setTextColor:[UIColor themeDarkTextColor]];
  [self.disagreeLabel setTextColor:[UIColor themeDarkTextColor]];
  [self.skipLabel setTextColor:[UIColor themeDarkTextColor]];
  [self.neutralLabel setTextColor:[UIColor themeDarkTextColor]];

  [self.disagreeLabel setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
  [self.agreeLabel setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
  
  [self.middleLabel setText:NSLocalizedString(@"tutorial text", nil)];
  [self.middleLabel setTextColor:[UIColor themeDarkTextColor]];
  
  [self.leftArrow setTransform:CGAffineTransformMakeRotation(-M_PI / 2)];
  [self.rightArrow setTransform:CGAffineTransformMakeRotation(M_PI / 2)];
  [self.downArrow setTransform:CGAffineTransformMakeRotation(-M_PI)];
}

- (void)addShadow {
  [self.subView roundCornersWithRadius:11];
  [self addCardShadow];
}
@end
