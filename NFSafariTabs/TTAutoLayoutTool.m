//
//  TTAutoLayoutTool.m
//  BitBarrier
//
//  Created by fanzhang on 15/9/21.
//  Copyright © 2015年 hiroto. All rights reserved.
//

#import "TTAutoLayoutTool.h"

@implementation TTAutoLayoutTool

+ (NSArray*)letView:(UIView*)subView FillInView:(UIView*)superView
{
    return [self letView:subView FillInView:superView withInset:UIEdgeInsetsZero];
}

+ (NSArray*)letView:(UIView*)subView FillInView:(UIView*)superView withInset:(UIEdgeInsets)inset
{
    NSLayoutConstraint* top = [NSLayoutConstraint constraintWithItem:subView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:superView
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:inset.top];
    
    NSLayoutConstraint* leading = [NSLayoutConstraint constraintWithItem:subView
                                                              attribute:NSLayoutAttributeLeading
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeLeading
                                                             multiplier:1.0
                                                               constant:inset.left];
    NSLayoutConstraint* bottom = [NSLayoutConstraint constraintWithItem:subView
                                                              attribute:NSLayoutAttributeBottom
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0
                                                               constant:inset.bottom];
    
    NSLayoutConstraint* trailing = [NSLayoutConstraint constraintWithItem:subView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:superView
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:inset.right];

    [superView addConstraint:top];
    [superView addConstraint:leading];
    [superView addConstraint:bottom];
    [superView addConstraint:trailing];
    
    return @[ top, leading, bottom, trailing ];
}

@end
