//
//  TopBar.h
//  Societly
//
//  Created by Lauri Eskor on 30/09/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

IB_DESIGNABLE

@protocol TopBarDelegate <NSObject>

- (void)previousPressed;
- (void)nextPressed;

@end

@interface TopBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *previousButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, assign) NSInteger totalQuestions;
@property (nonatomic, assign) NSInteger currentQuestion;
@property (nonatomic, weak) id <TopBarDelegate> delegate;

/** 
 Use dark colors
 **/
- (void)useDarkColors;

@end
