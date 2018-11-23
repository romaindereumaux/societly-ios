//
//  StackedLayout.m
//  Societly
//
//  Created by Lauri Eskor on 06/10/15.
//  Copyright © 2015 MobiLab. All rights reserved.
//

#import "StackedLayout.h"
#import "UIView+Additions.h"
#import "CGRectUtility.h"

// Speed what will cancel pan and enable swipe
CGFloat const kSpeedToStartSwipe = 400;

// Distance from center that will not change card color
CGFloat const kCenterDeadDistance = 0;

// Distance offscreen cells are moved away from screen
CGFloat const kOffscreenDistance = 50;

// Number of cards to draw on screen at a time
NSInteger const kNumberOfDrawedCards = 2;

// Distance from screen side to card
NSInteger const kCardSidePadding = 20;

@interface StackedLayout ()

@property (nonatomic, assign) CGFloat minimumXPanDistanceToSwipe;
@property (nonatomic, assign) CGFloat minimumYPanDistanceToSwipe;

@property (nonatomic, strong) NSIndexPath *draggedIndexPath;
@property (nonatomic, assign) CGPoint initialCellCenter;

@property (nonatomic, assign) BOOL animationInProgress;
@end

@implementation StackedLayout
@synthesize index = _index;

- (id)init {
  self = [super init];
  if (self) {
    _index = 0;
  }
  return self;
}

- (void)prepareLayout {
  self.minimumXPanDistanceToSwipe = self.collectionView.frame.size.width / 3;
  self.minimumYPanDistanceToSwipe = self.collectionView.frame.size.height / 3;
}

- (void)setIndex:(NSInteger)index {
  if (self.draggedIndexPath) {
    if (_index > index) {
      self.draggedIndexPath = [NSIndexPath indexPathForItem:index inSection:0];
    } else {
      self.draggedIndexPath = [NSIndexPath indexPathForItem:_index inSection:0];
    }
  }
  
  _index = index;
  
  self.animationInProgress = YES;
  [UIView animateWithDuration:0.2 animations:^{
    [self invalidateLayout];
    [self.delegate cardChangedStateWithIndex:index];
  } completion:^(BOOL finished) {
    if (finished) {
      self.animationInProgress = NO;
    }
  }];
}

- (CGSize)itemSize {
  CGSize itemSize = CGSizeMake(self.collectionView.frame.size.width - 2 * kCardSidePadding, self.collectionView.frame.size.height - 2 * kCardSidePadding);
  return itemSize;
}

- (CGSize)collectionViewContentSize {
  return self.collectionView.frame.size;
}

- (void)scrollToNextCard {
  self.draggedIndexPath = nil;
  self.index += 1;
}

- (void)scrollToPreviousCard {
  self.draggedIndexPath = nil;
  self.index -= 1;
}

#pragma mark - Recognizer handling
- (void)panRecognized:(UIPanGestureRecognizer *)recognizer {
  
  // Cancel recognizer if an animation is in progress
  if (self.animationInProgress) {
    [recognizer setEnabled:NO];
    [recognizer setEnabled:YES];
    return;
  }
  
  if (recognizer.state == UIGestureRecognizerStateBegan) {
    [self.delegate fingerDown:YES];
    self.draggedIndexPath = [NSIndexPath indexPathForItem:self.index inSection:0];
    UICollectionViewCell *draggedCell = [self.collectionView cellForItemAtIndexPath:self.draggedIndexPath];
    
    // Some problem with z-index?? Need to bring this cell to front
    self.initialCellCenter = draggedCell.center;
    [self.collectionView bringSubviewToFront:draggedCell];
    
  } else if (recognizer.state == UIGestureRecognizerStateChanged) {
    UICollectionViewCell *draggedCell = [self.collectionView cellForItemAtIndexPath:self.draggedIndexPath];
    
    CGPoint translation = [recognizer translationInView:self.collectionView];
    
    CGFloat newCenterX = self.initialCellCenter.x + translation.x;
    CGFloat newCenterY = self.initialCellCenter.y + translation.y;
    
    draggedCell.center = CGPointMake(newCenterX, newCenterY);
    draggedCell.transform = CGAffineTransformMakeRotation([UIView angleOfRotationForView:draggedCell]);
    
    CGFloat distanceFromCenter = sqrtf(powf(translation.x, 2) + powf(translation.y, 2));
    
    // Only change card color if distance is large enough
    if (distanceFromCenter > kCenterDeadDistance) {
      [self.delegate swipingCell:draggedCell toPosition:[StackedLayout positionWithCenterPoint:draggedCell.center fromCenterPoint:self.initialCellCenter] withDistanceFromCenter:distanceFromCenter];
    } else {
      [self.delegate swipingCell:draggedCell toPosition:PositionTypeNothing withDistanceFromCenter:distanceFromCenter];
    }
    
  } else {
    UICollectionViewCell *draggedCell = [self.collectionView cellForItemAtIndexPath:self.draggedIndexPath];
    
    CGFloat deltaX = draggedCell.center.x - self.initialCellCenter.x;
    CGFloat deltaY = draggedCell.center.y - self.initialCellCenter.y;
    
    // Snap back if not dragged far enough
    BOOL shouldSnapBack = (fabs(deltaX) < self.minimumXPanDistanceToSwipe && fabs(deltaY) < self.minimumYPanDistanceToSwipe);
    
    if (shouldSnapBack) {
      self.animationInProgress = YES;
      [UIView animateWithDuration:0.2 animations:^{
        [draggedCell setCenter:self.initialCellCenter];
        [draggedCell setTransform:CGAffineTransformIdentity];
      } completion:^(BOOL finished) {
        [self.collectionView reloadItemsAtIndexPaths:@[self.draggedIndexPath]];
        self.draggedIndexPath = nil;
        self.animationInProgress = NO;
        [self.delegate fingerDown:NO];

      }];
    } else {
      
      PositionType position = [StackedLayout positionWithCenterPoint:draggedCell.center fromCenterPoint:self.initialCellCenter];
      CGRect finalRect = [StackedLayout frameForPosition:position withStartingFrame:self.collectionView.bounds];
      CGPoint finalCenterPoint = [CGRectUtility centerOfRect:finalRect];
      
      self.animationInProgress = YES;
      [UIView animateWithDuration:0.2 animations:^{
        [draggedCell setCenter:finalCenterPoint];
        draggedCell.transform = CGAffineTransformIdentity;
      } completion:^(BOOL finished) {
        // Move card away from screen
        [self.delegate swipedCardWithIndex:self.index toPosition:position];
        self.draggedIndexPath = nil;
        self.index += 1;
        self.animationInProgress = NO;
        [self.delegate fingerDown:NO];
      }];
    }
  }
}

+ (PositionType)positionWithCenterPoint:(CGPoint)centerPoint fromCenterPoint:(CGPoint)originalCenterPoint {
  CGFloat deltaX = centerPoint.x - originalCenterPoint.x;
  CGFloat deltaY = centerPoint.y - originalCenterPoint.y;
  
  PositionType position;
  // Larger vertical movement
  if (fabs(deltaY) > fabs(deltaX)) {
    if (deltaY > 0) {
      position = PositionTypeSkip;
    } else {
      position = PositionTypeNeutral;
    }
  } else {
    if (deltaX < 0) {
      position = PositionTypeNo;
    } else {
      position = PositionTypeYes;
    }
  }
  return position;
}

#pragma mark - CollectionViewLayout methods
- (NSArray <UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
  
  NSMutableArray *resultAttributesArray = [NSMutableArray array];
  for (int i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++) {
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    [resultAttributesArray addObject:attributes];
  }
  
  return resultAttributesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewLayoutAttributes *originalAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
  UICollectionViewLayoutAttributes *attributes = [originalAttributes copy];
  
  if (indexPath.item >= self.index) {
    attributes = [self layoutAttributesForTopStackItemAttributes:attributes];
    
    // Hide invisible cards to speed up performance
    attributes.hidden = attributes.indexPath.item >= self.index + kNumberOfDrawedCards;
  } else {
    attributes = [self layoutAttributesForOffScreenStackItemAttributes:attributes andIndexPath:indexPath];
    attributes.hidden = YES;
  }
  
  // Workaround for zIndex
  if (indexPath.item == self.draggedIndexPath.item) {
    attributes.zIndex = 10000;
  } else {
    attributes.zIndex = (indexPath.item >= self.index) ? (1000 - indexPath.item) : (1000 + indexPath.item);
  }
  
  return attributes;
}

// Return attributes for top stack cards
- (UICollectionViewLayoutAttributes *)layoutAttributesForTopStackItemAttributes:(UICollectionViewLayoutAttributes *)attributes {
  CGRect topStackItemFrame = CGRectMake(kCardSidePadding, kCardSidePadding, self.itemSize.width, self.itemSize.height);
  attributes.frame = topStackItemFrame;
  return attributes;
}

// Return attributes for off-screen stacks
- (UICollectionViewLayoutAttributes *)layoutAttributesForOffScreenStackItemAttributes:(UICollectionViewLayoutAttributes *)attributes andIndexPath:(NSIndexPath *)indexPath {
  
  // Add magick number 30 to coordinates to move cell far enough for shadow to disappear
  PositionType position = [self.delegate positionForCardWithIndex:indexPath.item];
  CGRect frame = [StackedLayout frameForPosition:position withStartingFrame:self.collectionView.frame];
  attributes.frame = frame;
  return attributes;
}

+ (CGRect)frameForPosition:(PositionType)position withStartingFrame:(CGRect)startingFrame {
  CGRect frame;
  
  switch (position) {
    case PositionTypeNo:
      frame = CGRectMake(-startingFrame.size.width - kOffscreenDistance, 0, startingFrame.size.width, startingFrame.size.height);
      break;
    case PositionTypeYes:
      frame = CGRectMake(startingFrame.size.width + kOffscreenDistance, 0, startingFrame.size.width, startingFrame.size.height);
      break;
    case PositionTypeSkip | PositionTypeNothing:
      frame = CGRectMake(0, startingFrame.size.height + kOffscreenDistance, startingFrame.size.width, startingFrame.size.height);
      break;
    case PositionTypeNeutral:
      frame = CGRectMake(0, -startingFrame.size.height - kOffscreenDistance, startingFrame.size.width, startingFrame.size.height);
      break;
    default:
      break;
  }
  return frame;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
  return YES;
}

@end
