//
//  JWGuideView.m
//  JWGuideView
//
//  Created by JessieWu on 2018/7/18.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "JWGuideView.h"
#import <QuartzCore/QuartzCore.h>

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
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@property (nonatomic, copy) NSArray<JWGuideInfo *> *guideInfos;
@property (nonatomic, assign) NSUInteger currentIndex;


@end

@implementation JWGuideView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
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

#pragma mark - UI
- (void)setupUI {
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    if (self.guideInfoImageView) {
        [self addSubview:self.guideInfoImageView];
    }
}

- (void)resetUI {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    
    [self setupMaskLayer:info];
    [self setupImageView:info.guideImageLocationType];
}

//说明图片locaiton
- (void)setupImageView:(GuideInfoImageLocationType)locationType {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    UIImage *image = info.guideIntroImage;
    CGRect visualFrame = [self fetchfVisualViewFrame:info.focusView.frame edgeInsets:info.insetEdge];
    CGRect imageViewFrame = self.guideInfoImageView.frame;
    imageViewFrame.size = image.size;
    self.guideInfoImageView.frame = imageViewFrame;
    [self.guideInfoImageView setImage:image];
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat imageWidth = CGRectGetWidth(imageViewFrame);
    CGFloat imageHeight = CGRectGetHeight(imageViewFrame);
    
    switch (locationType) {
        case kGuideInfoImageLocationLeftTop:{

            imageViewFrame.origin.x = 20;
            imageViewFrame.origin.y = CGRectGetMaxY(visualFrame) + 15;
        }
            break;
        case kGuideInfoImageLocationRightTop: {
            
            imageViewFrame.origin.x = width - imageWidth - 20;
            imageViewFrame.origin.y = CGRectGetMaxY(visualFrame) + 15;
        }
            break;
        case kGuideInfoImageLocationCenterTop: {

            imageViewFrame.origin.x = CGRectGetMidX(visualFrame) - imageWidth / 2;
            imageViewFrame.origin.y = CGRectGetMaxY(visualFrame) + 15;
        }
            break;
        case kGuideInfoImageLocationLeftBottom: {

            imageViewFrame.origin.x = 20;
            imageViewFrame.origin.y = CGRectGetMinY(visualFrame) - 15 - imageHeight;
        }
            break;
        case kGuideInfoImageLocationRightBottom: {

            imageViewFrame.origin.x = width - imageWidth - 20;
            imageViewFrame.origin.y = CGRectGetMinY(visualFrame) - 15 - imageHeight;
        }
            break;
        case kGuideInfoImageLocationCenterBottom: {
            
            imageViewFrame.origin.x = CGRectGetMidX(visualFrame) - imageWidth / 2;
            imageViewFrame.origin.y = CGRectGetMinY(visualFrame) - 15 - imageHeight;
        }
            break;
            
        default:
            break;
    }
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        self.guideInfoImageView.frame = imageViewFrame;
    }];
    [self setNeedsDisplay];
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
    CGRect visualFrame = [self fetchfVisualViewFrame:guideInfo.focusView.frame edgeInsets:guideInfo.insetEdge];
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
- (void)showGuideView:(NSArray<JWGuideInfo*> *)guidInfos{
    [UIApplication sharedApplication].statusBarHidden = YES;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    self.guideInfos = guidInfos;
    self.currentIndex = 0;
    [self resetUI];
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

@end
