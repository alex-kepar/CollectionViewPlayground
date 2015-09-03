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
        self.minimumInteritemSpacing = self.collectionView.bounds.size.height + self.itemSize.height;
        if (self.infiniteScrollingEnabled)
        {
            CGFloat minXContentRange = 0.0f;
            CGFloat maxXContentRange = [super collectionViewContentSize].width + self.minimumLineSpacing;
            if (self.collectionView.contentOffset.x <= minXContentRange + self.contentInsetLeftRight)
            {
                //                CGPoint newContentOffset = CGPointMake([super collectionViewContentSize].width + self.minimumLineSpacing + self.contentInsetLeftRight, self.collectionView.contentOffset.y);
                //CGPoint newContentOffset = CGPointMake([super collectionViewContentSize].width + self.minimumLineSpacing, self.collectionView.contentOffset.y);
                if (self.pagingStyle == MyCyrcleLayoutPagingStyleOff)
                {
                    [self.collectionView setContentOffset:CGPointMake(maxXContentRange, self.collectionView.contentOffset.y)];
                }
                else
                {
                    NSLog(@"(prepareLayout x<=0) old currentPage: %li", self.currentPage);
                    self.currentPage += [self.collectionView numberOfItemsInSection:0];
                    NSLog(@"(prepareLayout x<=0) new currentPage: %li", self.currentPage);
                    CGPoint newContentOffset = CGPointMake(self.currentPage * self.pageWidth, self.collectionView.contentOffset.y);
                    //self.currentPage = [self.collectionView numberOfItemsInSection:0] - self.currentPage;
                    [self.collectionView setContentOffset:newContentOffset animated:NO];
                }
            }
            else if (self.collectionView.contentOffset.x >= maxXContentRange + self.contentInsetLeftRight)
            {
                if (self.pagingStyle == MyCyrcleLayoutPagingStyleOff)
                {
                    [self.collectionView setContentOffset:CGPointMake(minXContentRange, self.collectionView.contentOffset.y)];
                }
                else
                {
                    NSLog(@"(prepareLayout x>=width) old currentPage: %li", self.currentPage);
                    self.currentPage = self.currentPage % [self.collectionView numberOfItemsInSection:0];
                    NSLog(@"(prepareLayout x>=width) new currentPage: %li", self.currentPage);
                    CGPoint newContentOffset = CGPointMake(self.currentPage * self.pageWidth, self.collectionView.contentOffset.y);
                    //self.currentPage = 0;
                    [self.collectionView setContentOffset:newContentOffset animated:NO];
                }

                /*
                 Original:
                if (self.collectionView.contentOffset.x <= 0.0f) {
                    [self.collectionView setContentOffset:CGPointMake([super collectionViewContentSize].width + self.minimumLineSpacing, self.collectionView.contentOffset.y)];
                }
                else if (self.collectionView.contentOffset.x >= [super collectionViewContentSize].width + self.minimumLineSpacing) {
                    [self.collectionView setContentOffset:CGPointMake(0.0f, self.collectionView.contentOffset.y)];
                }
                */
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
    //if (self.centeringEnabled)
    //{
        contentSize.width += self.contentInsetLeftRight * 2;
    //}
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
    rect = CGRectMake(rect.origin.x - self.contentInsetLeftRight, rect.origin.y, rect.size.width, rect.size.height);
    //NSLog(@"rect = %@", NSStringFromCGRect(rect));
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
            CGFloat superWidth = [super collectionViewContentSize].width;
            NSArray* wrappingAttributes = [super layoutAttributesForElementsInRect:CGRectMake(rect.origin.x - superWidth,
                                                                                              rect.origin.y,
                                                                                              rect.size.width,
                                                                                              rect.size.height)];
            
            for (UICollectionViewLayoutAttributes* attributes in wrappingAttributes)
            {
                attributes.center = CGPointMake(attributes.center.x + superWidth + self.minimumLineSpacing, attributes.center.y);
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
    if (self.centeringEnabled) {
        return  (self.collectionView.bounds.size.width - self.itemSize.width) * 0.5f;
    }
    return 0;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    if (self.pagingStyle == MyCyrcleLayoutPagingStyleOff)
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
    }
    else
    {
        proposedContentOffset.x = self.currentPage * self.pageWidth;
    }
    return proposedContentOffset;
}

#pragma mark paging handling
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal
        && self.pagingStyle != MyCyrcleLayoutPagingStyleOff)
    {
        NSInteger propousedPage = round(proposedContentOffset.x / self.pageWidth);
        if (self.pagingStyle == MyCyrcleLayoutPagingStyleStepping)
        {
            if (propousedPage < self.currentPage)
            {
                propousedPage = self.currentPage - 1;
            }
            else if (propousedPage > self.currentPage)
            {
                propousedPage = self.currentPage + 1;
            }
        }
        proposedContentOffset.x = propousedPage * self.pageWidth;//candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f;
//
//        if (propousedPage < 0)
//        {
//            self.currentPage = numberOfPages + propousedPage;
//        }
//        else if (propousedPage >= numberOfPages)
//        {
//            self.currentPage = propousedPage - numberOfPages;
//        }
        NSLog(@"okd currentPage: %li; proposedPage: %li", self.currentPage, propousedPage);
        if (!self.infiniteScrollingEnabled)
        {
            if (propousedPage < 0)
            {
                propousedPage = 0;
            }
            else
            {
                NSInteger maxPageValue = [self.collectionView numberOfItemsInSection:0] - 1;
                if (propousedPage > maxPageValue)
                {
                    propousedPage = maxPageValue;
                }
            }
        }
        self.currentPage = propousedPage;
        NSLog(@"new currentPage: %li", self.currentPage);
        //NSLog(@"proposedContentOffset: %@ proposedPage: %d velocity: %@", NSStringFromCGPoint(proposedContentOffset), propousedPage, NSStringFromCGPoint(velocity));
    }
    else
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    return proposedContentOffset;
}


@end
