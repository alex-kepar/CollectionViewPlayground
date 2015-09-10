//
//  QVCUniSliderFlowLayout.h
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 9/10/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QVCUniSliderConstants.h"

@interface QVCUniSliderFlowLayout : UICollectionViewFlowLayout

@property(nonatomic) NSInteger currentItemIndex;
@property(nonatomic) QVCUniSliderFlowLayoutPagingStyle pagingStyle;
@property(nonatomic) BOOL centeringEnabled;
@property(nonatomic) BOOL fastSlippingEnabled;
@property(nonatomic) BOOL infiniteScrollingEnabled;
@property(nonatomic) CGPoint centerPoint;

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex animated:(BOOL)animated;

@end
