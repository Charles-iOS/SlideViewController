//
//  LeftViewController.m
//  SlideViewController
//
//  Created by Charles on 15/1/14.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "LeftViewController.h"
#import "SlideViewController.h"
#import "UIViewController+SlideViewController.h"

@implementation LeftViewController

- (IBAction)expand:(id)sender {
    [self.slideViewController.leftSideViewController setContentViewWidth:self.slideViewController.leftSideViewController.oneLevelWidth==self.slideViewController.leftSideViewController.sideWidth?2*self.slideViewController.leftSideViewController.oneLevelWidth:self.slideViewController.leftSideViewController.oneLevelWidth animations:^{
        
    } completion:^{
        
    } animated:YES];
}

@end
