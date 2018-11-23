//
//  CandidateListCell.m
//  Societly
//
//  Created by Lauri Eskor on 29/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CandidateListCell.h"
#import "UIImageView+AFNetworking.h"
#import "UIView+Additions.h"
#import "UIColor+Additions.h"

@interface CandidateListCell ()
@property (weak, nonatomic) IBOutlet UIImageView *candidateImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *partyLabel;
@property (weak, nonatomic) IBOutlet UILabel *precentLabel;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@end

@implementation CandidateListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.candidateImage makeRound];
    [self.progressView roundCornersWithRadius:5];
    [self.progressView setTrackTintColor:[UIColor themeSliderEmptyTrackColor]];
    [self.progressView setProgressTintColor:[UIColor themeSliderFullTrackColor]];
    [self.nameLabel setTextColor:[UIColor themeSliderFullTrackColor]];
    [self.partyLabel setTextColor:[UIColor themeLightDarkTextColor]];
    [self.precentLabel setTextColor:[UIColor themeSliderFullTrackColor]];
}

- (void)configureWithCandidate:(Candidate *)candidate andPrecent:(CGFloat)precent forIndex:(NSInteger)index {

    // Allow nil candidate for testing.
    if (!candidate) {
        return;
    }
    
    [self.candidateImage setImage:nil];
    if (candidate.imageUrl) {
        NSURL *url = [NSURL URLWithString:candidate.imageUrl];
        [self.candidateImage setImageWithURL:url];
    }

    [self.nameLabel setText:candidate.name];
    [self.partyLabel setText:candidate.party];

    CGFloat precent100 = precent / 100;
    NSInteger roundedPercent = lroundf(precent);
    [self.precentLabel setText:[NSString stringWithFormat:@"%ld%%", (long)roundedPercent]];
    [self.progressView setProgress:precent100];
}

@end
