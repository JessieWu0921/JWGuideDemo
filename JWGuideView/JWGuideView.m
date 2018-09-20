//
//  JWGuideView.m
//  JWGuideView
//
//  Created by JessieWu on 2018/7/18.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "JWGuideView.h"
#import <QuartzCore/QuartzCore.h>
#import <Masonry/Masonry.h>

#define HorizontalOffset     20
#define VerticalOffset       15
#define ScreenWidth          CGRectGetWidth([UIScreen mainScreen].bounds)

@implementation JWGuideInfo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.insetEdge = UIEdgeInsetsMake(-8, -8, -8, -8);  //默认
        self.cornRadius = 20.0f;
    }
    return self;
}

@end

@interface JWGuideView()

@property (nonatomic, strong) UIImageView *guideInfoImageView;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, copy) NSArray<JWGuideInfo *> *guideInfos;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, copy) ActionHandle handle;


@end

@implementation JWGuideView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - setter & getter
- (CAShapeLayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        _maskLayer.frame = self.frame;
    }
    return _maskLayer;
}

- (UIImageView *)guideInfoImageView {
    if (!_guideInfoImageView) {
        _guideInfoImageView = [[UIImageView alloc] init];
    }
    return _guideInfoImageView;
}

- (UIButton *)actionBtn {
    if (!_actionBtn) {
        _actionBtn = [[UIButton alloc] init];
    }
    return _actionBtn;
}

#pragma mark - UI
- (void)setupUI {
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    if (self.guideInfoImageView) {
        [self addSubview:self.guideInfoImageView];
    }
    if (self.actionBtn) {
        [self addSubview:self.actionBtn];
        self.actionBtn.hidden = YES;
    }
}

- (void)resetUI {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    
    [self setupMaskLayer:info];
    [self setupImageView:info.guideImageLocationType];
    [self setupActionBtn];
}

//说明图片locaiton
- (void)setupImageView:(GuideInfoImageLocationType)locationType {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    UIImage *image = info.guideIntroImage;
    CGRect baseFrame = info.focusView.frame;
    [self getBaseFrameToWindow:info.focusView frame:&baseFrame];
    
    CGRect visualFrame = [self fetchfVisualViewFrame:baseFrame edgeInsets:info.insetEdge];
    CGRect imageViewFrame = self.guideInfoImageView.frame;
    imageViewFrame.size = image.size;
    self.guideInfoImageView.frame = imageViewFrame;
    [self.guideInfoImageView setImage:image];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat imageWidth = CGRectGetWidth(imageViewFrame);
    CGFloat imageHeight = CGRectGetHeight(imageViewFrame);
    
    switch (locationType) {
        case kGuideInfoImageLocationLeftTop:{

            imageViewFrame.origin.x = HorizontalOffset;
            imageViewFrame.origin.y = CGRectGetMaxY(visualFrame) + VerticalOffset;
        }
            break;
        case kGuideInfoImageLocationRightTop: {
            
            imageViewFrame.origin.x = width - imageWidth - HorizontalOffset;
            imageViewFrame.origin.y = CGRectGetMaxY(visualFrame) + VerticalOffset;
        }
            break;
        case kGuideInfoImageLocationCenterTop: {

            imageViewFrame.origin.x = ScreenWidth / 2 - imageWidth / 2;
            imageViewFrame.origin.y = CGRectGetMaxY(visualFrame) + VerticalOffset;
        }
            break;
        case kGuideInfoImageLocationLeftBottom: {

            imageViewFrame.origin.x = HorizontalOffset;
            imageViewFrame.origin.y = CGRectGetMinY(visualFrame) - VerticalOffset - imageHeight;
        }
            break;
        case kGuideInfoImageLocationRightBottom: {

            imageViewFrame.origin.x = width - imageWidth - HorizontalOffset;
            imageViewFrame.origin.y = CGRectGetMinY(visualFrame) - VerticalOffset - imageHeight;
        }
            break;
        case kGuideInfoImageLocationCenterBottom: {
            
            imageViewFrame.origin.x = ScreenWidth / 2 - imageWidth / 2;
            imageViewFrame.origin.y = CGRectGetMinY(visualFrame) - VerticalOffset - imageHeight;
        }
            break;
            
        default:
            break;
    }
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        self.guideInfoImageView.frame = imageViewFrame;
    }];
    [self setNeedsDisplay];
}

- (void)setupActionBtn {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    self.actionBtn.hidden = !info.buttonImage;
    if (info.buttonImage) {
        [self.actionBtn setImage:info.buttonImage forState:UIControlStateNormal];
        [self.actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.guideInfoImageView.mas_bottom).mas_equalTo(38);
            make.centerX.equalTo(self.guideInfoImageView.mas_centerX);
        }];
        [self.actionBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self setNeedsDisplay];
}

- (void)getBaseFrameToWindow:(UIView *)view frame:(CGRect *)frame{
    
    UIView *superView = view.superview;
    if (superView && ![superView.superview isKindOfClass:[UIWindow class]]) {
        frame->origin.x += CGRectGetMinX(superView.frame);
        frame->origin.y += CGRectGetMinY(superView.frame) + ([superView isKindOfClass:[UINavigationBar class]] ? CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) : 0);
        [self getBaseFrameToWindow:superView frame:frame];
    }
}

//可视的frame
- (CGRect)fetchfVisualViewFrame:(CGRect)baseFrame edgeInsets:(UIEdgeInsets)inset {
    CGRect visualFrame = CGRectZero;
    visualFrame.origin.x = baseFrame.origin.x + inset.left;
    visualFrame.origin.y = baseFrame.origin.y + inset.right;
    visualFrame.size.width = CGRectGetWidth(baseFrame) - (inset.left + inset.right);
    visualFrame.size.height = CGRectGetHeight(baseFrame) - (inset.top + inset.bottom);
    return visualFrame;
}

- (void)setupMaskLayer:(JWGuideInfo *)guideInfo {
    CGPathRef fromePath = self.maskLayer.path;
    self.maskLayer.frame = self.bounds;
    self.maskLayer.fillColor = [UIColor blackColor].CGColor;
    
    //可视路径
    CGRect baseFrame = guideInfo.focusView.frame;
    [self getBaseFrameToWindow:guideInfo.focusView frame:&baseFrame];
    
    CGRect visualFrame = [self fetchfVisualViewFrame:baseFrame edgeInsets:guideInfo.insetEdge];
    UIBezierPath *visualPath = [UIBezierPath bezierPathWithRoundedRect:visualFrame cornerRadius:guideInfo.cornRadius];
    UIBezierPath *toPath = [UIBezierPath bezierPathWithRect:self.frame];
    [toPath appendPath:visualPath];
    
    //遮罩路径
    self.maskLayer.path = toPath.CGPath;
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    self.layer.mask = self.maskLayer;
    //动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
    animation.duration = 0.2;
    animation.fromValue = (__bridge id)fromePath;
    animation.toValue = (__bridge id)toPath.CGPath;
    [self.maskLayer addAnimation:animation forKey:nil];
}

#pragma mark - public method
- (void)showGuideView:(NSArray<JWGuideInfo*> * _Nonnull)guidInfos actionHandle:(nullable ActionHandle)handle{
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    self.guideInfos = guidInfos;
    self.currentIndex = 0;
    [self resetUI];
    
    if (handle) {
        self.handle = handle;
    }
}

#pragma mark - private methods

#pragma mark - actions & events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.currentIndex >= self.guideInfos.count - 1) {
        [self removeFromSuperview];
        [UIApplication sharedApplication].statusBarHidden = NO;
    } else {
        self.currentIndex++;
        [self resetUI];
    }
}

- (void)action:(id)sender {
    if (self.handle) {
        self.handle(self.currentIndex);
    }
}

@end
