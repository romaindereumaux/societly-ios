//
//  CandidateDetailViewController.m
//  Societly
//
//  Created by Lauri Eskor on 28/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "CandidateDetailViewController.h"

@interface CandidateDetailViewController ()

@property (nonatomic, strong) Candidate *candidate;

@end

@implementation CandidateDetailViewController

- (id)initWithCandidate:(Candidate *)candidate {
    self = [super initWithNibName:NSStringFromClass([CandidateDetailViewController class]) bundle:nil];
    if (self) {
        self.candidate = candidate;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


@end
