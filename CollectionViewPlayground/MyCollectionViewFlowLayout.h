//
//  MyCollectionViewFlowLayout.h
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/17/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewFlowLayout : UICollectionViewFlowLayout

@property (readonly) NSInteger currentPage;


-(void)scrollToPage:(NSInteger)page;
-(void)scrollToPage:(NSInteger)page animated:(BOOL)animated;

@end
