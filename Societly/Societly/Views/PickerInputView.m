//
//  PickerInputView.m
//  Societly
//
//  Created by Katrin Annuk on 28/10/16.
//  Copyright © 2016 MobiLab. All rights reserved.
//

#import "PickerInputView.h"
#import "PickerCell.h"
#import "UIColor+Additions.h"
@interface PickerInputView() <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSIndexPath *selectedPath;
@end

@implementation PickerInputView

- (void)awakeFromNib {
  [super awakeFromNib];
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.tableView.allowsSelection = NO;
  
  // Adding some padding to top and bottom of tableview so first and last items could be scrolled to the middle of tableview.
  UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
  header.backgroundColor = [UIColor clearColor];
  [self.tableView setTableHeaderView:header];
  
  [self.tableView setTableFooterView:header];

  UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([PickerCell class]) bundle:nil];
  [self.tableView registerNib:cellNib forCellReuseIdentifier:NSStringFromClass([PickerCell class])];
  
  [self scrollViewDidScroll:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PickerCell *cell = (PickerCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PickerCell class]) forIndexPath:indexPath];
  
  if (indexPath.row == self.selectedPath.row) {
    cell.nameLabel.textColor = [UIColor whiteColor];
  } else {
    cell.nameLabel.textColor = [UIColor themePickerTextColor];
  }
  
  cell.nameLabel.text = self.titles[indexPath.row];
  return cell;
}

- (void)setSelectedRow:(NSUInteger)row {
  if (row == NSNotFound) {
    row = 0;
  }
  self.selectedPath = [NSIndexPath indexPathForRow:row inSection:0];
  
  // Calling dispatch_async will give input view time to set up
  dispatch_async(dispatch_get_main_queue(), ^{
    
    if ([self.tableView numberOfRowsInSection:0] > row) {
      [self.tableView scrollToRowAtIndexPath:self.selectedPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    }
  });
}

- (NSUInteger)selectedRow {
  return self.selectedPath.row;
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
  if (!decelerate) {
    [self.tableView scrollToRowAtIndexPath:self.selectedPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
  }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
  [self.tableView scrollToRowAtIndexPath:self.selectedPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
  CGRect tableRect = self.tableView.bounds;
  CGFloat tableCenter = tableRect.size.height / 2;
  
  for (PickerCell *cell in self.tableView.visibleCells) {
    CGRect rect = [cell.contentView convertRect:cell.contentView.frame toView:self];
    
    if (rect.origin.y <= tableCenter && CGRectGetMaxY(rect) >= tableCenter) {
      NSIndexPath *path = [self.tableView indexPathForCell:cell];

      if (path.row != self.selectedPath.row) {
        self.selectedPath = path;
      }
      cell.nameLabel.textColor = [UIColor whiteColor];
    } else {
      cell.nameLabel.textColor = [UIColor themePickerTextColor];
    }
  }
}


@end
