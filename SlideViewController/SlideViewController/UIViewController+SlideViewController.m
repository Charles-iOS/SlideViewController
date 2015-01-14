//
//  UIViewController+SlideViewController.m
//  SlideViewController
//
//  Created by Charles on 14/10/31.
//  Copyright (c) 2014年 Banggo. All rights reserved.
//

#import "UIViewController+SlideViewController.h"
#import <objc/runtime.h>

@implementation UIViewController (SlideViewController)

static void *SlideViewControllerPorpertyKey = @"SlideViewControllerPorpertyKey";

-(void)setSlideViewController:(SlideViewController *)slideViewController
{
    objc_setAssociatedObject(self, SlideViewControllerPorpertyKey, slideViewController, OBJC_ASSOCIATION_ASSIGN);
}

-(SlideViewController *)slideViewController
{
    return objc_getAssociatedObject(self, SlideViewControllerPorpertyKey);
}

@end
