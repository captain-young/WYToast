//
//  WYToast.m
//  WYToast
//
//  Created by 杨新威 on 2018/3/1.
//  Copyright © 2018年 杨新威. All rights reserved.
//

#import "WYToast.h"

#define DISMISS_ANIMATION  @"DISMISS_ANIMATION"

@interface WYToast()

@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, strong) UIImageView *toastImageView;

@property (nonatomic, strong) UIColor *toastBackgroundColor;
@property (nonatomic, strong) UIFont *toastFont;
@property (nonatomic, strong) UIColor *toastColor;
@property (nonatomic, assign) CGFloat maxDismissInterval;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat animationInterval;
@property (nonatomic, assign) CGFloat toastHeight;

@end

@implementation WYToast
static WYToast *_toast;

#pragma mark interface method

+ (void)showWithToast:(NSString *)toast{
    [WYToast checkTitle:toast];
    [WYToast showUpToast];
    [WYToast addGesture];
}


#pragma mark
+ (instancetype)shareToast{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _toast = [[WYToast alloc] init];
    });
    return _toast;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.toastFont = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        self.toastColor = [UIColor whiteColor];
        self.padding = 40.f;
        self.animationInterval = 0.5f;
        self.toastBackgroundColor = [UIColor blackColor];
        self.toastHeight = 30;
        self.maxDismissInterval = 2.f;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3;
        [self addSubview:self.toastLabel];
    }
    return self;
}

//
+ (void)showUpToast{
    WYToast *toast = [self shareToast];
    toast.toastLabel.textColor = toast.toastColor;
    toast.toastLabel.font = toast.toastFont;
    toast.backgroundColor = toast.toastBackgroundColor;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:toast];
    
    CGFloat topHeight = [UIScreen mainScreen].bounds.size.height>=812 ? 64 : 44;
    [UIView animateWithDuration:toast.animationInterval animations:^{
        toast.frame = CGRectMake(toast.frame.origin.x, topHeight, toast.frame.size.width, toast.toastHeight);
    }completion:^(BOOL finished) {
        [WYToast performSelector:@selector(hiddenToast) withObject:DISMISS_ANIMATION afterDelay:toast.maxDismissInterval];
    }];
}

+ (void)showDownToast{
    WYToast *toast = [self shareToast];
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    [window addSubview:toast];
    
}

+ (void)hiddenToast{
    WYToast *toast = [WYToast shareToast];
    if (toast.frame.origin.y < 0) return;
    [UIView animateWithDuration:toast.animationInterval animations:^{
        toast.frame = CGRectMake(toast.frame.origin.x, - toast.toastHeight, toast.frame.size.width, toast.toastHeight);
    }completion:^(BOOL finished) {
        [toast removeFromSuperview];
    }];
}



#pragma mark private method
// 计算文本宽度
+ (CGFloat)calWidthWithString:(NSString *)toast{
    if (!toast || toast.length == 0) {
        return 0;
    }
    CGSize size = [toast sizeWithAttributes:@{NSFontAttributeName:[WYToast shareToast].toastFont}];
    return size.width;
}

+ (CGFloat)calDismissIntervalWithString:(NSString *)toast{
    if (!toast || toast.length == 0) {
        return 0;
    }
    return 1 + toast.length * 0.2;
}

+ (void)checkTitle:(NSString *)title{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenToast) object:DISMISS_ANIMATION];
    CGFloat toastWidth = [self calWidthWithString:title];
    WYToast *toast = [WYToast shareToast];
    toast.toastLabel.text = [NSString stringWithFormat:@"%@",title];
    toast.toastLabel.frame = CGRectMake(0, 0, toast.padding + toastWidth, toast.toastHeight);
    toast.frame = CGRectMake(0, 0, toast.padding + toastWidth, toast.toastHeight);
    toast.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, -toast.toastHeight/2);

}

+ (void)addGesture{
    WYToast *toast = [WYToast shareToast];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenToast)];
    [toast addGestureRecognizer:tap];
}

#pragma mark lazy load
- (UILabel *)toastLabel{
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] init];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
    }return _toastLabel;
}

- (UIImageView *)toastImageView{
    if (!_toastImageView) {
        _toastImageView = [[UIImageView alloc] init];
        _toastImageView.contentMode = UIViewContentModeScaleAspectFill;
    }return _toastImageView;
}

@end
