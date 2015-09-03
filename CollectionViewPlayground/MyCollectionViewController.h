//
//  MyCollectionViewController.h
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/14/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewController : UICollectionViewController

@property NSInteger pagesCount;
@property NSInteger rowsCount;
@property NSInteger minSpacingForLine;
@property NSInteger pagingStyle;
@property BOOL centeringEnabled;
@property BOOL fastSlippingEnabled;
@property BOOL infiniteScrollingEnabled;


@end
