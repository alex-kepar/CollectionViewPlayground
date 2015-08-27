//
//  ViewController.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 8/14/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "ViewController.h"
#import "MyCollectionViewController.h"

NSString* const pagesLabelFormat = @"Pages: %0.0f";
NSString* const rowsLabelFormat = @"Rows: %0.0f";
NSString* const minSpaceForLineLabelFormat = @"Min spacing: %0.0f";

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIStepper *pagesStepper;
@property (weak, nonatomic) IBOutlet UIStepper *rowsStepper;
@property (weak, nonatomic) IBOutlet UILabel *pagesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rowsCountLabel;
@property (weak, nonatomic) IBOutlet UISwitch *pagingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *centeringSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fastSlippingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *infinityScrollingSwitch;
@property (weak, nonatomic) IBOutlet UIStepper *minSpacingForLineStepper;
@property (weak, nonatomic) IBOutlet UILabel *minSpacingForLineLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateLabel:self.pagesCountLabel withFormat:pagesLabelFormat toValue:self.pagesStepper.value];
    [self updateLabel:self.rowsCountLabel withFormat:rowsLabelFormat toValue:self.rowsStepper.value];
    [self updateLabel:self.minSpacingForLineLabel withFormat:minSpaceForLineLabelFormat toValue:self.minSpacingForLineStepper.value];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLabel:(UILabel*)label withFormat:(NSString*)format toValue:(double)value
{
    label.text = [NSString stringWithFormat:format, value];
}

- (IBAction)pagesStepperAction:(UIStepper *)sender {
    [self updateLabel:self.pagesCountLabel withFormat:pagesLabelFormat toValue:sender.value];
}

- (IBAction)rowsStepperAction:(UIStepper *)sender {
    [self updateLabel:self.rowsCountLabel withFormat:rowsLabelFormat toValue:sender.value];
}
- (IBAction)minSpacingForLineStepperAction:(UIStepper *)sender {
    [self updateLabel:self.minSpacingForLineLabel withFormat:minSpaceForLineLabelFormat toValue:sender.value];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"toCollectionSegue"])
    {
        if ([segue.destinationViewController isKindOfClass:[MyCollectionViewController class]])
        {
            MyCollectionViewController *collectionViewController = segue.destinationViewController;
            collectionViewController.pagesCount = self.pagesStepper.value;
            collectionViewController.rowsCount = self.rowsStepper.value;
            collectionViewController.minSpacingForLine = self.minSpacingForLineStepper.value;
            collectionViewController.pagingEnabled = self.pagingSwitch.on;
            collectionViewController.centeringEnabled = self.centeringSwitch.on;
            collectionViewController.fastSlippingEnabled = self.fastSlippingSwitch.on;
            collectionViewController.infinityScrollingEnabled = self.infinityScrollingSwitch.on;
        }
    }
}

@end
