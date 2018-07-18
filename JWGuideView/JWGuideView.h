//
//  JWGuideView.h
//  JWGuideView
//
//  Created by JessieWu on 2018/7/18.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GuideInfoImageLocationType){
    kGuideInfoImageLocationLeftTop,
    kGuideInfoImageLocationRightTop,
    kGuideInfoImageLocationLeftBottom,
    kGuideInfoImageLocationRightBottom,
    kGuideInfoImageLocationCenterTop,
    kGuideInfoImageLocationCenterBottom
};

@interface JWGuideInfo: NSObject

@property (nonatomic, assign) UIEdgeInsets insetEdge;
@property (nonatomic, assign) CGFloat cornRadius;
@property (nonatomic, strong) UIImage *guideIntroImage;
@property (nonatomic, assign) GuideInfoImageLocationType guideImageLocationType;
@property (nonatomic, strong) UIView *focusView;

@end

@interface JWGuideView : UIView

- (void)showGuideView:(NSArray<JWGuideInfo*> *)guidInfos;

@end
