//
//  UICollectionViewMy.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 9/24/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "UICollectionViewMy.h"

@implementation UICollectionViewMy

bool flag;

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {

    NSLog(@"%i", event.type);
    
    UIView *view = [super hitTest:point withEvent:event];
    
    if (![self pointInside:point withEvent:event])
    {
        if (!self.hidden && !flag) {
            //flag = YES;
            
            CGRect frame = self.frame;
            void (^showBlock)() = ^void() {
//                self.hidden = YES;
                self.frame = CGRectMake(frame.origin.x, 0 - frame.size.height, frame.size.width, frame.size.height);
//                self.hidden = YES;
//                self.frame = frame;
                //self.frame = frame;

            };

//            void (^completionBlock)(BOOL finished) = ^void(BOOL finished) {
//                if (finished) {
//                    self.hidden = YES;
//                    self.frame = frame;
//
//                }
//            };
            
            [UIView animateWithDuration:0.5
                                  delay:0.2
                 usingSpringWithDamping:1
                  initialSpringVelocity:0.8
                                options:UIViewAnimationOptionTransitionNone
                             animations:showBlock
                             completion:^(BOOL finished) {
                                 if (finished) {
                                     self.frame = frame;
//                                     //self.alpha = 0;
                                     self.hidden = YES;
                                     NSLog(@"ddddd");
                                     flag = NO;
                                 }
                             }];

            
        }
    }
    return view;
}


//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    BOOL res = [super pointInside:point withEvent:event];
//    if (!res) {
//        if (event.type == UIEventTypeTouches)
//        {
//        NSLog(@"outside");
//        }
//    }
//    else
//    {
//        NSLog(@"inside");
//    }
//    return res;
//}

@end
