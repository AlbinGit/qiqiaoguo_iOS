//
//  QGShowTimeView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGShowTimeView.h"

@interface QGShowTimeView()

/**背景*/
@property (nonatomic,strong)UIView *whiteView;
/**总时间label*/
@property (nonatomic,strong)UILabel *titleLabel;
/**知道了按钮*/
@property (nonatomic,strong)SAButton *btn;

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation QGShowTimeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI
{
    UIView *maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.5;
    [self addSubview:maskView];
    if (MQScreenH>568) {
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 320) / 2, (SCREEN_HEIGHT - 360) / 2,320, 360)];
   
    }else{
        _whiteView = [[UIView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH - 310) / 2, (SCREEN_HEIGHT - 360) / 2,310, 360)];
    }

    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.layer.cornerRadius = 10.0;
    _whiteView.layer.masksToBounds = YES;
    _whiteView.alpha = 0;
    _whiteView.tag = 999;
    [self addSubview:_whiteView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, _whiteView.width, 49)];
    _titleLabel.font = FONT_SYSTEM(17);
    _titleLabel.text = @"课程安排";
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_whiteView addSubview:_titleLabel];

    
    
    _btn = [[SAButton alloc]initWithFrame:CGRectMake(60, 290, _whiteView.width-120, 50)];
    _btn.backgroundColor = COLOR(253, 57, 91, 1);
    [_btn setTitle:@"我知道了" forState:UIControlStateNormal];
    _btn.layer.cornerRadius= 8.f;
   _btn.layer.masksToBounds = YES;
    [_btn setTitleColor:PL_COLOR_255 forState:UIControlStateNormal];
    _btn.titleLabel.font = FONT_SYSTEM(16);
    PL_CODE_WEAK(weakSelf);
    [_btn addClick:^(SAButton *button) {
        [weakSelf hiddenView];
    }];
    [_whiteView addSubview:_btn];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, _titleLabel.maxY, _whiteView.width, 270-_titleLabel.maxY) style:UITableViewStylePlain];
     _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = COLOR(243, 244, 246, 1);
    [_whiteView addSubview:_tableView];
    
    UILabel *line1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 49, _whiteView.width, 1)];
    line1.backgroundColor = APPBackgroundColor;
    [_whiteView addSubview:line1];
    
    UILabel *line2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 270, _whiteView.width, 1)];
    line2.backgroundColor = APPBackgroundColor;
    [_whiteView addSubview:line2];

    
    [self showView];
}


-(void)setSectionList:(QGCourseDetSectionListModel *)sectionList {

    _sectionList = sectionList;
     NSString *str = [NSString stringWithFormat:@"(共%zd节)",_itemlist.sectionList.count] ;
    _titleLabel.text = [NSString stringWithFormat:@"课程安排%@",str];
    [QGCommon setLableColor:str andLab: _titleLabel foot:[UIFont systemFontOfSize:15] color:@"999999"];

}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _itemlist.sectionList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    

    QGCourseDetSectionListModel *listModel =  _itemlist.sectionList[indexPath.row];
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, MQScreenW, 1)];
    line.backgroundColor = [UIColor colorFromHexString:@"e1e1e1"];
    [cell.contentView addSubview:line];
    NSString *timestr = [NSString stringWithFormat:@"%@ %@-%@",[SASDateUtils getNormalData:listModel.begin_date],[SASDateUtils getHour:listModel.start_time],[SASDateUtils getHour:listModel.end_time]];
       NSString *str = [NSString stringWithFormat:@"%@ %@",listModel.begin_date,listModel.start_time];
     NSInteger count= [[QGCommon testTimeWithTheTime:str] intValue];
    NSString *strRow = [NSString stringWithFormat:@"第%zd节",indexPath.row + 1];
  
    if (count>0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@(未开始)",strRow,timestr];
    }else if (count==0){
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@(进行中)",strRow,timestr];}
    else {
        
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@(已结束)",strRow,timestr];
        
    }
    [QGCommon setLableColor:strRow andLab:cell.textLabel foot:[UIFont systemFontOfSize:14] color:@"999999"];
     cell.selectionStyle =  UITableViewCellSelectionStyleNone;
    cell.backgroundColor = COLOR(243, 244, 246, 1);
    [cell.textLabel setTextColor: [UIColor colorFromHexString:@"666666"]];
    cell.textLabel.font = FONT_SYSTEM(13);
    cell.textLabel.textAlignment =NSTextAlignmentCenter;
   
    return cell;
}

- (void)showView
{
    [UIView animateWithDuration:0.3 animations:^{
        _whiteView.alpha = 1;
    }];
}

- (void)hiddenView
{
    [UIView animateWithDuration:0.3 animations:^{
        _whiteView.alpha = 0;
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if(touch.view.tag != 999)
    {
        [self hiddenView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
