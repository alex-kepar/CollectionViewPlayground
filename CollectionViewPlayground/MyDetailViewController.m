//
//  MyDetailViewController.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/18/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "MyDetailViewController.h"

@interface MyDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pageIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowIdLabel;

@end

@implementation MyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.pageIdLabel.text = self.page;
    self.rowIdLabel.text = self.row;
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

@end
