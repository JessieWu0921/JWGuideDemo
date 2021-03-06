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
        self.imageOffset = UIOffsetMake(20, 15);
        self.cornRadius = 20.0f;
        self.buttonOffset = 30.0f;
        self.baseFrame = CGRectZero;
        self.verticalOffset = VerticalOffset;
    }
    return self;
}

@end

@interface JWGuideView()

@property (nonatomic, strong) UIImageView *guideInfoImageView;
@property (nonatomic, strong) UIImageView *focusImageView;
@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, copy) NSArray<JWGuideInfo *> *guideInfos;
@property (nonatomic, assign) NSUInteger currentIndex;

@property (nonatomic, assign) CGRect visualFrame;

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

- (UIImageView *)focusImageView {
    if (!_focusImageView) {
        _focusImageView = [[UIImageView alloc] init];
    }
    return _focusImageView;
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
    if (self.focusImageView) {
        [self addSubview:self.focusImageView];
        self.focusImageView.hidden = YES;
    }
    if (self.actionBtn) {
        [self addSubview:self.actionBtn];
        self.actionBtn.hidden = YES;
    }
}

- (void)resetUI {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    
    CGRect baseFrame = info.focusView ? info.focusView.frame : info.baseFrame;
    baseFrame.origin.y += info.isNavigtionBar ? CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) : 0.0;
    [self getBaseFrameToWindow:info.focusView frame:&baseFrame];
    self.visualFrame = [self fetchfVisualViewFrame:baseFrame edgeInsets:info.insetEdge];
    
    ///优先显示图片
    if (info.focusImage) {
        self.focusImageView.hidden = NO;
        [self setupFocusImage:info];
    } else {
        self.focusImageView.hidden = YES;
        [self setupMaskLayer:info];
    }
    
    [self setupImageView:info.guideImageLocationType offset:info.imageOffset];
}

- (void)setupFocusImage:(JWGuideInfo *)info {
    self.focusImageView.hidden = NO;
    CGRect baseFrame = info.focusView.frame;
    baseFrame.origin.y += info.isCustomizeNavBar ? CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) : 0.0;
    [self getBaseFrameToWindow:info.focusView frame:&baseFrame];
    CGRect visualFrame = [self fetchfVisualViewFrame:baseFrame edgeInsets:info.insetEdge];
    self.focusImageView.frame = visualFrame;
    self.focusImageView.image = info.focusImage;
}

//说明图片locaiton
- (void)setupImageView:(GuideInfoImageLocationType)locationType offset:(UIOffset)offset {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    
    UIImage *image = info.guideIntroImage;
    CGRect imageViewFrame = self.guideInfoImageView.frame;
    imageViewFrame.size = image.size;
    self.guideInfoImageView.frame = imageViewFrame;
    [self.guideInfoImageView setImage:image];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat imageWidth = CGRectGetWidth(imageViewFrame);
    CGFloat imageHeight = CGRectGetHeight(imageViewFrame);
    
    switch (locationType) {
        case kGuideInfoImageLocationLeftTop:{

            imageViewFrame.origin.x = offset.horizontal;
            imageViewFrame.origin.y = CGRectGetMaxY(_visualFrame) + offset.vertical;
        }
            break;
        case kGuideInfoImageLocationRightTop: {
            
            imageViewFrame.origin.x = width - imageWidth - offset.horizontal;
            imageViewFrame.origin.y = CGRectGetMaxY(_visualFrame) + offset.vertical;
        }
            break;
        case kGuideInfoImageLocationCenterTop: {

            imageViewFrame.origin.x = CGRectGetMidX(_visualFrame) - imageWidth / 2;//ScreenWidth / 2 - imageWidth / 2;
            imageViewFrame.origin.y = CGRectGetMaxY(_visualFrame) + offset.vertical;
        }
            break;
        case kGuideInfoImageLocationLeftBottom: {

            imageViewFrame.origin.x = offset.horizontal;
            imageViewFrame.origin.y = CGRectGetMinY(_visualFrame) - offset.vertical - imageHeight;
        }
            break;
        case kGuideInfoImageLocationRightBottom: {

            imageViewFrame.origin.x = CGRectGetMaxX(_visualFrame) - imageWidth + offset.horizontal;
            imageViewFrame.origin.y = CGRectGetMinY(_visualFrame) - offset.vertical - imageHeight;
        }
            break;
        case kGuideInfoImageLocationCenterBottom: {
            
            imageViewFrame.origin.x = CGRectGetMidX(_visualFrame) - imageWidth / 2;// ScreenWidth / 2 - imageWidth / 2;
            imageViewFrame.origin.y = CGRectGetMinY(_visualFrame) - offset.vertical - imageHeight;
        }
            break;
            
        default:
            break;
    }
    
    CGRect buttonFrame = [self setupActionBtn:imageViewFrame];
    //动画
    [UIView animateWithDuration:0.3 animations:^{
        self.guideInfoImageView.frame = imageViewFrame;
        self.actionBtn.frame = buttonFrame;
    }];
    [self setNeedsDisplay];
}

- (CGRect)setupActionBtn:(CGRect)imageFrame {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    self.actionBtn.hidden = !info.buttonImage;
    if (info.buttonImage) {
        [self.actionBtn setImage:info.buttonImage forState:UIControlStateNormal];
        
        [self.actionBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        
        CGRect buttonFrame = self.actionBtn.frame;
        buttonFrame.size = info.buttonImage.size;
        buttonFrame.origin.x = CGRectGetMinX(imageFrame) + CGRectGetWidth(imageFrame) / 2 - info.buttonImage.size.width / 2;
        buttonFrame.origin.y = CGRectGetMaxY(imageFrame) + info.buttonOffset;
        
        return buttonFrame;
    }
    return CGRectZero;
}

- (void)getBaseFrameToWindow:(UIView *)view frame:(CGRect *)frame{
    
    UIView *superView = view.superview;
    if (superView && ![superView.superview isKindOfClass:[UIWindow class]]) { //
        frame->origin.x += CGRectGetMinX(superView.frame);
        frame->origin.y += CGRectGetMinY(superView.frame);
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
    UIBezierPath *visualPath = [UIBezierPath bezierPathWithRoundedRect:_visualFrame cornerRadius:guideInfo.cornRadius];
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

- (void)nextGuideView {
    [self dismissGuideView];
}

- (void)removeAllGuide {
    [self removeFromSuperview];
}

#pragma mark - private methods
- (void)dismissGuideView {
    if (self.currentIndex >= self.guideInfos.count - 1) {
        [self removeFromSuperview];
    } else {
        self.currentIndex++;
        [self resetUI];
    }
}

#pragma mark - actions & events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.currentIndex >= self.guideInfos.count - 1) {
        [self removeFromSuperview];
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
