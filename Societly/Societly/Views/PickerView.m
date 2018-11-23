//
//  PickerView.m
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "PickerView.h"
#import "PickerAccessoryView.h"
#import "PickerInputView.h"
#import "UIColor+Additions.h"

@interface PickerView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) PickerInputView* inputView;
@end

@implementation PickerView

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
  [self addSubview:subView];
  
  self.layer.borderColor = [UIColor themePickerTextColor].CGColor;
  self.layer.borderWidth = 1.0f;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  self.icon.transform = CGAffineTransformMakeRotation(M_PI + M_PI_2);
  self.icon.image = [self.icon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)setSelectedItemTitle:(NSString *)selectedItemTitle {
  _selectedItemTitle = selectedItemTitle;
  [self updateTitle];
}


- (void)setPickerTitle:(NSString *)pickerTitle {
  _pickerTitle = pickerTitle;
  [self updateTitle];
}

- (void)updateTitle {
  if (!self.selectedItemTitle || self.selectedItemTitle.length == 0) {
    self.titleLabel.text = self.pickerTitle;
    self.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor themePickerTextColor];
    [self.icon setTintColor:[UIColor themePickerTextColor]];

  } else {
    self.titleLabel.text = self.selectedItemTitle;
    self.backgroundColor = [UIColor themePickerTextColor];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.icon setTintColor:[UIColor whiteColor]];

  }
}

- (UIView *)inputView {
  if (!_inputView) {
    _inputView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PickerInputView class]) owner:self options:nil] objectAtIndex:0];
    _inputView.autoresizingMask = UIViewAutoresizingNone;
    _inputView.titles = self.itemTitles;
  }
  if ([self.itemTitles containsObject:self.selectedItemTitle]) {
    [_inputView setSelectedRow:[self.itemTitles indexOfObject:self.selectedItemTitle]];

  } else {
    [_inputView setSelectedRow:0];
  }

  return _inputView;
}

- (UIView *)inputAccessoryView {
  PickerAccessoryView* accessoryView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([PickerAccessoryView class]) owner:self options:nil] objectAtIndex:0];
  accessoryView.titleLabel.text = self.pickerTitle;
  [accessoryView.doneButton addTarget:self action:@selector(doneTapped:) forControlEvents:UIControlEventTouchUpInside];
  [accessoryView.clearButton addTarget:self action:@selector(clearTapped:) forControlEvents:UIControlEventTouchUpInside];

  return accessoryView;
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (IBAction)pickerTapped:(id)sender {
  [self becomeFirstResponder];
}

- (IBAction)doneTapped:(id)sender {
  int row = (int)[_inputView selectedRow];
  [self confirmSelection:self.itemTitles[row]];
}

- (IBAction)clearTapped:(id)sender {
  [self confirmSelection:nil];
}

- (void)confirmSelection:(NSString *)selected {
  self.selectedItemTitle = selected;
  if (self.delegate) {
    [self.delegate picker:self selectedTitle:selected];
  }
  [self updateTitle];
  [self resignFirstResponder];
}

@end
