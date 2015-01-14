//
//  ViewController.m
//  SlideViewController
//
//  Created by Charles on 15/1/13.
//  Copyright (c) 2015年 Charles. All rights reserved.
//

#import "ViewController.h"
#import "UIViewController+SlideViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)showLeft:(id)sender {
    [self.slideViewController.leftSideViewController show];
}
- (IBAction)showRight:(id)sender {
    [self.slideViewController.rightSideViewController show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
