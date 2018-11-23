//
//  ComparisonHeaderView.m
//  Societly
//
//  Created by Lauri Eskor on 02/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "ComparisonHeaderView.h"
#import "UIColor+Additions.h"
#import "UIView+Additions.h"
#import "UIImageView+AFNetworking.h"

@interface ComparisonHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *youLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView;
@property (weak, nonatomic) IBOutlet UIImageView *candidateImageView;
@property (weak, nonatomic) IBOutlet UILabel *candidateNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;

@end

@implementation ComparisonHeaderView

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.youLabel setTextColor:[UIColor themeSliderFullTrackColor]];
  [self.candidateNameLabel setTextColor:[UIColor themeSliderFullTrackColor]];
  [self.partyLabel setTextColor:[UIColor themeLightDarkTextColor]];
  [self.candidateImageView makeRound];
}

- (void)configureWithCandidate:(Candidate *)candidate {
  [self.candidateImageView setImage:nil];
  
  if ([candidate.imageUrl length] > 0) {
    NSURL *imageUrl = [NSURL URLWithString:candidate.imageUrl];
    [self.candidateImageView setImageWithURL:imageUrl];
  }
  [self.candidateNameLabel setText:candidate.name];
  
  if ([candidate.imageUrl length] > 0) {
    NSURL *imageUrl = [NSURL URLWithString:candidate.imageUrl];
    [self.candidateImageView setImageWithURL:imageUrl];
  }
  
  [self.partyLabel setText:candidate.party];
}

@end
