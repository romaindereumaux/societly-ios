//
//  BaseViewController.m
//  Societly
//
//  Created by Lauri Eskor on 16/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];
  self.topConstraint.constant = [self.topLayoutGuide length];
}

@end
