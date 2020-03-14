//
//  QGOrgAllCommentViewController.m
//  LongForTianjie
//
//  Created by Albin on 15/11/21.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import "QGOrgAllCommentViewController.h"
#import "QGOrgCommentHttpDownload.h"


#import "QGCommentInfoModel.h"
#import "QGStarRateView.h"
#import "QGCommentInfoModel.h"
#import "QGOrgNodataTableViewCell.h"
#import "QGOrgCellTypeModel.h"
#import "QGEducationMethod.h"
#import "QGCourseAllCommentHttpDownload.h"

@interface QGOrgAllCommentViewController ()

/**分数*/
@property (nonatomic, strong) UILabel * markLabel;
/**整体星级*/
@property (nonatomic, strong) QGStarRateView * totalStarView;
/**评价人数*/
@property (nonatomic, strong) UILabel * ratePersonLabel;

/**好评数据源*/
@property (nonatomic, strong) NSMutableArray * goodArray;
/**中评数据源*/
@property (nonatomic, strong) NSMutableArray * middleArray;
/**差评数据源*/
@property (nonatomic, strong) NSMutableArray * badArray;
/**存放tableView的数组*/
@property (nonatomic, strong) NSMutableArray *tableArray;
/**存放所有的数据的数组*/
@property (nonatomic, strong) NSMutableArray *dataArray;
/**级别:5好评,3中评,1差评*/
@property (nonatomic, copy) NSString * level;
/**好评页码*/
@property (nonatomic, assign) NSInteger gPage;
/**中评页码*/
@property (nonatomic, assign) NSInteger mPage;
/**差评页码*/
@property (nonatomic, assign) NSInteger bPage;

/**存储好评cell的高度*/
@property (nonatomic,strong) NSMutableArray *cellHeightGoodArray;
/**存储中评cell的高度*/
@property (nonatomic,strong) NSMutableArray *cellHeightMiddleArray;
/**存储差评cell的高度*/
@property (nonatomic,strong) NSMutableArray *cellHeightBadArray;

@end

@implementation QGOrgAllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createReturnButton];
    [self createNavTitle:@"全部评价"];
    [self p_initData];
    [self p_createUI];
    [[SAProgressHud sharedInstance]showWaitWithWindow];
    [self request:SARefreshPullDownType];
    // Do any additional setup after loading the view.
}

/**
 *  初始化数据源
 */
- (void)p_initData {
    _tableArray = [[NSMutableArray alloc]init];
    _dataArray = [[NSMutableArray alloc]init];
    _goodArray = [[NSMutableArray alloc]init];
    _middleArray = [[NSMutableArray alloc]init];
    _badArray = [[NSMutableArray alloc]init];
    _level = @"5";
    _gPage = 1;
    _mPage = 1;
    _bPage = 1;
    _cellHeightGoodArray = [[NSMutableArray alloc]init];
    _cellHeightMiddleArray = [[NSMutableArray alloc]init];
    _cellHeightBadArray = [NSMutableArray array];
}

/**
 *  创建UI
 */
- (void)p_createUI {
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navImageView.maxY, SCREEN_WIDTH, 132)];
    headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerView];
    // 分数
    _markLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 3, 35)];
    _markLabel.textAlignment = NSTextAlignmentCenter;
    _markLabel.font = FONT_CUSTOM(25);
    [headerView addSubview:_markLabel];
    // 整体星级
    _totalStarView = [[QGStarRateView alloc]initWithFrame:CGRectMake(_markLabel.center.x - 30, _markLabel.maxY, 60, 12) numberOfStars:5];
    _totalStarView.userInteractionEnabled = NO;
    [headerView addSubview:_totalStarView];
    // 评价人数
    _ratePersonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, _totalStarView.maxY + 5, _markLabel.width, 15)];
    _ratePersonLabel.font = FONT_CUSTOM(11);
    _ratePersonLabel.textAlignment = NSTextAlignmentCenter;
    _ratePersonLabel.textColor = COLOR(153, 153, 153, 1);
    [headerView addSubview:_ratePersonLabel];
    // 线
    UILabel * sLine = [[UILabel alloc]initWithFrame:CGRectMake(_markLabel.maxX, 10, 1, _ratePersonLabel.maxY)];
    sLine.backgroundColor = COLOR(245, 245, 245, 1);
    [headerView addSubview:sLine];
    UILabel * hLine = [[UILabel alloc]initWithFrame:CGRectMake(10, sLine.maxY + 10, SCREEN_WIDTH - 20, 1)];
    hLine.backgroundColor = sLine.backgroundColor;
    [headerView addSubview:hLine];
    
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT - headerView.maxY)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentOffset = CGPointMake(0, 0);
    _scrollView.scrollEnabled = NO;
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, SCREEN_HEIGHT - headerView.maxY);
    [self.view addSubview:_scrollView];
    NSArray * arr = @[@"描述相符",@"教学态度",@"响应速度"];
    NSArray * array = @[@"好评",@"中评",@"差评"];
    for (NSInteger i = 0; i < 3; i ++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(sLine.maxX, 20 + 20 * i, SCREEN_WIDTH / 4 - 10, 15)];
        label.font = FONT_CUSTOM(11);
        label.text = arr[i];
        label.textColor = COLOR(153, 153, 153, 1);
        label.textAlignment = NSTextAlignmentRight;
        [headerView addSubview:label];
        
        QGStarRateView * starView = [[QGStarRateView alloc]initWithFrame:CGRectMake(label.maxX + 10, label.minY + 3, 60, 12) numberOfStars:5];
        starView.userInteractionEnabled = NO;
        [headerView addSubview:starView];
        starView.tag = 520 + i;
        
        UILabel * scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(starView.maxX + 10, label.minY, SCREEN_WIDTH - starView.maxX - 20, 15)];
        scoreLabel.font = label.font;
        scoreLabel.textColor = label.textColor;
        [headerView addSubview:scoreLabel];
        scoreLabel.tag = 320 + i;
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(SCREEN_WIDTH / 3 * i, hLine.maxY, SCREEN_WIDTH / 3, 32);
        [btn setTitle:array[i] forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_CUSTOM(12);
        btn.tag = 200 + i;
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:PL_COLOR_orange forState:UIControlStateSelected];
        [headerView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(btn.center.x - 30, btn.maxY, 60, 2)];
        lineLabel.tag = 400 + i;
        [headerView addSubview:lineLabel];
        
        SASRefreshTableView * tableView = [[SASRefreshTableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - headerView.maxY) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tag = 600 + i;
        tableView.backgroundColor = APPBackgroundColor;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableArray addObject:tableView];
        [_scrollView addSubview:tableView];
        PL_CODE_WEAK(ws)
        [tableView addRefreshHeader:^(SASRefreshTableView *refreshTableView) {
            [ws request:SARefreshPullDownType];
        }];
        [tableView addRefreshFooter:^(SASRefreshTableView *refreshTableView) {
            [ws request:SARefreshPullUpType];
        }];
        if (i == 0) {
            btn.selected = YES;
            lineLabel.backgroundColor = PL_COLOR_orange;
        }
    }
}

/**
 *  切换好中差评
 *
 *  @param btn tag
 */
- (void)btnClick:(UIButton *)btn {
    for (NSInteger i = 0; i < 3; i ++) {
        UIButton * textBtn = (UIButton *)[self.view viewWithTag:i + 200];
        UILabel * tlabel = (UILabel *)[self.view viewWithTag:i + 400];
        if (i == btn.tag - 200) {
            _scrollView.contentOffset = CGPointMake(SCREEN_WIDTH * i, 0);
            textBtn.selected = YES;
            tlabel.backgroundColor = PL_COLOR_orange;
            _level = [NSString stringWithFormat:@"%d",5 - 2 * i];
            if (![self isContentsObject:[NSString stringWithFormat:@"%d",i]])
            {
                [[SAProgressHud sharedInstance]showWaitWithWindow];
                [self request:SARefreshPullDownType];
            }
        }
        else {
            textBtn.selected = NO;
            tlabel.backgroundColor = [UIColor clearColor];
        }
    }
}

/**
 *  判断数组中是否包含某字符串
 *
 *  @param str 字符串
 *
 *  @return 是否
 */
- (BOOL)isContentsObject:(NSString *)str
{
    BOOL b = NO;
    for (NSString *object in _dataArray) {
        if ([object isEqualToString:str]) {
            b = YES;
        }
    }
    return b;
}

/**
 *  网络请求
 *
 *  @param type 请求类型
 */
- (void)request:(SARefreshType)type {
    if (_type == QGOrgAllCommentViewControllerType)
    {
        QGOrgCommentHttpDownload * hd = [[QGOrgCommentHttpDownload alloc]init];
        hd.org_id = _org_id;
        hd.limit = @"10";
        hd.level = _level;
        if ([_level integerValue] == 5) {
            if (type == SARefreshPullDownType)
                hd.page = @"1";
            else
                hd.page = [NSString stringWithFormat:@"%ld",(long)self.gPage];
        }
        else if ([_level integerValue] == 3) {
            if (type == SARefreshPullDownType)
                hd.page = @"1";
            else
                hd.page = [NSString stringWithFormat:@"%ld",(long)self.mPage];
        }
        else {
            if (type == SARefreshPullDownType)
                hd.page = @"1";
            else
                hd.page = [NSString stringWithFormat:@"%ld",(long)self.bPage];
        }
//        [[QGRequest sharedInstance]startRequest:hd success:^(id obj) {
//            PLLogData(obj, @"--------机构全部评价列表页-------");
//            [[SAProgressHud sharedInstance]removeHudFromSuperView];
//            if ([hd.page integerValue] == 1) {
//                QGCommentInfoModel * model = [QGCommentInfoModel objectWithKeyValues:obj[@"content"][@"info"]];
//                NSArray * arr = @[model.describe_avg,model.manner_avg,model.speed_avg];
//                NSArray * btnArr = @[[NSString stringWithFormat:@"好评（%@）",model.good_count],[NSString stringWithFormat:@"中评（%@）",model.mid_count],[NSString stringWithFormat:@"差评（%@）",model.bad_count]];
//                for (NSInteger i = 0; i < 3; i ++) {
//                    QGStarRateView * starView = (QGStarRateView *)[self.view viewWithTag:520 + i];
//                    starView.score = [arr[i] floatValue] / 5;
//                    UILabel * scoreLabel = (UILabel *)[self.view viewWithTag:320 + i];
//                    scoreLabel.text = [NSString stringWithFormat:@"%@分",arr[i]];
//                    UIButton * btn = (UIButton *)[self.view viewWithTag:200 + i];
//                    [btn setTitle:btnArr[i] forState:UIControlStateNormal];
//                    [btn setTitle:btnArr[i] forState:UIControlStateSelected];
//                }
//                NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@分",model.comment_avg]];
//                [textStr addAttribute:NSForegroundColorAttributeName value:COLOR(153, 153, 153, 1) range:NSMakeRange(textStr.length - 1, 1)];
//                [textStr addAttribute:NSFontAttributeName value:FONT_CUSTOM(11) range:NSMakeRange(textStr.length - 1, 1)];
//                _markLabel.attributedText = textStr;
//                _ratePersonLabel.text = [NSString stringWithFormat:@"共%@人评价",model.comment_count];
//                _totalStarView.score = [model.comment_avg floatValue] / 5;
//            }
//            QGOrgCellTypeModel *typeModel = [[QGOrgCellTypeModel alloc]init];
//            typeModel.type = QGOrgCellNoDataType;
//            typeModel.imageStr = @"icon_no_evaluation";
//            typeModel.value = @"暂无评论";
//            
//            if ([_level integerValue] == 5) {
//                if (type == SARefreshPullDownType) {
//                    self.gPage = 1;
//                    self.gPage ++;
//                    [_goodArray removeAllObjects];
//                    [_dataArray removeObject:@"0"];
//                    [_dataArray addObject:@"0"];
//                    [_cellHeightGoodArray removeAllObjects];
//                }
//                else
//                    self.gPage ++;
//                if (self.gPage > [obj[@"content"][@"pageCount"] integerValue])
//                    [_tableArray[0] hiddenFooterView];
//                else
//                    [_tableArray[0] showFooterView];
//               
//                
//                if (_goodArray.count == 0)
//                {
//                    [_goodArray addObject:typeModel];
//                }
//                [_tableArray[0] reloadData];
//                [_tableArray[0] endRrefresh];
//            }
//            else if ([_level integerValue] == 3) {
//                if (type == SARefreshPullDownType) {
//                    self.mPage = 1;
//                    self.mPage ++;
//                    [_middleArray removeAllObjects];
//                    [_dataArray removeObject:@"1"];
//                    [_dataArray addObject:@"1"];
//                    [_cellHeightMiddleArray removeAllObjects];
//                }
//                else
//                    self.mPage ++;
//                if (self.mPage > [obj[@"content"][@"pageCount"] integerValue])
//                    [_tableArray[1] hiddenFooterView];
//               
//                if (_middleArray.count == 0)
//                {
//                    [_middleArray addObject:typeModel];
//                }
//                [_tableArray[1] reloadData];
//                [_tableArray[1] endRrefresh];
//            }
//            else {
//                if (type == SARefreshPullDownType) {
//                    self.bPage = 1;
//                    self.bPage ++;
//                    [_badArray removeAllObjects];
//                    [_dataArray removeObject:@"2"];
//                    [_dataArray addObject:@"2"];
//                    [_cellHeightBadArray removeAllObjects];
//                }
//                else
//                    self.bPage ++;
//                if (self.bPage > [obj[@"content"][@"pageCount"] integerValue])
//                    [_tableArray[2] hiddenFooterView];
//                else
//                    [_tableArray[2] showFooterView];
//               
//                if (_badArray.count == 0)
//                {
//                    [_badArray addObject:typeModel];
//                }
//                [_tableArray[2] reloadData];
//                [_tableArray[2] endRrefresh];
//            }
//        } fail:^(NSString *errorInfo) {
//            [[SAProgressHud sharedInstance]removeHudFromSuperView];
//            [[SAProgressHud sharedInstance] showFailWithViewWindow:errorInfo];
//        }];

    }
    else
    {
        QGCourseAllCommentHttpDownload * hd = [[QGCourseAllCommentHttpDownload alloc]init];
        hd.course_id = _course_id;
        hd.limit = @"10";
        hd.level = _level;
        if ([_level integerValue] == 5) {
            if (type == SARefreshPullDownType)
                hd.page = @"1";
            else
                hd.page = [NSString stringWithFormat:@"%ld",(long)self.gPage];
        }
        else if ([_level integerValue] == 3) {
            if (type == SARefreshPullDownType)
                hd.page = @"1";
            else
                hd.page = [NSString stringWithFormat:@"%ld",(long)self.mPage];
        }
        else {
            if (type == SARefreshPullDownType)
                hd.page = @"1";
            else
                hd.page = [NSString stringWithFormat:@"%ld",(long)self.bPage];
        }
//        [[QGRequest sharedInstance]startRequest:hd success:^(id obj) {
//            PLLogData(obj, @"--------机构全部评价列表页-------");
//            [[SAProgressHud sharedInstance]removeHudFromSuperView];
//            if ([hd.page integerValue] == 1) {
//                QGCommentInfoModel * model = [QGCommentInfoModel objectWithKeyValues:obj[@"content"][@"info"]];
//                NSArray * arr = @[model.describe_avg,model.manner_avg,model.speed_avg];
//                NSArray * btnArr = @[[NSString stringWithFormat:@"好评（%@）",model.good_count],[NSString stringWithFormat:@"中评（%@）",model.mid_count],[NSString stringWithFormat:@"差评（%@）",model.bad_count]];
//                for (NSInteger i = 0; i < 3; i ++) {
//                    QGStarRateView * starView = (QGStarRateView *)[self.view viewWithTag:520 + i];
//                    starView.score = [arr[i] floatValue] / 5;
//                    UILabel * scoreLabel = (UILabel *)[self.view viewWithTag:320 + i];
//                    scoreLabel.text = [NSString stringWithFormat:@"%@分",arr[i]];
//                    UIButton * btn = (UIButton *)[self.view viewWithTag:200 + i];
//                    [btn setTitle:btnArr[i] forState:UIControlStateNormal];
//                    [btn setTitle:btnArr[i] forState:UIControlStateSelected];
//                }
//                NSMutableAttributedString *textStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@分",model.comment_avg]];
//                [textStr addAttribute:NSForegroundColorAttributeName value:COLOR(153, 153, 153, 1) range:NSMakeRange(textStr.length - 1, 1)];
//                [textStr addAttribute:NSFontAttributeName value:FONT_CUSTOM(11) range:NSMakeRange(textStr.length - 1, 1)];
//                _markLabel.attributedText = textStr;
//                _ratePersonLabel.text = [NSString stringWithFormat:@"共%@人评价",model.comment_count];
//                _totalStarView.score = [model.comment_avg floatValue] / 5;
//            }
//            QGOrgCellTypeModel *typeModel = [[QGOrgCellTypeModel alloc]init];
//            typeModel.type = QGOrgCellNoDataType;
//            typeModel.imageStr = @"icon_no_evaluation";
//            typeModel.value = @"暂无评论";
//            
//            if ([_level integerValue] == 5) {
//                if (type == SARefreshPullDownType) {
//                    self.gPage = 1;
//                    self.gPage ++;
//                    [_goodArray removeAllObjects];
//                    [_dataArray removeObject:@"0"];
//                    [_dataArray addObject:@"0"];
//                    [_cellHeightGoodArray removeAllObjects];
//                }
//                else
//                    self.gPage ++;
//                if (self.gPage > [obj[@"content"][@"pageCount"] integerValue])
//                    [_tableArray[0] hiddenFooterView];
//                else
//                    [_tableArray[0] showFooterView];
//           
//                
//                if (_goodArray.count == 0)
//                {
//                    [_goodArray addObject:typeModel];
//                }
//                [_tableArray[0] reloadData];
//                [_tableArray[0] endRrefresh];
//            }
//            else if ([_level integerValue] == 3) {
//                if (type == SARefreshPullDownType) {
//                    self.mPage = 1;
//                    self.mPage ++;
//                    [_middleArray removeAllObjects];
//                    [_dataArray removeObject:@"1"];
//                    [_dataArray addObject:@"1"];
//                    [_cellHeightMiddleArray removeAllObjects];
//                }
//                else
//                    self.mPage ++;
//                if (self.mPage > [obj[@"content"][@"pageCount"] integerValue])
//                    [_tableArray[1] hiddenFooterView];
//                else
//                    [_tableArray[1] showFooterView];
//        
//                               if (_middleArray.count == 0)
//                {
//                    [_middleArray addObject:typeModel];
//                }
//                [_tableArray[1] reloadData];
//                [_tableArray[1] endRrefresh];
//            }
//            else {
//                if (type == SARefreshPullDownType) {
//                    self.bPage = 1;
//                    self.bPage ++;
//                    [_badArray removeAllObjects];
//                    [_dataArray removeObject:@"2"];
//                    [_dataArray addObject:@"2"];
//                    [_cellHeightBadArray removeAllObjects];
//                }
//                else
//                    self.bPage ++;
//                if (self.bPage > [obj[@"content"][@"pageCount"] integerValue])
//                    [_tableArray[2] hiddenFooterView];
//                else
//                    [_tableArray[2] showFooterView];
//            
//                if (_badArray.count == 0)
//                {
//                    [_badArray addObject:typeModel];
//                }
//                [_tableArray[2] reloadData];
//                [_tableArray[2] endRrefresh];
//            }
//        } fail:^(NSString *errorInfo) {
//            [[SAProgressHud sharedInstance]removeHudFromSuperView];
//            [[SAProgressHud sharedInstance] showFailWithViewWindow:errorInfo];
//        }];
    }
}
#pragma mark ----- tableDelegate -----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 600)
        return _goodArray.count;
    else if (tableView.tag == 601)
        return _middleArray.count;
    else
        return _badArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (tableView.tag == 600)
        array = _goodArray;
    else if (tableView.tag == 601)
        array = _middleArray;
    else
        array = _badArray;

        PL_CELL_CREATEMETHOD(QGOrgNodataTableViewCell, @"noData")
        QGOrgCellTypeModel * typeModel = array[indexPath.row];
        cell.typeModel = typeModel;
        cell.backgroundColor = APPBackgroundColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *array = [[NSMutableArray alloc]init];
    if (tableView.tag == 600)
        array = _cellHeightGoodArray;
    else if (tableView.tag == 601)
        array = _cellHeightMiddleArray;
    else
        array = _cellHeightBadArray;
    if (array.count == 0)
    {
        return 95;
    }
    else
    {
//        QGCourseCommentTableViewCell *cell = (QGCourseCommentTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
//        return cell.cellHeight;
        return [array[indexPath.row] floatValue];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)dealloc {
    for (SASRefreshTableView *tableView in _tableArray) {
        [tableView refreshFree];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
