//
//  SlideViewController.m
//  SlideViewController
//
//  Created by Charles on 14/10/31.
//  Copyright (c) 2014年 Banggo. All rights reserved.
//

#import "SlideViewController.h"
#import "UIViewController+SlideViewController.h"

@interface SlideViewController ()<TranslucentSideViewControllerDelegate>

@end

@implementation SlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Add PanGesture to Show SideViewController by PanGesture
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (id)initWithRootViewController:(UIViewController*)rootViewController
{
    self = [super init];
    if (self) {
        _rootViewController = rootViewController;
        [_rootViewController.view setFrame:CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height)];
        [self.view addSubview:_rootViewController.view];
        rootViewController.slideViewController = self;
        // Add PanGesture to Show SideViewController by PanGesture
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        [self.view addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

-(void)setLeftViewController:(UIViewController *)leftViewController
{
    _leftViewController = leftViewController;
//    [self.leftViewController.view setFrame:CGRectMake(0,0,leftViewController.view.bounds.size.width,self.view.bounds.size.height)];
    
    // Create SideViewController and set properties
    self.leftSideViewController = [[TranslucentSideViewController alloc] initWithSideWidth:leftViewController.view.bounds.size.width];
    leftViewController.slideViewController = self;
    self.leftSideViewController.oneLevelWidth = leftViewController.view.bounds.size.width;
    self.leftSideViewController.delegate = self;
    self.leftSideViewController.tag = 0;
    
    // Set ContentView in SideViewController
    [self.leftSideViewController setSideViewControllerContentView:leftViewController.view];
}

-(void)setRightViewController:(UIViewController *)rightViewController
{
    _rightViewController = rightViewController;
//    [self.rightViewController.view setFrame:CGRectMake(0,0,rightViewController.view.bounds.size.width,self.view.bounds.size.height)];
    
    // Create Right Side
    self.rightSideViewController = [[TranslucentSideViewController alloc] initWithDirection:YES sideWidth:rightViewController.view.bounds.size.width];
    rightViewController.slideViewController = self;
    self.rightSideViewController.oneLevelWidth = rightViewController.view.bounds.size.width;
    self.rightSideViewController.delegate = self;
    self.rightSideViewController.tag = 1;
    
    // Set ContentView in SideViewController
    [self.rightSideViewController setSideViewControllerContentView:rightViewController.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setDisableLeftDragging:(BOOL)disableLeftDragging
{
    _disableLeftDragging = disableLeftDragging;
    self.leftSideViewController.disablePanGuesture = disableLeftDragging;
}

-(void)setDisableRightDragging:(BOOL)disableRightDragging
{
    _disableRightDragging = disableRightDragging;
    self.rightSideViewController.disablePanGuesture = disableRightDragging;
}

#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (self.disableSlide) {
        return;
    }
    // if you have left and right SideViewController, you can control the pan gesture by start point.
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint startPoint = [recognizer locationInView:self.view];
        
        // LeftSide
        if (startPoint.x < self.view.bounds.size.width / 2.0) {
            if (!self.disableLeftDragging) {
                self.leftSideViewController.isCurrentPanGestureTarget = YES;
            }
        }
        // RightSide
        else {
            if (!self.disableRightDragging) {
                self.rightSideViewController.isCurrentPanGestureTarget = YES;
            }
        }
    }
    
    [self.leftSideViewController handlePanGestureToShow:recognizer inView:self.view];
    [self.rightSideViewController handlePanGestureToShow:recognizer inView:self.view];
}

#pragma mark - TranslucentSideViewControllerDelegate

#pragma mark -

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
