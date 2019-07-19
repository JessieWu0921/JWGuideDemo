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
 
 5.添加焦点图片（优先考虑：若focusImage不为nil，则优先展示焦点图片，而不是画焦点轨迹）
 主要为了防止可能有些在新手引导的时候有弹窗，会在轨迹上覆盖一层，焦点图片也可以用insetEdge控制尺寸
 用法一样：
 JWGuideInfo *guideInfo = [[JWGuideInfo alloc] init];
 guideInfo.focusView = self.toolBar.fullScreenButton;
 guideInfo.focusImage = [UIImage imageNamed:@"guide_fullscreen"];
 guideInfo.insetEdge = UIEdgeInsetsMake(8, 6, 8, 6);
 guideInfo.guideIntroImage = [UIImage imageNamed:@"img_guidepage"];
 guideInfo.guideImageLocationType = kGuideInfoImageLocationRightBottom;
 [guideView showGuideView:@[guideInfo]];
 
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

//焦点view相对的可视化距离
@property (nonatomic, assign) UIEdgeInsets insetEdge;
//baseframe是相对于windwo的rect(保留字段)
@property (nonatomic, assign) CGRect baseFrame;
//焦点view轨迹的圆角
@property (nonatomic, assign) CGFloat cornRadius;
//说明图片
@property (nonatomic, strong) UIImage * _Nullable guideIntroImage;
//焦点view的相对位置
@property (nonatomic, assign) GuideInfoImageLocationType guideImageLocationType;
//焦点view
@property (nonatomic, strong) UIView * _Nullable focusView;
//焦点图片
@property (nonatomic, strong) UIImage * _Nullable focusImage;

@property (nonatomic, assign) CGFloat buttonOffset;
//图片与焦点view的offsetY
@property (nonatomic, assign) CGFloat verticalOffset;
//用于自定义navigationbar 上的焦点view
@property (nonatomic, assign, getter=isNavigtionBar) BOOL isCustomizeNavBar;

@property (nonatomic, strong) UIImage * _Nullable buttonImage;

@end

@interface JWGuideView : UIView

- (void)showGuideView:(NSArray<JWGuideInfo*> * _Nonnull)guidInfos actionHandle:(nullable ActionHandle)handle;

@end
