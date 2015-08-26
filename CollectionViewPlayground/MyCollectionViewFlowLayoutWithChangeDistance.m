//
//  MyCollectionViewFlowLayoutWithChangeDistance.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/26/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyCollectionViewFlowLayoutWithChangeDistance.h"

@interface MyCollectionViewFlowLayoutWithChangeDistance ()
@property (readonly) CGFloat contentInsetLeftRight;
@end

@implementation MyCollectionViewFlowLayoutWithChangeDistance

-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    NSLog(@"****** newBounds: %@", NSStringFromCGRect(newBounds) );
    return YES;
}

- (CGFloat)contentInsetLeftRight
{
    return  (self.collectionView.bounds.size.width  - self.itemSize.width) * 0.5f;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self correctFrameForItemAttributes:attributes];
    return attributes;
}


-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes* attributes in layoutAttributesArray)
    {
        // We're going to calculate the rect of the collection view visible to the user.
        // That way, we can avoid laying out cells that are not visible.
        //if (CGRectIntersectsRect(attributes.frame, rect))
        {
            [self correctFrameForItemAttributes:attributes];
        }
    }
    return layoutAttributesArray;
}


-(void)correctFrameForItemAttributes:(UICollectionViewLayoutAttributes*)itemAttributes
{
    CGRect newFrame = itemAttributes.frame;
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    newFrame.origin.x += self.contentInsetLeftRight;
    CGFloat distance = newFrame.origin.x - contentOffsetX;
    if (distance < 0 && fabs(distance)<=self.itemSize.width) {
        distance = fabs(distance);
        CGFloat coef = 1.0f;
        if (fabs(distance) < self.itemSize.width) {
            coef *= distance / self.itemSize.width;
        }
        itemAttributes.alpha = 1 - coef;
        newFrame.origin.x -= self.itemSize.width * coef;
    }
//    NSLog(@"attribute (%ld - %ld)\torigin: %@\tnew origin: %@",
//          (long)itemAttributes.indexPath.section,
//          (long)itemAttributes.indexPath.row,
//          NSStringFromCGPoint(itemAttributes.frame.origin),
//          NSStringFromCGPoint(newFrame.origin));
    itemAttributes.frame = newFrame;
}


@end
