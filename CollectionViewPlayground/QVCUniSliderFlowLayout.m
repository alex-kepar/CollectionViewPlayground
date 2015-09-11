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
//@property NSInteger infiniteCurrentPage;
//@property BOOL shiftToCurrentPage;
//@property CGFloat overload;

@property (readonly) NSInteger numberPages;
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
@synthesize currentPage = _currentPage;

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

//-(void)setCurrentPage:(NSInteger)currentPage
//{
//    _currentPage = currentPage;
//    self.infiniteCurrentPage = 0;
//}

//-(NSInteger)currentPage
//{
//    return _currentPage;
//}

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
            NSInteger shiftPage = ceil(self.contentInsetLeft/self.pageWidth);
            CGFloat offset = shiftPage * self.pageWidth;
            CGFloat minXContentRange = offset;//self.contentInsetLeft;
            CGFloat maxXContentRange = [super collectionViewContentSize].width + self.minimumLineSpacing + offset;//;self.contentInsetLeft;
            if (self.collectionView.contentOffset.x <= minXContentRange)
            {
                //self.overload = maxXContentRange;
                NSLog(@"*");
                //NSLog(@"(prepareLayout x<=0) overload: %0.0f", self.overload);
                if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleOff)
                {
                    [self.collectionView setContentOffset:CGPointMake(maxXContentRange, self.collectionView.contentOffset.y)];
                }
                else
                {
                    NSInteger range = shiftPage - self.currentPage;
                    if (range>=0) {
                        NSLog(@"(prepareLayout x<=0) old currentPage: %i", self.currentPage);
                        self.currentPage += self.numberPages;
                        [self.collectionView setContentOffset:CGPointMake(maxXContentRange - range*self.pageWidth, self.collectionView.contentOffset.y) animated:NO];
                        NSLog(@"(prepareLayout x<=0) new currentPage: %i", self.currentPage);
                    }
                }
            }
            else if
            (self.collectionView.contentOffset.x >= maxXContentRange)
            {
                //self.overload = maxXContentRange;
                NSLog(@"*");
                //NSLog(@"(prepareLayout x>=width) overload: %0.0f", self.overload);
                if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleOff)
                {
                    [self.collectionView setContentOffset:CGPointMake(minXContentRange, self.collectionView.contentOffset.y)];
                }
                else
                {
                    NSInteger range = self.numberPages + shiftPage - self.currentPage;
                    if (range >= 0) {
                        NSLog(@"(prepareLayout x>=width) old currentPage: %i", self.currentPage);
                        self.currentPage -= self.numberPages;
                        [self.collectionView setContentOffset:CGPointMake(minXContentRange + range*self.pageWidth, self.collectionView.contentOffset.y) animated:NO];
                        NSLog(@"(prepareLayout x>=width) new currentPage: %i", self.currentPage);
                    }
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

- (NSInteger)numberPages
{
    return [self.collectionView numberOfItemsInSection:0];
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
    //self.shiftToCurrentPage=NO;
    NSLog(@"*");
    NSLog(@"proposedContentOffset: %@", NSStringFromCGPoint(proposedContentOffset));
    //NSLog(@"proposedContentOffset: overload %0.0f", self.overload);
    //self.overload = 0;
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal
        && self.pagingStyle != QVCUniSliderFlowLayoutPagingStyleOff)
    {
        NSLog(@"proposedContentOffset: pageWidth %0.0f", self.pageWidth);
        NSLog(@"proposedContentOffset: currentPage %i", self.currentPage);
        //NSLog(@"proposedContentOffset: infiniteCurrentPage %i", self.infiniteCurrentPage);
        NSInteger propousedPage = round(proposedContentOffset.x / self.pageWidth);
        NSLog(@"proposedContentOffset: propousedPage %i", propousedPage);
        if (self.pagingStyle == QVCUniSliderFlowLayoutPagingStyleStepping)
        {
//            NSInteger pageShifting = propousedPage % self.numberPages - self.currentPage % self.numberPages;
//            if (pageShifting < 0)
//            {
//                propousedPage = self.currentPage - 1;
//            }
//            else if (pageShifting > 0)
//            {
//                propousedPage = self.currentPage + 1;
//            }
            //NSInteger currentPage = self.currentPage + self.infiniteCurrentPage;
            if (propousedPage < self.currentPage)
            {
                propousedPage = self.currentPage - 1;
            }
            else if (propousedPage > self.currentPage)
            {
                propousedPage = self.currentPage + 1;
            }
        }
        //NSLog(@"okd currentPage: %li; proposedPage: %li", self.currentPage, propousedPage);
//        if (self.infiniteScrollingEnabled)
//        {
//            //proposedContentOffset.x = propousedPage * self.pageWidth;//candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f;
//            if (propousedPage < 0)
//            {
//                propousedPage += self.numberPages;
//                NSLog(@"proposedContentOffset: correction propousedPage %i", propousedPage);
//                //[self.collectionView setContentOffset:CGPointMake(self.overload-1, self.collectionView.contentOffset.y)];
//                self.shiftToCurrentPage=YES;
//                [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentOffset.y) animated:NO];
//                //[self.collectionView setContentOffset:CGPointMake(propousedPage * self.pageWidth, self.collectionView.contentOffset.y) animated:YES];
//            }
//            proposedContentOffset.x = propousedPage * self.pageWidth;
//        }
//        else
//        {
            if (propousedPage < 0)
            {
                propousedPage = 0;
            }
            else
            {
                NSInteger maxPageValue = self.numberPages;
                if (self.infiniteScrollingEnabled) {
                    maxPageValue ++;
                }
                if (propousedPage > maxPageValue)
                {
                    propousedPage = maxPageValue;
                }
            }
            proposedContentOffset.x = propousedPage * self.pageWidth;//candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f;
//        }
        self.currentPage = propousedPage;
        NSLog(@"proposedContentOffset: new currentPage: %li", (long)self.currentPage);
    }
    else
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    NSLog(@"proposedContentOffset: new offset %@", NSStringFromCGPoint(proposedContentOffset));
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
