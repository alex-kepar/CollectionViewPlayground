//
//  QVCUniSliderFlowLayout.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 9/10/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "QVCUniSliderFlowLayout.h"

@interface QVCUniSliderFlowLayout ()
@property (readonly)  CGFloat pageWidth;
@property (readonly)  CGFloat contentInsetLeft;
@property (readonly)  CGFloat contentInsetRight;
@property NSInteger currentPage;

@end

@implementation QVCUniSliderFlowLayout
{
    CGRect lastBounds;
}
@synthesize pagingStyle = _pagingStyle;
@synthesize centeringEnabled = _centeringEnabled;
@synthesize fastSlippingEnabled = _fastSlippingEnabled;
@synthesize infiniteScrollingEnabled = _infiniteScrollingEnabled;
@synthesize centerPoint = _centerPoint;

#pragma mark - property handling
- (NSInteger)currentItemIndex
{
    if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleOff)
    {
        return (NSInteger)round(self.collectionView.contentOffset.x / self.pageWidth) % [self.collectionView numberOfItemsInSection:0];
    }
    else
    {
        return self.currentPage % [self.collectionView numberOfItemsInSection:0];
    }
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    return [self setCurrentItemIndex:currentItemIndex animated:NO];
}

- (QVCUniSliderFlowLayoutPagingStyle)pagingStyle
{
    return _pagingStyle;
}

- (void)setPagingStyle:(QVCUniSliderFlowLayoutPagingStyle)pagingStyle
{
    if (_pagingStyle != pagingStyle) {
        _pagingStyle = pagingStyle;
        [self invalidateLayout];
    }
}

- (BOOL)centeringEnabled
{
    return _centeringEnabled;
}

- (void)setCenteringEnabled:(BOOL)centeringEnabled
{
    if (_centeringEnabled != centeringEnabled) {
        _centeringEnabled = centeringEnabled;
        [self invalidateLayout];
    }
}

- (BOOL)fastSlippingEnabled
{
    return _fastSlippingEnabled;
}

- (void)setFastSlippingEnabled:(BOOL)fastSlippingEnabled
{
    if (_fastSlippingEnabled != fastSlippingEnabled) {
        _fastSlippingEnabled = fastSlippingEnabled;
        [self invalidateLayout];
    }
}

- (BOOL)infiniteScrollingEnabled
{
    return _infiniteScrollingEnabled;
}

- (void)setInfiniteScrollingEnabled:(BOOL)infiniteScrollingEnabled
{
    if (_infiniteScrollingEnabled != infiniteScrollingEnabled) {
        _infiniteScrollingEnabled = infiniteScrollingEnabled;
        [self invalidateLayout];
    }
}

- (CGPoint)centerPoint
{
    return _centerPoint;
}

- (void)setCenterPoint:(CGPoint)centerPoint
{
    if (!CGPointEqualToPoint(_centerPoint, centerPoint)) {
        _centerPoint = centerPoint;
        [self invalidateLayout];
    }
}

#pragma mark internal calculeted properties
- (CGFloat)pageWidth
{
    return self.itemSize.width + self.minimumLineSpacing;
}

- (CGFloat)contentInsetLeft
{
    if (self.centeringEnabled)
    {
        if (CGPointEqualToPoint(self.centerPoint, CGPointZero))
        {
            return (self.collectionView.bounds.size.width - self.itemSize.width) / 2.0f;
        }
        else
        {
            return self.centerPoint.x - self.itemSize.width / 2.0f;
        }
    }
    return 0;
}

- (CGFloat)contentInsetRight
{
    if (self.centeringEnabled)
    {
        if (CGPointEqualToPoint(self.centerPoint, CGPointZero))
        {
            return (self.collectionView.bounds.size.width - self.itemSize.width) / 2.0f;
        }
        else
        {
            return self.collectionView.bounds.size.width - self.centerPoint.x - self.itemSize.width / 2.0f;
        }
    }
    return 0;
}

//- (CGFloat)contentInsetLeftRight
//{
//    if (self.centeringEnabled) {
//        return  (self.collectionView.bounds.size.width - self.itemSize.width) * 0.5f;
//    }
//    return 0;
//}

#pragma mark navigation
- (void)setCurrentItemIndex:(NSInteger)newCurrentItemIndex animated:(BOOL)animated
{
    NSLog(@"currentItemIndex = %li; newCurrentItemIndex = %li", (long)self.currentItemIndex, (long)newCurrentItemIndex);
    if (newCurrentItemIndex < 0 ||
        newCurrentItemIndex >= [self.collectionView numberOfItemsInSection:0] ||
        newCurrentItemIndex == _currentPage)
    {
        return;
    }
    self.currentPage = newCurrentItemIndex;
    NSLog(@"set offset = %0.0f", self.currentPage * self.pageWidth);
    [self.collectionView setContentOffset:CGPointMake(self.currentPage * self.pageWidth, self.collectionView.contentOffset.y) animated:animated];
}

#pragma mark layout behavior
- (void)prepareLayout
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
            if (self.collectionView.contentOffset.x <= minXContentRange + self.contentInsetLeft)
            {
                if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleOff)
                {
                    [self.collectionView setContentOffset:CGPointMake(maxXContentRange, self.collectionView.contentOffset.y)];
                }
                else
                {
                    //NSLog(@"(prepareLayout x<=0) old currentPage: %li", self.currentPage);
                    self.currentPage += [self.collectionView numberOfItemsInSection:0];
                    //NSLog(@"(prepareLayout x<=0) new currentPage: %li", self.currentPage);
                    CGPoint newContentOffset = CGPointMake(self.currentPage * self.pageWidth, self.collectionView.contentOffset.y);
                    [self.collectionView setContentOffset:newContentOffset animated:NO];
                }
            }
            else if (self.collectionView.contentOffset.x >= maxXContentRange + self.contentInsetLeft)
            {
                if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleOff)
                {
                    [self.collectionView setContentOffset:CGPointMake(minXContentRange, self.collectionView.contentOffset.y)];
                }
                else
                {
                    //NSLog(@"(prepareLayout x>=width) old currentPage: %li", self.currentPage);
                    self.currentPage = self.currentPage % [self.collectionView numberOfItemsInSection:0];
                    //NSLog(@"(prepareLayout x>=width) new currentPage: %li", self.currentPage);
                    CGPoint newContentOffset = CGPointMake(self.currentPage * self.pageWidth, self.collectionView.contentOffset.y);
                    [self.collectionView setContentOffset:newContentOffset animated:NO];
                }
            }
        }
        else
        {
            CGPoint newContentOffset = CGPointMake(self.currentPage * self.pageWidth, self.collectionView.contentOffset.y);
            [self.collectionView setContentOffset:newContentOffset animated:NO];
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
    contentSize.width += self.contentInsetLeft + self.contentInsetRight;
    return contentSize;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    BOOL isBoundsSizeCanged = !CGSizeEqualToSize(lastBounds.size, newBounds.size);
    lastBounds = newBounds;
    if (self.fastSlippingEnabled)
    {
        return YES;
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
    if (isBoundsSizeCanged) {
        return YES;
    }
    return [super shouldInvalidateLayoutForBoundsChange:newBounds];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    rect = CGRectMake(rect.origin.x - self.contentInsetLeft, rect.origin.y, rect.size.width, rect.size.height);
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

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
{
    if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleOff)
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset];
    }
    else
    {
        proposedContentOffset.x = self.currentPage * self.pageWidth;
    }
    return proposedContentOffset;
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal
        && self.pagingStyle != QVCUniSliderFlowLayoutPagingStyleOff)
    {
        NSInteger propousedPage = round(proposedContentOffset.x / self.pageWidth);
        if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleStepping)
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
        //NSLog(@"okd currentPage: %li; proposedPage: %li", self.currentPage, propousedPage);
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
        //NSLog(@"new currentPage: %li", self.currentPage);
    }
    else
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    return proposedContentOffset;
}

#pragma mark support methods
-(void)correctFrameForItemAttributes:(UICollectionViewLayoutAttributes*)itemAttributes
{
    CGRect newFrame = itemAttributes.frame;
    if (self.centeringEnabled)
    {
        newFrame.origin.x += self.contentInsetLeft;
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

@end
