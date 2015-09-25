//
//  UICollectionViewMy.m
//  CollectionViewPlayground
//
//  Created by Oleksandr Kiporenko on 9/24/15.
//  Copyright (c) 2015 QVC. All rights reserved.
//

#import "UICollectionViewMy.h"

@implementation UICollectionViewMy

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    if (![self pointInside:point withEvent:event])
    {
        self.hidden = YES;
    }
    return [super hitTest:point withEvent:event];
}

@end
