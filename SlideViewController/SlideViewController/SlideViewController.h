//
//  SlideViewController.h
//  SlideViewController
//
//  Created by Charles on 14/10/31.
//  Copyright (c) 2014年 Banggo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TranslucentSideViewController.h"

@interface SlideViewController : UIViewController

@property (nonatomic, strong) UIViewController *rootViewController, *leftViewController, *rightViewController;

// enable and disable dragging
@property(nonatomic, assign) BOOL disableLeftDragging, disableRightDragging;
@property(nonatomic, assign) BOOL disableSlide;

@property(nonatomic,strong)TranslucentSideViewController *leftSideViewController;
@property(nonatomic,strong)TranslucentSideViewController *rightSideViewController;

- (id)initWithRootViewController:(UIViewController*)rootViewController;
//- (void)setLeftViewController:(UIViewController *)leftViewController width:(float)width;

@end
