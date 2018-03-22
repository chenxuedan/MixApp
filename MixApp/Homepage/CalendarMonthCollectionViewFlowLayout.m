//
//  CalendarMonthCollectionViewFlowLayout.m
//  MixApp
//
//  Created by 陈雪丹 on 2017/2/22.
//  Copyright © 2017年 cxd. All rights reserved.
//

#import "CalendarMonthCollectionViewFlowLayout.h"

@interface CalendarMonthCollectionViewFlowLayout ()

@end

@implementation CalendarMonthCollectionViewFlowLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

//返回rect中的所有的元素的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    UICollectionView *const customCV = self.collectionView;
    CGPoint const contentOffset = customCV.contentOffset;
    
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if (layoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {
            [missingSections addIndex:layoutAttributes.indexPath.section];
        }
    }
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            [missingSections removeIndex:layoutAttributes.indexPath.section];
        }
    }
    
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [answer addObject:layoutAttributes];
    }];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in answer) {
        if ([layoutAttributes.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            NSInteger section = layoutAttributes.indexPath.section;
            NSInteger numberOfItemsInSection = [customCV numberOfItemsInSection:section];
            
            NSIndexPath *firstObjectIndexPath = [NSIndexPath indexPathForItem:0 inSection:section];
            NSIndexPath *lastObjectIndexPath = [NSIndexPath indexPathForItem:MAX(0, (numberOfItemsInSection - 1)) inSection:section];
            
            UICollectionViewLayoutAttributes *firstObjectAttrs;
            UICollectionViewLayoutAttributes *lastObjectAttrs;
            
            if (numberOfItemsInSection > 0) {
                firstObjectAttrs = [self layoutAttributesForItemAtIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForItemAtIndexPath:lastObjectIndexPath];
            }else {
                firstObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:firstObjectIndexPath];
                lastObjectAttrs = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionFooter atIndexPath:lastObjectIndexPath];
            }
            
            CGFloat headerHeight = CGRectGetHeight(layoutAttributes.frame);
            CGPoint origin = layoutAttributes.frame.origin;
            origin.y = MIN(MAX(contentOffset.y + customCV.contentInset.top, (CGRectGetMinY(firstObjectAttrs.frame) - headerHeight)), (CGRectGetMaxY(lastObjectAttrs.frame) - headerHeight));
            
            layoutAttributes.zIndex = 1024;
            layoutAttributes.frame = (CGRect) {
                .origin = origin,
                .size = layoutAttributes.frame.size
            };
        }
    }
    return answer;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

@end
