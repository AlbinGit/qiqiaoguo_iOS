//
//  MyCircleMainViewController.m
//  LongForTianjie
//
//  Created by cws on 16/4/20.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import "MyCircleMainViewController.h"
#import "BLUCircleDetailAsyncViewController.h"
#import "BLUApiManager+Circle.h"
#import "BLUCircle.h"
#import "BLUAlertView.h"
#import "BLUUserPostsViewController.h"
#import "BLUPostViewModel.h"
#import "BLUAppManager.h"

@interface MyCircleMainViewController ()
@property (nonatomic,strong) NSArray *myCircleVCs;
@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIView *selectLineView;

@end

@implementation MyCircleMainViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.title = @"我的巧妈帮";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[BLUThemeManager sharedTheme].navBackIndicatorImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBtnClick)];
    

    self.view.backgroundColor = [UIColor whiteColor];
    [self configHeadView];
    [self addSubVC];


    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

}

- (void)viewWillFirstAppear {
    [super viewWillFirstAppear];

}


- (void)addSubVC
{
    _myCircleVCs = [NSMutableArray array];
    NSArray *TitleItems = @[@"post", @"Participated", @"collections"];
    NSMutableArray *mar = [NSMutableArray array];
    for (NSString *str in TitleItems) {
        BLUPostViewModel *postViewModel = nil;
        if ([str isEqualToString:@"post"]) {
            postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForUser];
        }
        else if ([str isEqualToString:@"Participated"])
        {
            postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForParticipated];
        }
        else if ([str isEqualToString: @"collections"])
        {
            postViewModel = [[BLUPostViewModel alloc] initWithPostType:BLUPostTypeForCollection];
        }
        postViewModel.userID = [BLUAppManager sharedManager].currentUser.userID;
        BLUUserPostsViewController *vc = [[BLUUserPostsViewController alloc] initWithPostViewModel:postViewModel];
        if ([str isEqualToString:@"post"] || [str isEqualToString:@"collections"]) {
            vc.editAble = YES;
        }
        [mar addObject:vc];
        [self addChildViewController:vc];
    }
    _myCircleVCs = [NSArray arrayWithArray:mar];
    
    
    
    _subVCView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.width/8, self.view.frame.size.width * _myCircleVCs.count, self.view.frame.size.height - self.view.frame.size.width/8)];
    [self.view addSubview:_subVCView];
    for (int i = 0; i < 3; i++) {
        UIView *VCView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * i, 0, self.view.frame.size.width, self.view.frame.size.height - self.view.frame.size.width/8)];
        [_subVCView addSubview:VCView];
        UIViewController *vc = _myCircleVCs[i];
        [VCView addSubview:vc.view];
    }
}

- (void)configHeadView
{
    float btnW = (self.view.frame.size.width - 2)/3;
    float btnH = self.view.frame.size.width / 8;
    _headView = [[UIView alloc]init];
    NSArray *titleArr = @[@"我的帖子",@"我参与的",@"我的收藏"];
    _headView.frame = CGRectMake(0, 0, self.view.frame.size.width, btnH);
    for (int i = 0; i < titleArr.count; i++) {
        UIButton * btn = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        btn.titleColor = [UIColor grayColor];
        btn.title = titleArr[i];
        [btn addTarget:self action:@selector(selectAndChangeVC:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        if (i == 0) {
            btn.titleColor = BLUThemeMainColor;
            btn.frame = CGRectMake(i * btnW , 0, btnW, btnH);
            [_headView addSubview:btn];
        }
        else{
            btn.frame = CGRectMake(i * btnW + 1 , 0, btnW, btnH);
            [_headView addSubview:btn];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(i * btnW, 5, 1, btnH - 10)];
            lineView.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
            [_headView addSubview:lineView];
        }
    }
    UIView *bomLineView = [[UIView alloc]initWithFrame:CGRectMake(0, btnH -1, self.view.frame.size.width, 1)];
    bomLineView.backgroundColor = [UIColor colorFromHexString:@"c1c1c1"];
    [_headView addSubview:bomLineView];
    [self.view addSubview:_headView];
    
    UIView *selectLine = [[UIView alloc]initWithFrame:CGRectMake(0, btnH - 3, btnW, 3)];
    selectLine.backgroundColor = BLUThemeMainColor;
    _selectLineView = selectLine;
    [self.view addSubview:_selectLineView];
    
}

- (void)leftBtnClick
{
    self.subVCView.frame = CGRectMake(0, self.view.frame.size.height - self.view.frame.size.width/8, self.view.frame.size.width,  self.view.frame.size.height);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectAndChangeVC:(UIButton *)btn {
    
    for (UIButton *view in _headView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.titleColor = [UIColor grayColor];
        }
    }
    btn.titleColor = BLUThemeMainColor;
    NSInteger index = btn.tag;
    float btnH = self.view.frame.size.width / 8;
    float btnW = (self.view.frame.size.width - 2)/3;
    [UIView animateWithDuration:0.2 animations:^{
        _selectLineView.frame = CGRectMake(btnW * index, btnH - 3, btnW, 3);
        _subVCView.frame = CGRectMake( - index * self.view.frame.size.width,self.view.frame.size.width/8, self.view.frame.size.width * 3, self.view.frame.size.height - self.view.frame.size.width/8);
    }];
    
    
}

@end
