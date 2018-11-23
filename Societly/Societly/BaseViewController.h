//
//  BaseViewController.h
//  Societly
//
//  Created by Lauri Eskor on 16/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

/** 
 UIViewcontroller subclass that will move content out of top layout guide
 **/
@interface BaseViewController : UIViewController

@property (nonatomic, strong) IBOutlet NSLayoutConstraint *topConstraint;

@end
