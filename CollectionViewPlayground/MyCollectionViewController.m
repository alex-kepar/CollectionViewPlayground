//
//  MyCollectionViewController.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/14/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionViewCell.h"
#import "MyDetailViewController.h"
#import "MyCollectionViewFlowLayout.h"
#import "MyCyrcleLayout.h"
#import "QVCUniSliderFlowLayout.h"

@interface MyCollectionViewController ()
{
    NSArray *cellsList;
}

@end

@implementation MyCollectionViewController

static NSString * const reuseIdentifier = @"cellsTemplate";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self.collectionViewLayout isKindOfClass:[MyCyrcleLayout class]])
    {
        MyCyrcleLayout *layout = (MyCyrcleLayout*)self.collectionViewLayout;
        layout.minimumLineSpacing = self.minSpacingForLine;
        layout.pagingStyle = self.pagingStyle;
        layout.centeringEnabled = self.centeringEnabled;
        layout.fastSlippingEnabled = self.fastSlippingEnabled;
        layout.infiniteScrollingEnabled = self.infiniteScrollingEnabled;
    }
    else if ([self.collectionViewLayout isKindOfClass:[QVCUniSliderFlowLayout class]])
    {
        QVCUniSliderFlowLayout *layout = (QVCUniSliderFlowLayout*)self.collectionViewLayout;
        layout.minimumLineSpacing = self.minSpacingForLine;
        layout.pagingStyle = self.pagingStyle;
        layout.centeringEnabled = self.centeringEnabled;
        layout.fastSlippingEnabled = self.fastSlippingEnabled;
        layout.infiniteScrollingEnabled = self.infiniteScrollingEnabled;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    //[(MyCollectionViewFlowLayout*)self.collectionView.collectionViewLayout scrollToPage:2];
    //[self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
////    [self.collectionView performBatchUpdates:nil completion:nil];
//    [super viewWillAppear:animated];
//    
////    CGSize size1 = self.collectionView.collectionViewLayout.collectionViewContentSize;
////    CGSize size2 = self.collectionViewLayout.collectionViewContentSize;
//    
//    //UIEdgeInsets result = self.collectionView.contentInset;
//    
//    //[self.collectionView.collectionViewLayout invalidateLayout];
////    CGSize fromCollectionViewSize = [self collectionViewSizeForOrientation:[self interfaceOrientation]];
////    CGSize toCollectionViewSize = [self collectionViewSizeForOrientation:toInterfaceOrientation];
////    CGSize size = [self collectionViewSizeForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
////    self.collectionView.frame = CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, size.width, size.height);
////    [self.collectionView.collectionViewLayout invalidateLayout];
//    
////    [self.collectionView reloadData];
////    [self.collectionView performBatchUpdates:^{
////        [self.collectionView.collectionViewLayout invalidateLayout];
////    } completion:^(BOOL finished) {
////    }];
}

- (CGSize)collectionViewSizeForOrientation:(UIInterfaceOrientation)orientation
{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat width = UIInterfaceOrientationIsLandscape(orientation) ? MAX(screenSize.width, screenSize.height) : MIN(screenSize.width, screenSize.height);
    CGFloat height = UIInterfaceOrientationIsLandscape(orientation) ? MIN(screenSize.width, screenSize.height) : MAX(screenSize.width, screenSize.height);
    
    return CGSizeMake(width, height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"DetailViewSegue"])
    {
        if ([sender isKindOfClass:[UITableViewCell class]])
        {
            if ([segue.destinationViewController isKindOfClass:[MyDetailViewController class]])
            {
                UITableViewCell *cell = sender;
                MyDetailViewController *detailViewController = segue.destinationViewController;
                detailViewController.page = cell.textLabel.text;
                detailViewController.row = cell.detailTextLabel.text;
            }
        }
    }
}

#pragma mark <UICollectionViewDataSource>

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//#warning Incomplete method implementation -- Return the number of sections
//    return 0;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.pagesCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.pageId = indexPath.row;//[cellsList[indexPath.row] integerValue];
    cell.rowsCount = self.rowsCount;
    [cell reloadData];
    // Configure the cell
    //NSLog(@"Cell %ld created", (long)cell.pageId);
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark <UICollectionViewDelegateFlowLayout>

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    UIEdgeInsets result = collectionView.contentInset;
//    if ([collectionViewLayout isKindOfClass:[UICollectionViewFlowLayout class]])
//    {
//        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout*)collectionViewLayout;
//        CGFloat contentInsetLeftRight = ((collectionView.bounds.size.width  - flowLayout.itemSize.width) * 0.5f);
//        CGFloat contentInsetTopBottom = ((collectionView.bounds.size.height  - flowLayout.itemSize.height) * 0.5f) - 32;
//        result = UIEdgeInsetsMake(contentInsetTopBottom, contentInsetLeftRight, contentInsetTopBottom, contentInsetLeftRight);
//    }
//    return result;
//}
//
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
//{
//    [self.collectionView performBatchUpdates:nil completion:nil];
//}

//-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
//{
//    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
////    [self.collectionView performBatchUpdates:nil completion:nil];
//    [self.collectionView.collectionViewLayout invalidateLayout];
//}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"****************************** scrollViewWillBeginDecelerating");
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"****************************** scrollViewDidEndDecelerating");
}

@end
