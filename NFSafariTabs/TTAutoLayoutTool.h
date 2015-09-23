//
//  TTAutoLayoutTool.h
//  BitBarrier
//
//  Created by fanzhang on 15/9/21.
//  Copyright © 2015年 hiroto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TTAutoLayoutTool : NSObject

+ (NSArray*)letView:(UIView*)subView FillInView:(UIView*)superView;
+ (NSArray*)letView:(UIView*)subView FillInView:(UIView*)superView withInset:(UIEdgeInsets)inset;

@end
