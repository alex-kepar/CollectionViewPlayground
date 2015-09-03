//
//  MyCyrcleLayout.h
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/27/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MyCyrcleLayoutPagingStyle) {
    MyCyrcleLayoutPagingStyleOff,
    MyCyrcleLayoutPagingStyleStepping,
    MyCyrcleLayoutPagingStyleRunning
};

@interface MyCyrcleLayout : UICollectionViewFlowLayout

@property MyCyrcleLayoutPagingStyle pagingStyle;
@property BOOL centeringEnabled;
@property BOOL fastSlippingEnabled;
@property BOOL infiniteScrollingEnabled;
@end
