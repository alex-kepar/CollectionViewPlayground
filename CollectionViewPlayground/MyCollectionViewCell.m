//
//  MyCollectionViewCell.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/18/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"Table for page %ld created", (long)self.pageId);
    return self.rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"TableCellsIdentifier" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"Page %ld", (long)self.pageId];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Row %ld", (long)indexPath.row];
    // Configure the cell...
    
    //NSLog(@"Cell %ld for page %ld created", (long)indexPath.row, (long)self.pageId);
   
    return cell;
}

-(void) reloadData
{
    [self.tableView reloadData];
}
@end
