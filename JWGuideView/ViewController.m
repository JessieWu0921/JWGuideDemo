//
//  ViewController.m
//  JWGuideView
//
//  Created by JessieWu on 2018/7/18.
//  Copyright © 2018年 JessieWu. All rights reserved.
//

#import "ViewController.h"
#import "JWGuideView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;
@property (weak, nonatomic) IBOutlet UIView *view5;
@property (weak, nonatomic) IBOutlet UIView *view6;
@property (weak, nonatomic) IBOutlet UIView *view7;
@property (weak, nonatomic) IBOutlet UIView *view8;
@property (weak, nonatomic) IBOutlet UIView *view9;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view3.layer.masksToBounds = YES;
    self.view3.layer.cornerRadius = 19;
    [self showGuideView];
}

#pragma mark - methods
- (void)showGuideView {
    JWGuideInfo *m1 = [JWGuideInfo new];
    m1.focusView = self.view1;
    m1.guideImageLocationType = kGuideInfoImageLocationLeftTop;
    m1.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    JWGuideInfo *m2 = [JWGuideInfo new];
    m2.focusView = self.view2;
    m2.guideImageLocationType = kGuideInfoImageLocationCenterTop;
    m2.guideIntroImage = [UIImage imageNamed:@"mine_guide_content"];
    m2.buttonImage = [UIImage imageNamed:@"mine_guide_btn_know"];
    JWGuideInfo *m3 = [JWGuideInfo new];
    m3.focusView = self.view3;
    m3.guideImageLocationType = kGuideInfoImageLocationRightTop;
    m3.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    m3.buttonImage = [UIImage imageNamed:@"mine_guide_btn_know"];
    JWGuideInfo *m4 = [JWGuideInfo new];
    m4.focusView = self.view4;
    m4.guideImageLocationType = kGuideInfoImageLocationLeftBottom;
    m4.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    JWGuideInfo *m5 = [JWGuideInfo new];
    m5.focusView = self.view5;
    m5.guideImageLocationType = kGuideInfoImageLocationRightBottom;
    m5.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    JWGuideInfo *m6 = [JWGuideInfo new];
    m6.focusView = self.view6;
    m6.guideImageLocationType = kGuideInfoImageLocationCenterBottom;
    m6.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    JWGuideInfo *m7 = [JWGuideInfo new];
    m7.focusView = self.view7;
    m7.guideImageLocationType = kGuideInfoImageLocationCenterTop;
    m7.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    JWGuideInfo *m8 = [JWGuideInfo new];
    m8.focusView = self.view8;
    m8.guideImageLocationType = kGuideInfoImageLocationLeftTop;
    m8.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    JWGuideInfo *m9 = [JWGuideInfo new];
    m9.focusView = self.view9;
    m9.cornRadius = 5.0f;
    m9.insetEdge = UIEdgeInsetsMake(-4, -4, -4, -4);
    m9.guideImageLocationType = kGuideInfoImageLocationLeftTop;
    m9.guideIntroImage = [UIImage imageNamed:@"study_guide"];
    NSMutableArray *datas = [NSMutableArray new];
    [datas addObject:m1];
    [datas addObject:m2];
    [datas addObject:m3];
    [datas addObject:m4];
    [datas addObject:m5];
    [datas addObject:m6];
    [datas addObject:m7];
    [datas addObject:m8];
    [datas addObject:m9];
    
    JWGuideView *guideView = [[JWGuideView alloc] init];
    [guideView showGuideView:datas actionHandle:^(NSInteger guideIndex) {
        NSLog(@"now clicked %zi guideView.", guideIndex);
    }];
}

- (IBAction)clickedBtn:(id)sender {
}
@end
