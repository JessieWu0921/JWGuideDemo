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
    [self addSubview:self.guideInfoImageView];
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
}

- (void)resetUI {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];
    
    [self.guideInfoImageView removeFromSuperview];
    self.guideInfoImageView = [[UIImageView alloc] initWithImage:info.guideIntroImage];
    [self addSubview:self.guideInfoImageView];
    
    [self setupMaskLayer:info];
    [self setupImageView:info.guideImageLocationType];
}

//说明图片locaiton
- (void)setupImageView:(GuideInfoImageLocationType)locationType {
    JWGuideInfo *info = (JWGuideInfo *)self.guideInfos[self.currentIndex];

    switch (locationType) {
        case kGuideInfoImageLocationLeftTop:{
            [self.guideInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(info.focusView.mas_bottom).mas_offset(15 - info.insetEdge.bottom);
                make.left.equalTo(self).mas_offset(20);
            }];
        }
            break;
        case kGuideInfoImageLocationRightTop: {
            
            [self.guideInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(info.focusView.mas_bottom).mas_offset(15 - info.insetEdge.bottom);
                make.right.equalTo(self).mas_offset(-20);
            }];
        }
            break;
        case kGuideInfoImageLocationCenterTop: {
            [self.guideInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(info.focusView.mas_top).mas_offset(15 - info.insetEdge.top);
                make.centerX.equalTo(self.mas_centerX);
            }];
        }
            break;
        case kGuideInfoImageLocationLeftBottom: {
            [self.guideInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(info.focusView.mas_top).mas_offset(-15 + info.insetEdge.top);
                make.left.equalTo(self).mas_offset(20);
            }];
        }
            break;
        case kGuideInfoImageLocationRightBottom: {
            [self.guideInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(info.focusView.mas_top).mas_offset(-15 + info.insetEdge.top);
                make.right.equalTo(self).mas_offset(-20);
            }];
        }
            break;
        case kGuideInfoImageLocationCenterBottom: {
            [self.guideInfoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(info.focusView.mas_top).mas_offset(-15 + info.insetEdge.top);
                make.centerX.equalTo(self.mas_centerX);
            }];
        }
            break;
            
        default:
            break;
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
