//
//  CandidateListFooter.m
//  Societly
//
//  Created by Lauri Eskor on 01/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CandidateListFooter.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"

@interface CandidateListFooter ()
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation CandidateListFooter

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.label setText:NSLocalizedString(@"you can reset", nil)];
    [self.resetButton setTitle:[NSLocalizedString(@"reset", nil) uppercaseString] forState:UIControlStateNormal];
    [self.resetButton setBackgroundColor:[UIColor themeSliderFullTrackColor]];
    [self.resetButton roundCornersWithRadius:3];
    [self.label setTextColor:[UIColor themeSliderFullTrackColor]];
}

- (IBAction)buttonPressed:(id)sender {
    [self.delegate resetPressed];
}

@end
