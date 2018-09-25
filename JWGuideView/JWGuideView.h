//
//  JWGuideView.h
//  JWGuideView
//
//  Created by JessieWu on 2018/7/18.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

/***  新手引导页面  ***/

/***
 1.考虑到箭头可能会有各种形式，且说明文字外框的样式，此引导页面仅用于guide intro是图片（即将箭头和说明文字合并的图片）
 
 2.考虑到焦点view的自定义，图层结构等问题，可以传焦点view的frame，而不需要传焦点view（如果两个都传的话h，会优先处理焦点view）
 
 3.组件会对焦点view做处理，所以只需要传入焦点view即可，测试过基本上没有问题（有个例再做处理）
 
 4.对于焦点view的location问题，需要注意的是：
 1）centertop：默认说明图片在焦点view中下方；
 2）centerbottom:默认说明图片在焦点view中上方；
 
 ***/

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuideInfoImageLocationType){
    kGuideInfoImageLocationLeftTop,
    kGuideInfoImageLocationRightTop,
    kGuideInfoImageLocationLeftBottom,
    kGuideInfoImageLocationRightBottom,
    kGuideInfoImageLocationCenterTop,
    kGuideInfoImageLocationCenterBottom
};

typedef void(^ActionHandle)(NSInteger guideIndex);

@interface JWGuideInfo: NSObject

@property (nonatomic, assign) UIEdgeInsets insetEdge;
//保留字段 暂时未做处理
@property (nonatomic, assign) CGRect baseFrame;
@property (nonatomic, assign) CGFloat cornRadius;
@property (nonatomic, assign) CGFloat buttonOffset;
//图片与焦点view的offsetY
@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, strong) UIImage *guideIntroImage;
@property (nonatomic, assign) GuideInfoImageLocationType guideImageLocationType;
@property (nonatomic, strong) UIView *focusView;
//用于自定义navigationbar 上的焦点view
@property (nonatomic, assign, getter=isNavigtionBar) BOOL navBar;

@property (nonatomic, strong) UIImage *buttonImage;

@end

@interface JWGuideView : UIView

- (void)showGuideView:(NSArray<JWGuideInfo*> * _Nonnull)guidInfos actionHandle:(nullable ActionHandle)handle;

@end
