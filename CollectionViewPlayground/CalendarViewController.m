//
//  CalendarViewController.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 9/24/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "CalendarViewController.h"
#import "UICollectionViewMy.h"

@interface CalendarViewController ()
@property (weak, nonatomic) IBOutlet UICollectionViewMy *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation CalendarViewController

static NSString * const reuseIdentifier = @"cellsTemplate";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)buttonAction:(id)sender {
    if (self.collectionView.hidden) {
        
        void (^showBlock)() = ^void() {
            CGRect frame = self.collectionView.frame;
            self.collectionView.frame = CGRectMake(frame.origin.x, 0 - frame.size.height, frame.size.width, frame.size.height);
            self.collectionView.hidden = NO;
            self.collectionView.frame = frame;
        };

//        [UIView animateWithDuration:1
//                         animations:showBlock];
        
//        [UIView transitionWithView:self.collectionView
//                          duration:0.5
//                           options:UIViewAnimationOptionTransitionCurlDown
//                        animations:showBlock
//                        completion:nil];

//        [UIView animateWithDuration:0.5
//                              delay:0
//             usingSpringWithDamping:1
//              initialSpringVelocity:0.8
//                            options:animationOptions
//                         animations:showBlock
//                         completion:nil];
        
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:1
              initialSpringVelocity:0.8
                            options:UIViewAnimationOptionTransitionNone
                         animations:showBlock
                         completion:^(BOOL finished) {
                             if (finished) {
                                 NSLog(@"aaaaaaa");
                             }
                         }];
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    return cell;
}

@end
