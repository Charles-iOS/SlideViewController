//
//  TranslucentSideViewController.h
//  SlideViewController
//
//  Created by Charles on 14/10/31.
//  Copyright (c) 2014年 Banggo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DismissAnimationBlock)(void);

@class TranslucentSideViewController;
@protocol TranslucentSideViewControllerDelegate <NSObject>
@optional
- (void)sideViewController:(TranslucentSideViewController *)sideViewController didAppear:(BOOL)animated;
- (void)sideViewController:(TranslucentSideViewController *)sideViewController willAppear:(BOOL)animated;
- (void)sideViewController:(TranslucentSideViewController *)sideViewController didDisappear:(BOOL)animated;
- (void)sideViewController:(TranslucentSideViewController *)sideViewController willDisappear:(BOOL)animated;
@end

@interface TranslucentSideViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, assign) CGFloat sideWidth;
@property (nonatomic, assign) CGFloat oneLevelWidth;
@property (nonatomic, assign) CGFloat animationDuration;
@property (nonatomic) BOOL translucent;
@property (nonatomic) UIBarStyle translucentStyle;
@property (nonatomic) CGFloat translucentAlpha;
@property (nonatomic, strong) UIColor *translucentTintColor;
@property (readonly) BOOL hasShown;
@property (readonly) BOOL showFromRight;
@property BOOL isCurrentPanGestureTarget;
@property NSInteger tag;
@property (nonatomic)BOOL disablePanGuesture;
@property (nonatomic,copy)DismissAnimationBlock dismissAnimationBlock;

@property(nonatomic,weak)UIViewController *inShowViewController;//the view controller show in

@property (nonatomic, weak) id<TranslucentSideViewControllerDelegate> delegate;

-(id)initWithSideWidth:(CGFloat)width;
- (id)initWithDirection:(BOOL)showFromRight sideWidth:(CGFloat)width;

- (void)show;
- (void)showAnimated:(BOOL)animated;
- (void)showInViewController:(UIViewController *)controller animated:(BOOL)animated;
//animation extension ↓↓↓↓↓↓↓ 动画扩展 不适用于手势！
- (void)showInViewController:(UIViewController *)controller withAnimations:(void(^)(void))myAnimations completion:(void(^)(void))myCompletion animated:(BOOL)animated;
- (void)showWithAnimations:(void(^)(void))myAnimations completion:(void(^)(void))myCompletion animated:(BOOL)animated;
//extension ↑↑↑↑↑↑↑ 动画扩展 不适用于手势！
-(void)setContentViewWidth:(CGFloat)width animated:(BOOL)animated;
-(void)setContentViewWidth:(CGFloat)width animations:(void (^)(void))myAnimations completion:(void(^)(void))myCompletion animated:(BOOL)animated;

- (void)dismiss;
- (void)dismissAnimated:(BOOL)animated;
- (void)dismissWithAnimations:(void (^)(void))myAnimations animated:(BOOL)animated;//extension  不适用于手势！

- (void)handlePanGestureToShow:(UIPanGestureRecognizer *)recognizer inView:(UIView *)parentView;

- (void)setSideViewControllerContentView:(UIView *)contentView;

@end
