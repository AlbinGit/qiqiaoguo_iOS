//
//  QGOrgSubbranchViewController.m
//  LongForTianjie
//
//  Created by Albin on 16/1/27.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import "QGOrgSubbranchViewController.h"
#import "QGOrgSubbranchTableViewCell.h"
#import "QGOrgSubbranchModel.h"
#import "QGOrgSubbranchHttpDownload.h"
#import "QGOrgSubbranchDetailView.h"

@interface QGOrgSubbranchViewController ()

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end

@implementation QGOrgSubbranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self p_createUI];
    [self p_requestMethod];
    // Do any additional setup after loading the view.
}

- (void)p_createUI
{
    _dataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - self.navImageView.maxY) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
}

- (void)p_requestMethod
{
    QGOrgSubbranchHttpDownload *download = [[QGOrgSubbranchHttpDownload alloc]init];
    download.org_id = self.orgId;
    [[SAProgressHud sharedInstance]showWaitWithWindow];
//    [[QGRequest sharedInstance]startRequest:download success:^(id obj) {
//        PLLogData(obj, @"连锁分店");
//        [[SAProgressHud sharedInstance]removeGifLoadingViewFromSuperView];
//        
//        NSArray *array = [QGOrgSubbranchModel objectArrayWithKeyValuesArray:obj[@"content"][@"list"]];
//        [_dataArray addObjectsFromArray:array];
//        [_tableView reloadData];
//        
//        
//    } fail:^(NSString *errorInfo) {
//        [[SAProgressHud sharedInstance]removeGifLoadingViewFromSuperView];
//        [[SAProgressHud sharedInstance]showFailWithViewWindow:errorInfo];
//    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cell";
    QGOrgSubbranchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell)
    {
        cell = [[QGOrgSubbranchTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    QGOrgSubbranchModel *subModel = _dataArray[indexPath.row];
    cell.subModel = subModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    QGOrgSubbranchModel *subModel = _dataArray[indexPath.row];
    QGOrgSubbranchDetailView *detailView = [[QGOrgSubbranchDetailView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview:detailView];
    [detailView reloadData:subModel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
