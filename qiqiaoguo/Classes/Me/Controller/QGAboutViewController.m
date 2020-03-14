//
//  QGAboutViewController.m
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//

#import "QGAboutViewController.h"
#import "QGTableView.h"
#import "QGSettingCell.h"
#import "QGAboutCell.h"
#import "BLUWebViewController.h"

typedef NS_ENUM(NSInteger, TableViewRowTypes) {
    TableViewRowTypeAbout = 0,
    TableViewRowTypeEULA,
    TableViewRowTypeMobile,
};

@interface QGAboutViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) QGTableView *tableView;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIWebView *callWebview;

@end

@implementation QGAboutViewController
- (instancetype)init {
    if (self = [super init]) {
        self.title = NSLocalizedString(@"about.title", @"About");
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BLUThemeSubTintBackgroundColor;
    
    _tableView = [self makeTableView];
    
    _rightLabel = [UILabel new];
    _rightLabel.numberOfLines = 0;
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    
    
    NSString *cnString = @"七巧国网络  版权所有\n";
    NSString *enString = @"Copyright © 2016-2020 qiqiaoland All Rights Reserved.";
    
    NSMutableAttributedString *mutableAttributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", cnString, enString]];
    [mutableAttributeString addAttribute:NSFontAttributeName value:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall) range:[mutableAttributeString.string rangeOfString:cnString]];
    [mutableAttributeString addAttribute:NSFontAttributeName value:BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall) range:[mutableAttributeString.string rangeOfString:enString]];
    [mutableAttributeString addAttribute:NSForegroundColorAttributeName value:BLUThemeSubTintContentForegroundColor range:NSMakeRange(0, mutableAttributeString.length)];
    
    _rightLabel.attributedText = mutableAttributeString;
    
    [self.view addSubview:_rightLabel];
    
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-BLUThemeMargin * 8);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - UI

- (QGTableView *)makeTableView {
    QGTableView *tableView = [QGTableView new];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[QGAboutCell class] forCellReuseIdentifier:NSStringFromClass([QGAboutCell class])];
    [tableView registerClass:[QGSettingCell class] forCellReuseIdentifier:NSStringFromClass([QGSettingCell class])];
    tableView.frame = self.view.frame;
    [self.view addSubview:tableView];
    return tableView;
}

#pragma mark - TabelView data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    
    QGSettingCell * (^makeSettingCell)(NSString *) = ^QGSettingCell *(NSString *title) {
        QGSettingCell *settingCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGSettingCell class]) forIndexPath:indexPath];
        settingCell.textLabel.text = title;
        settingCell.showSolidLine = indexPath.row == 2 ? NO : YES;
        settingCell.textLabel.textColor = [UIColor colorFromHexString:@"333333"];
        return settingCell;
    };
    
    switch (indexPath.row) {
        case TableViewRowTypeAbout: {
            QGAboutCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([QGAboutCell class]) forIndexPath:indexPath];
            cell = aboutCell;
        } break;
        case TableViewRowTypeMobile: {
            cell = makeSettingCell(@"联系我们");
        } break;
        case TableViewRowTypeEULA: {
            cell = makeSettingCell(@"用户使用协议");
        } break;
    }
    return cell;
}

#pragma mark - TableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = CGSizeZero;
    CGFloat width = tableView.width;
    switch (indexPath.row) {
        case TableViewRowTypeAbout: {
            size = [_tableView sizeForCellWithCellClass:[QGAboutCell class] cacheByIndexPath:indexPath width:width model:nil];
        } break;
        default: {
            size = CGSizeMake(width, 44.0);
        } break;
    }
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case TableViewRowTypeMobile: {
//            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"4008270277"];
//            _callWebview = [[UIWebView alloc] init];
//            [_callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"邮箱" message:@"developer@qiqiaoland.com" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } break;
        case TableViewRowTypeEULA: {
            BLUWebViewController *vc = [[BLUWebViewController alloc] initWithPageURL:[BLUApiManager eulaURL]];
            vc.title = NSLocalizedString(@"about.eula", @"EULA");
            [self.navigationController pushViewController:vc animated:YES];
        } break;

    }
}
@end
