//
//  TranslucentSideViewController.m
//  SlideViewController
//
//  Created by Charles on 14/10/31.
//  Copyright (c) 2014年 Banggo. All rights reserved.
//

#import "TranslucentSideViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface TranslucentSideViewController ()
@property (nonatomic, strong) UIToolbar *translucentView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property CGPoint panStartPoint;
@end

@implementation TranslucentSideViewController

//- (id)init
//{
//    self = [super init];
//    if (self) {
////        [self initTranslucentSideViewController];
//    }
//    return self;
//}

-(id)initWithSideWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        self.sideWidth = width;
        [self initTranslucentSideViewController];
    }
    return self;
}

- (id)initWithDirection:(BOOL)showFromRight sideWidth:(CGFloat)width
{
    self = [super init];
    if (self) {
        _showFromRight = showFromRight;
        self.sideWidth = width;
        [self initTranslucentSideViewController];
    }
    return self;
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        [self initTranslucentSideViewController];
//    }
//    return self;
//}

#pragma mark - Custom Initializer
- (void)initTranslucentSideViewController
{
    _hasShown = NO;
    self.isCurrentPanGestureTarget = NO;
    self.animationDuration = 0.25f;
    
    [self initTranslucentView];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    self.tapGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:self.tapGestureRecognizer];
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    self.panGestureRecognizer.minimumNumberOfTouches = 1;
    self.panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer:self.panGestureRecognizer];
}

- (void)initTranslucentView
{
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        CGRect translucentFrame =
        CGRectMake(self.showFromRight ? self.view.bounds.size.width : -self.sideWidth, 0, self.sideWidth, self.view.bounds.size.height);
        self.translucentView = [[UIToolbar alloc] initWithFrame:translucentFrame];
        self.translucentView.frame = translucentFrame;
        self.translucentView.contentMode = _showFromRight ? UIViewContentModeTopRight : UIViewContentModeTopLeft;
        self.translucentView.clipsToBounds = YES;
        self.translucentView.barStyle = UIBarStyleDefault;
        [self.view.layer insertSublayer:self.translucentView.layer atIndex:0];
    }
}

#pragma mark - Layout
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    
    if ([self isViewLoaded] && self.view.window != nil) {
        [self layoutSubviews];
    }
}

- (void)layoutSubviews
{
    CGFloat x = self.showFromRight ? self.parentViewController.view.bounds.size.width - self.sideWidth : 0;
    
    if (self.contentView != nil) {
        self.contentView.frame = CGRectMake(x, 0, self.sideWidth, self.parentViewController.view.bounds.size.height);
    }
}

#pragma mark - Accessor
- (void)setTranslucentStyle:(UIBarStyle)translucentStyle
{
    self.translucentView.barStyle = translucentStyle;
}

- (UIBarStyle)translucentStyle
{
    return self.translucentView.barStyle;
}

- (void)setTranslucent:(BOOL)translucent
{
    self.translucentView.translucent = translucent;
}

- (BOOL)translucent
{
    return self.translucentView.translucent;
}

- (void)setTranslucentAlpha:(CGFloat)translucentAlpha
{
    self.translucentView.alpha = translucentAlpha;
}

- (CGFloat)translucentAlpha
{
    return self.translucentView.alpha;
}

- (void)setTranslucentTintColor:(UIColor *)translucentTintColor
{
    self.translucentView.tintColor = translucentTintColor;
}

- (UIColor *)translucentTintColor
{
    return self.translucentView.tintColor;
}

#pragma mark - Show
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideViewController:willAppear:)]) {
        [self.delegate sideViewController:self willAppear:animated];
    }
    
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    CGRect sideViewControllerFrame = self.view.bounds;
    sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth : -self.sideWidth;
    sideViewControllerFrame.size.width = self.sideWidth;
    
    if (self.contentView != nil) {
        self.contentView.frame = sideViewControllerFrame;
    }
    sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth - self.sideWidth : 0;
    
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideViewControllerFrame;
        }
        self.translucentView.frame = sideViewControllerFrame;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        self.isCurrentPanGestureTarget = YES;
        if (finished && [self.delegate respondsToSelector:@selector(sideViewController:didAppear:)]) {
            [self.delegate sideViewController:self didAppear:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

- (void)showInViewController:(UIViewController *)controller withAnimations:(void(^)(void))myAnimations completion:(void(^)(void))myCompletion animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideViewController:willAppear:)]) {
        [self.delegate sideViewController:self willAppear:animated];
    }
    
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    CGRect sideViewControllerFrame = self.view.bounds;
    sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth : -self.sideWidth;
    sideViewControllerFrame.size.width = self.sideWidth;
    
    if (self.contentView != nil) {
        self.contentView.frame = sideViewControllerFrame;
    }
    sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth - self.sideWidth : 0;
    
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideViewControllerFrame;
        }
        self.translucentView.frame = sideViewControllerFrame;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
        myAnimations();
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        self.isCurrentPanGestureTarget = YES;
        myCompletion();
        if (finished && [self.delegate respondsToSelector:@selector(sideViewController:didAppear:)]) {
            [self.delegate sideViewController:self didAppear:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

-(void)showWithAnimations:(void(^)(void))myAnimations completion:(void(^)(void))myCompletion animated:(BOOL)animated
{
    UIViewController *controller = nil;
    if (self.inShowViewController) {
        controller = self.inShowViewController;
    }else
    {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (controller.presentedViewController != nil) {
            controller = controller.presentedViewController;
        }
    }
    [self showInViewController:controller withAnimations:myAnimations completion:myCompletion animated:animated];
}

- (void)showAnimated:(BOOL)animated
{
    if (self.inShowViewController) {
        [self showInViewController:self.inShowViewController animated:animated];
    }else
    {
        UIViewController *controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (controller.presentedViewController != nil) {
            controller = controller.presentedViewController;
        }
        [self showInViewController:controller animated:animated];
    }
}

- (void)show
{
    [self showAnimated:YES];
}

-(void)setContentViewWidth:(CGFloat)width animated:(BOOL)animated
{
    self.sideWidth = width;
    CGRect sideViewControllerFrame = self.contentView.frame;
    sideViewControllerFrame.size.width = width;
    self.view.userInteractionEnabled = NO;
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideViewControllerFrame;
        }
        self.translucentView.frame = sideViewControllerFrame;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        self.isCurrentPanGestureTarget = YES;
        self.view.userInteractionEnabled = YES;
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}
//make other animations
-(void)setContentViewWidth:(CGFloat)width animations:(void (^)(void))myAnimations completion:(void(^)(void))myCompletion animated:(BOOL)animated
{
    self.sideWidth = width;
    CGRect sideViewControllerFrame = self.contentView.frame;
    sideViewControllerFrame.size.width = width;
    if (self.showFromRight) {
        CGFloat parentWidth = self.view.bounds.size.width;
        sideViewControllerFrame.origin.x = parentWidth - width;
    }
    self.view.userInteractionEnabled = NO;
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideViewControllerFrame;
        }
        self.translucentView.frame = sideViewControllerFrame;
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.2];
        myAnimations();
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        self.isCurrentPanGestureTarget = YES;
        self.view.userInteractionEnabled = YES;
        myCompletion();
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

#pragma mark - Show by PanGesture
- (void)startShow:(CGFloat)startX
{
    UIViewController *controller = nil;
    if (self.inShowViewController) {
        controller = self.inShowViewController;
    }else
    {
        controller = [UIApplication sharedApplication].keyWindow.rootViewController;
        while (controller.presentedViewController != nil) {
            controller = controller.presentedViewController;
        }
    }
    [self addToParentViewController:controller callingAppearanceMethods:YES];
    self.view.frame = controller.view.bounds;
    
    CGFloat parentWidth = self.view.bounds.size.width;
    
    CGRect sideViewControllerFrame = self.view.bounds;
    sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth : -self.sideWidth;
    sideViewControllerFrame.size.width = self.sideWidth;
    if (self.contentView != nil) {
        self.contentView.frame = sideViewControllerFrame;
    }
    self.translucentView.frame = sideViewControllerFrame;
}

- (void)move:(CGFloat)deltaFromStartX
{
    CGRect sideViewControllerFrame = self.translucentView.frame;
    CGFloat parentWidth = self.view.bounds.size.width;
    
    if (self.showFromRight) {
        CGFloat x = deltaFromStartX;
        if (deltaFromStartX >= self.sideWidth) {
            x = self.sideWidth;
        }
        sideViewControllerFrame.origin.x = parentWidth - x;
    } else {
        CGFloat x = deltaFromStartX - _sideWidth;
        if (x >= 0) {
            x = 0;
        }
        sideViewControllerFrame.origin.x = x;
    }
    
    if (self.contentView != nil) {
        self.contentView.frame = sideViewControllerFrame;
    }
    self.translucentView.frame = sideViewControllerFrame;
}

- (void)showAnimatedFrom:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX
{
    if ([self.delegate respondsToSelector:@selector(sideViewController:willAppear:)]) {
        [self.delegate sideViewController:self willAppear:animated];
    }
    
    CGRect sideViewControllerFrame = self.translucentView.frame;
    CGFloat parentWidth = self.view.bounds.size.width;
    
    sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth - sideViewControllerFrame.size.width : 0;
    
    void (^animations)() = ^{
        if (self.contentView != nil) {
            self.contentView.frame = sideViewControllerFrame;
        }
        
        self.translucentView.frame = sideViewControllerFrame;
    };
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        _hasShown = YES;
        if (finished && [self.delegate respondsToSelector:@selector(sideViewController:didAppear:)]) {
            [self.delegate sideViewController:self didAppear:animated];
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:self.animationDuration delay:0 options:kNilOptions animations:animations completion:completion];
    } else {
        animations();
        completion(YES);
    }
}

#pragma mark - Dismiss
- (void)dismiss
{
    if (self.dismissAnimationBlock) {
        [self dismissWithAnimations:self.dismissAnimationBlock animated:YES];
    }else{
        [self dismissAnimated:YES];
    }
}

- (void)dismissAnimated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideViewController:willDisappear:)]) {
        [self.delegate sideViewController:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        _hasShown = NO;
        self.isCurrentPanGestureTarget = NO;
        if ([self.delegate respondsToSelector:@selector(sideViewController:didDisappear:)]) {
            [self.delegate sideViewController:self didDisappear:animated];
        }
//        self.sideWidth = self.oneLevelWidth;
    };
    
    if (animated) {
        CGRect sideViewControllerFrame = self.translucentView.frame;
        CGFloat parentWidth = self.view.bounds.size.width;
        sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth : -self.sideWidth;
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (self.contentView != nil) {
                                 self.contentView.frame = sideViewControllerFrame;
                             }
                             self.translucentView.frame = sideViewControllerFrame;
                             self.view.backgroundColor = [UIColor clearColor];
                         }
                         completion:completion];
    } else {
        completion(YES);
    }
}

- (void)dismissWithAnimations:(void (^)(void))myAnimations animated:(BOOL)animated
{
    if ([self.delegate respondsToSelector:@selector(sideViewController:willDisappear:)]) {
        [self.delegate sideViewController:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        _hasShown = NO;
        self.isCurrentPanGestureTarget = NO;
        if ([self.delegate respondsToSelector:@selector(sideViewController:didDisappear:)]) {
            [self.delegate sideViewController:self didDisappear:animated];
        }
//        self.sideWidth = self.oneLevelWidth;
    };
    
    if (animated) {
        CGRect sideViewControllerFrame = self.translucentView.frame;
        CGFloat parentWidth = self.view.bounds.size.width;
        sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth : -self.sideWidth;
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (self.contentView != nil) {
                                 self.contentView.frame = sideViewControllerFrame;
                             }
                             self.translucentView.frame = sideViewControllerFrame;
                             self.view.backgroundColor = [UIColor clearColor];
                             myAnimations();
                         }
                         completion:completion];
    } else {
        completion(YES);
    }
}

#pragma mark - Dismiss by Pangesture
- (void)dismissAnimated:(BOOL)animated deltaX:(CGFloat)deltaXFromStartXToEndX
{
    if ([self.delegate respondsToSelector:@selector(sideViewController:willDisappear:)]) {
        [self.delegate sideViewController:self willDisappear:animated];
    }
    
    void (^completion)(BOOL) = ^(BOOL finished)
    {
        [self removeFromParentViewControllerCallingAppearanceMethods:YES];
        _hasShown = NO;
        self.isCurrentPanGestureTarget = NO;
        if ([self.delegate respondsToSelector:@selector(sideViewController:didDisappear:)]) {
            [self.delegate sideViewController:self didDisappear:animated];
        }
//        self.sideWidth = self.oneLevelWidth;
    };
    
    if (animated) {
        CGRect sideViewControllerFrame = self.translucentView.frame;
        CGFloat parentWidth = self.view.bounds.size.width;
        sideViewControllerFrame.origin.x = self.showFromRight ? parentWidth : -self.sideWidth + deltaXFromStartXToEndX;
        
        [UIView animateWithDuration:self.animationDuration
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             if (self.contentView != nil) {
                                 self.contentView.frame = sideViewControllerFrame;
                             }
                             self.translucentView.frame = sideViewControllerFrame;
                         }
                         completion:completion];
    } else {
        completion(YES);
    }
}

#pragma mark - Gesture Handler
- (void)handleTapGesture:(UITapGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:self.view];
    if (!CGRectContainsPoint(self.translucentView.frame, location)) {
        if (self.dismissAnimationBlock) {
            [self dismissWithAnimations:self.dismissAnimationBlock animated:YES];
        }else
            [self dismissAnimated:YES];
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    if (_disablePanGuesture) {
        return;
    }
    if (!self.isCurrentPanGestureTarget) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = [recognizer locationInView:self.view];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [recognizer locationInView:self.view];
        if (!self.showFromRight) {
            [self move:self.sideWidth + currentPoint.x - self.panStartPoint.x];
        } else {
            [self move:self.sideWidth + self.panStartPoint.x - currentPoint.x];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [recognizer locationInView:self.view];
        
        if (!self.showFromRight) {
            if (self.panStartPoint.x - endPoint.x < self.sideWidth / 3) {
                [self showAnimatedFrom:YES deltaX:endPoint.x - self.panStartPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:endPoint.x - self.panStartPoint.x];
            }
        } else {
            if (self.panStartPoint.x - endPoint.x >= self.sideWidth / 3) {
                [self showAnimatedFrom:YES deltaX:self.panStartPoint.x - endPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:self.panStartPoint.x - endPoint.x];
            }
        }
    }
}

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView
{
    if (!self.isCurrentPanGestureTarget) {
        return;
    }
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.panStartPoint = [recognizer locationInView:parentView];
        [self startShow:self.panStartPoint.x];
    }
    
    if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint currentPoint = [recognizer locationInView:parentView];
        if (!self.showFromRight) {
            [self move:currentPoint.x - self.panStartPoint.x];
        } else {
            [self move:self.panStartPoint.x - currentPoint.x];
        }
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint endPoint = [recognizer locationInView:parentView];
        
        if (!self.showFromRight) {
            if (endPoint.x - self.panStartPoint.x >= self.sideWidth / 3) {
                [self showAnimatedFrom:YES deltaX:endPoint.x - self.panStartPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:endPoint.x - self.panStartPoint.x];
            }
        } else {
            if (self.panStartPoint.x - endPoint.x >= self.sideWidth / 3) {
                [self showAnimatedFrom:YES deltaX:self.panStartPoint.x - endPoint.x];
            } else {
                [self dismissAnimated:YES deltaX:self.panStartPoint.x - endPoint.x];
            }
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view != gestureRecognizer.view) {
        return NO;
    }
    return YES;
}

#pragma mark - ContentView
- (void)setSideViewControllerContentView:(UIView *)contentView
{
    if (self.contentView != nil) {
        [self.contentView removeFromSuperview];
    }
    
    self.contentView = contentView;
    self.contentView.frame = self.translucentView.frame;
    self.contentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentView];
}

#pragma mark - Helper
- (void)addToParentViewController:(UIViewController *)parentViewController callingAppearanceMethods:(BOOL)callAppearanceMethods
{
    if (self.parentViewController != nil) {
        [self removeFromParentViewControllerCallingAppearanceMethods:callAppearanceMethods];
    }
    
    if (callAppearanceMethods) [self beginAppearanceTransition:YES animated:NO];
    [parentViewController addChildViewController:self];
    [parentViewController.view addSubview:self.view];
    [self didMoveToParentViewController:self];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

- (void)removeFromParentViewControllerCallingAppearanceMethods:(BOOL)callAppearanceMethods
{
    if (callAppearanceMethods) [self beginAppearanceTransition:NO animated:NO];
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    if (callAppearanceMethods) [self endAppearanceTransition];
}

@end
