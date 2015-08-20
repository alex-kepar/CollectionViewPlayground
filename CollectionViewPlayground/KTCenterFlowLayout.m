//
//  KTCenterFlowLayout.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/19/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "KTCenterFlowLayout.h"

@interface KTCenterFlowLayout ()
@end

@implementation KTCenterFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *superAttributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    
    NSMutableDictionary *rowCollections = [NSMutableDictionary new];
    
    // Collect attributes by their midY coordinate.. i.e. rows!
    
    for (UICollectionViewLayoutAttributes *itemAttributes in superAttributes)
    {
        // Normalize the midY to others in the row
        // with variable cell heights the midYs can be ever so slightly
        // different.
        CGFloat midYRound = roundf(CGRectGetMidY(itemAttributes.frame));
        CGFloat midYPlus = midYRound + 1;
        CGFloat midYMinus = midYRound - 1;
        NSNumber *key;
        
        if (rowCollections[@(midYPlus)])
            key = @(midYPlus);
        
        if (rowCollections[@(midYMinus)])
            key = @(midYMinus);
        
        if (!key)
            key = @(midYRound);
        
        if (!rowCollections[key])
            rowCollections[key] = [NSMutableArray new];
        
        [(NSMutableArray *) rowCollections[key] addObject:itemAttributes];
    }
    
    CGFloat collectionViewWidth = CGRectGetWidth(self.collectionView.bounds) - self.collectionView.contentInset.left - self.collectionView.contentInset.right;
    
    // Adjust the items in each row
    [rowCollections enumerateKeysAndObjectsUsingBlock:^(id key, NSArray *itemAttributesCollection, BOOL *stop) {
        
        NSInteger itemsInRow = [itemAttributesCollection count];
        
        // x-x-x-x ... sum up the interim space
        CGFloat aggregateInteritemSpacing = self.minimumInteritemSpacing * (itemsInRow -1);
        
        // Sum the width of all elements in the row
        CGFloat aggregateItemWidths = 0.f;
        for (UICollectionViewLayoutAttributes *itemAttributes in itemAttributesCollection)
            aggregateItemWidths += CGRectGetWidth(itemAttributes.frame);
        
        // Build an alignment rect
        // |==|--------|==|
        CGFloat alignmentWidth = aggregateItemWidths + aggregateInteritemSpacing;
        CGFloat alignmentXOffset = (collectionViewWidth - alignmentWidth) / 2.f;
        
        // Adjust each item's position to be centered
        CGRect previousFrame = CGRectZero;
        for (UICollectionViewLayoutAttributes *itemAttributes in itemAttributesCollection)
        {
            CGRect itemFrame = itemAttributes.frame;
            
            if (CGRectEqualToRect(previousFrame, CGRectZero))
                itemFrame.origin.x = alignmentXOffset;
            else
                itemFrame.origin.x = CGRectGetMaxX(previousFrame) + self.minimumInteritemSpacing;
            
            itemAttributes.frame = itemFrame;
            previousFrame = itemFrame;
        }
    }];
    
    return superAttributes;
}

@end
