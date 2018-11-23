//
//  StackView.h
//  Societly
//
//  Created by Lauri Eskor on 06/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//
#import "TopBar.h"

IB_DESIGNABLE
@protocol StackViewDelegate <NSObject>

- (void)lastCardWasSwiped;
- (void)pressedPreviousInFirstCard;
- (void)pressedNext;

@end

@interface StackView : UIView

@property (nonatomic, weak) id <StackViewDelegate> delegate;

- (void)reloadCardsScrollToFirstUnanswered:(BOOL)scroll;

@property (weak, nonatomic) IBOutlet TopBar *topBar;
@property (nonatomic, assign) BOOL tutorialVisible;

@end
