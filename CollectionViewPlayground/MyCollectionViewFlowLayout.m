//
//  MyCollectionViewFlowLayout.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/17/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyCollectionViewFlowLayout.h"

@interface MyCollectionViewFlowLayout ()
@property NSInteger currentPage;
@end

@implementation MyCollectionViewFlowLayout

CGFloat contentInsetLeftRight;
CGFloat pageSize;

//CGFloat contentInsetTopBottom;
//CGFloat statusBarHeight;

//-(instancetype)init
//{
//    if (self = [super init])
//    {
//        //self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//        self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    }
//    return self;
//}
//
//-(void)awakeFromNib
//{
//    //self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//}

-(void)scrollToPage:(NSInteger)page
{
    [self scrollToPage:page animated:NO];
}

-(void)scrollToPage:(NSInteger)page animated:(BOOL)animated
{
    if (page < [self.collectionView numberOfItemsInSection:0]) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:page inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:animated];
    }
}

-(void)prepareLayout
{
    NSLog(@"********* prepareLayout LeftRight = %0.0f TopBottom = %0.0f", self.collectionView.contentInset.left, self.collectionView.contentInset.top);
    NSLog(@"collectionViewContentSize: %@", NSStringFromCGSize(self.collectionViewContentSize));
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        pageSize = self.itemSize.width + self.minimumLineSpacing;
        contentInsetLeftRight = (self.collectionView.bounds.size.width  - self.itemSize.width) * 0.5f;
        self.minimumInteritemSpacing = self.collectionView.bounds.size.height;
        NSLog(@"contentOffset: %@", NSStringFromCGPoint(self.collectionView.contentOffset));
        self.currentPage = round(self.collectionView.contentOffset.x / pageSize);
        self.collectionView.contentOffset = CGPointMake(self.currentPage * pageSize, self.collectionView.contentOffset.y);
        NSLog(@"new contentOffset: %@ for page: %ld and contentInsetLeftRight: %0.0f",
              NSStringFromCGPoint(self.collectionView.contentOffset),
              (long)self.currentPage, contentInsetLeftRight);
        if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait ||
            [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown ) {
            NSLog(@"Portant orientation");
        }
        else
        {
            NSLog(@"Landscape orientation");
        }
        NSLog(@"frame: %@", NSStringFromCGRect(self.collectionView.frame));
    }
}

-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    if (self.scrollDirection == UICollectionViewScrollDirectionHorizontal)
    {
        NSInteger propousedPage = round(proposedContentOffset.x / pageSize);
        if (propousedPage < self.currentPage)
        {
            propousedPage = self.currentPage > 0 ? self.currentPage - 1 : self.currentPage;
        }
        else if (propousedPage > self.currentPage)
        {
            propousedPage = self.currentPage + 1;
        }
        NSInteger numberOfItems = [self.collectionView numberOfItemsInSection:0];
        
        if (propousedPage > numberOfItems) {
            propousedPage = numberOfItems;
        }
        UICollectionViewLayoutAttributes* candidateAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:propousedPage inSection:0]];
        proposedContentOffset.x = candidateAttributes.center.x - self.collectionView.bounds.size.width * 0.5f;

//        CGRect cvBounds = self.collectionView.bounds;
//        CGFloat halfWidth = cvBounds.size.width * 0.5f;
//        CGFloat halfItemWidth = self.itemSize.width * 0.5f;
//        cvBounds.origin.x = propousedPage * pageSize;
//        //cvBounds.origin.y = 0;
//        //cvBounds.size.width = pageSize;
//        CGFloat proposedContentOffsetCenterX = cvBounds.origin.x + halfWidth - halfItemWidth;
//        
//        NSArray* attributesArray = [self layoutAttributesForElementsInRect:cvBounds];
//        
//        UICollectionViewLayoutAttributes* candidateAttributes;
//        for (UICollectionViewLayoutAttributes* attributes in attributesArray) {
//            
//            // == Skip comparison with non-cell items (headers and footers) == //
//            if (attributes.representedElementCategory !=
//                UICollectionElementCategoryCell) {
//                continue;
//            }
//            
//            // == First time in the loop == //
//            if(!candidateAttributes) {
//                candidateAttributes = attributes;
//                continue;
//            }
//            
//            if (fabs(attributes.center.x - proposedContentOffsetCenterX) <
//                fabs(candidateAttributes.center.x - proposedContentOffsetCenterX)) {
//                candidateAttributes = attributes;
//            }
//        }
//        proposedContentOffset.x = candidateAttributes.center.x - halfWidth;

        self.currentPage = round(proposedContentOffset.x / pageSize);
        NSLog(@"===============================================");
        NSLog(@"proposedContentOffset: %@", NSStringFromCGPoint(proposedContentOffset));
    }
    else
    {
        proposedContentOffset = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    }
    return proposedContentOffset;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *itemAttributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self correctFrameForItemAttributes:itemAttributes];
    return itemAttributes;
}

- (CGSize)collectionViewContentSize
{
    CGSize superSize = [super collectionViewContentSize];
    superSize.width += contentInsetLeftRight * 2;
    return superSize;
}

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSLog(@"===============================================");
    NSLog(@"layoutAttributesForElementsInRect: %@", NSStringFromCGRect(rect));
    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
    for (UICollectionViewLayoutAttributes *itemAttributes in layoutAttributesArray) {
        [self correctFrameForItemAttributes:itemAttributes];
    }
    return layoutAttributesArray;
}

-(void)correctFrameForItemAttributes:(UICollectionViewLayoutAttributes*)itemAttributes
{
    CGRect newFrame = itemAttributes.frame;
    newFrame.origin.x += contentInsetLeftRight;
    NSLog(@"attribute (%ld - %ld)\torigin: %@\tnew origin: %@",
          (long)itemAttributes.indexPath.section,
          (long)itemAttributes.indexPath.row,
          NSStringFromCGPoint(itemAttributes.frame.origin),
          NSStringFromCGPoint(newFrame.origin));
    itemAttributes.frame = newFrame;
}

@end
