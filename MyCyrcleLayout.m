//
//  MyCyrcleLayout.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/27/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyCyrcleLayout.h"

@interface MyCyrcleLayout()
//@property (nonatomic) CGRect prevBounds;
@property (nonatomic)  CGFloat pageWidth;
@property NSInteger currentPage;
@property (nonatomic)  CGFloat contentInsetLeftRight;
@end

@implementation MyCyrcleLayout

- (CGFloat)pageWidth
{
    return self.itemSize.width + self.minimumLineSpacing;
}

-(void)prepareLayout
{
    // Handle wrapping the collection view at the boundaries
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        if (self.infiniteScrollingEnabled)
        {
            if (self.collectionView.contentOffset.y <= 0.0f)
            {
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, [super collectionViewContentSize].height + self.minimumLineSpacing)];
            }
            else if (self.collectionView.contentOffset.y >= [super collectionViewContentSize].height + self.minimumLineSpacing)
            {
                [self.collectionView setContentOffset:CGPointMake(self.collectionView.contentOffset.x, 0.0f)];
            }
        }
    }
    else
    {
        self.minimumInteritemSpacing = self.collectionView.bounds.size.height;
        if (self.infiniteScrollingEnabled)
        {
            if (self.collectionView.contentOffset.x <= 0.0f)
            {
                CGPoint newContentOffset = CGPointMake([super collectionViewContentSize].width + self.minimumLineSpacing, self.collectionView.contentOffset.y);
                if (self.pagingEnabled)
                {
                    self.currentPage = [self.collectionView numberOfItemsInSection:0];
                    [self.collectionView setContentOffset:newContentOffset animated:NO];
                }
                else
                {
                    [self.collectionView setContentOffset:newContentOffset];
                }
            }
            else if (self.collectionView.contentOffset.x >= [super collectionViewContentSize].width + self.minimumLineSpacing)
            {
                CGPoint newContentOffset = CGPointMake(0.0f, self.collectionView.contentOffset.y);
                if (self.pagingEnabled)
                {
                    self.currentPage = 0;
                    [self.collectionView setContentOffset:newContentOffset animated:NO];
                }
                else
                {
                    [self.collectionView setContentOffset:newContentOffset];
                }
            }
        }
    }
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize
{
    CGSize contentSize = [super collectionViewContentSize];
    
    if (self.infiniteScrollingEnabled)
    {
        // We add the height (or width) of the collection view to the content size to allow us to seemlessly wrap without any screen artifacts
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            contentSize = CGSizeMake(contentSize.width, contentSize.height + self.collectionView.bounds.size.height + self.minimumLineSpacing);
        }
        else
        {
            contentSize = CGSizeMake(contentSize.width + self.collectionView.bounds.size.width + self.minimumLineSpacing, contentSize.height);
        }
    }
    else if (self.centeringEnabled)
    {
        contentSize.width += self.contentInsetLeftRight * 2;
    }
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    
    if (self.fastSlippingEnabled)
    {
        return true;
    }
    else if (self.infiniteScrollingEnabled)
    {
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
        {
            if (newBounds.origin.y <= self.collectionView.bounds.size.height)
            {
                return YES;
            }
            
            if (newBounds.origin.y >= [super collectionViewContentSize].height - self.collectionView.bounds.size.height)
            {
                return YES;
            }
        }
        else
        {
            if (newBounds.origin.x <= self.collectionView.bounds.size.width)
            {
                return YES;
            }
            if (newBounds.origin.x >= [super collectionViewContentSize].width - self.collectionView.bounds.size.width)
            {
                return YES;
            }
        }
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* layoutAttributes = [super layoutAttributesForElementsInRect:rect];
    
    if (self.scrollDirection == UICollectionViewScrollDirectionVertical)
    {
        if (self.infiniteScrollingEnabled)
        {
            NSArray* wrappingAttributes = [super layoutAttributesForElementsInRect:CGRectMake(rect.origin.x,
                                                                                              rect.origin.y - [super collectionViewContentSize].height,
                                                                                              rect.size.width,
                                                                                              rect.size.height)];
            
            for (UICollectionViewLayoutAttributes* attributes in wrappingAttributes)
            {
                attributes.center = CGPointMake(attributes.center.x, attributes.center.y + [super collectionViewContentSize].height + self.minimumLineSpacing);
            }
            
            layoutAttributes = [layoutAttributes arrayByAddingObjectsFromArray:wrappingAttributes];
        }
    }
    else
    {
        if (self.infiniteScrollingEnabled)
        {
            NSArray* wrappingAttributes = [super layoutAttributesForElementsInRect:CGRectMake(rect.origin.x - [super collectionViewContentSize].width,
                                                                                              rect.origin.y,
                                                                                              rect.size.width,
                                                                                              rect.size.height)];
            
            for (UICollectionViewLayoutAttributes* attributes in wrappingAttributes)
            {
                attributes.center = CGPointMake(attributes.center.x + [super collectionViewContentSize].width + self.minimumLineSpacing, attributes.center.y);
            }
            
            layoutAttributes = [layoutAttributes arrayByAddingObjectsFromArray:wrappingAttributes];
        }
        for (UICollectionViewLayoutAttributes* attributes in layoutAttributes)
        {
            [self correctFrameForItemAttributes:attributes];
        }
    }
    return layoutAttributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionViewLayoutAttributes* layoutAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    if (self.infiniteScrollingEnabled)
    {
        layoutAttributes.center = CGPointMake(layoutAttributes.center.x + self.collectionView.bounds.size.width, layoutAttributes.center.y);
    }
    [self correctFrameForItemAttributes:layoutAttributes];
    return layoutAttributes;
}

-(void)correctFrameForItemAttributes:(UICollectionViewLayoutAttributes*)itemAttributes
{
    CGRect newFrame = itemAttributes.frame;
    if (self.centeringEnabled)
    {
        newFrame.origin.x += self.contentInsetLeftRight;
    }
    if (self.fastSlippingEnabled)
    {
        CGFloat contentOffsetX = self.collectionView.contentOffset.x;
        CGFloat distance = newFrame.origin.x - contentOffsetX;
        if (distance < 0 && fabs(distance)<=self.itemSize.width)
        {
            distance = fabs(distance);
            CGFloat coef = 1.0f;
            if (fabs(distance) < self.itemSize.width)
            {
                coef *= distance / self.itemSize.width;
            }
            itemAttributes.alpha = 1 - coef;
            newFrame.origin.x -= self.itemSize.width * coef;
        }
    }
    //    NSLog(@"attribute (%ld - %ld)\torigin: %@\tnew origin: %@",
    //          (long)itemAttributes.indexPath.section,
    //          (long)itemAttributes.indexPath.row,
    //          NSStringFromCGPoint(itemAttributes.frame.origin),
    //          NSStringFromCGPoint(newFrame.origin));
    itemAttributes.frame = newFrame;
}

- (CGFloat)contentInsetLeftRight
{
    return  (self.collectionView.bounds.size.width  - self.itemSize.width) * 0.5f;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    if (self.pagingEnabled)
    {
        proposedContentOffset.x = self.currentPage * self.pageWidth;
    }
    else
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
    }
    return proposedContentOffset;
}

#pragma mark paging handling
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal && self.pagingEnabled)
    {
        NSInteger propousedPage = round(proposedContentOffset.x / self.pageWidth);
        if (propousedPage < self.currentPage)
        {
            propousedPage = self.currentPage - 1;
        }
        else if (propousedPage > self.currentPage)
        {
            propousedPage = self.currentPage + 1;
        }
        proposedContentOffset.x = propousedPage * self.pageWidth;//candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f;
        
        self.currentPage = propousedPage;
        //NSLog(@"proposedContentOffset: %@ proposedPage: %d velocity: %@", NSStringFromCGPoint(proposedContentOffset), propousedPage, NSStringFromCGPoint(velocity));
    }
    else
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    return proposedContentOffset;
}


@end
