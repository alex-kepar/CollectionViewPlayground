//
//  MyCollectionViewCell.h
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/18/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell <UITableViewDataSource>

@property NSInteger pageId;
@property NSInteger rowsCount;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

-(void)reloadData;

@end
