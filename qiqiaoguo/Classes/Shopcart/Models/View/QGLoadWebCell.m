//
//  QGLoadWebCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import "QGLoadWebCell.h"

@implementation QGLoadWebCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
     [self createUI];
    }
    return self;
}
- (void)createUI
{
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, MQScreenH)];
    _webView.scalesPageToFit=YES;
    _webView.scrollView.scrollEnabled=NO;

    [self.contentView addSubview:_webView];
    _nullLab=[[UILabel alloc]init];
    _nullLab.font=FONT_CUSTOM(15);
    _nullLab.text=@"暂无详情";
    _nullLab.textColor=PL_COLOR_160;
    [self.contentView addSubview:_nullLab];
    PL_CODE_WEAK(weakSelf);
    [_nullLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.contentView);
    }];
}

@end
