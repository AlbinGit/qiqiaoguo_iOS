//
//  QGSkillTableView_m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGOptimalProductSkillTableViewCell.h"
#import "SDCycleScrollView.h"
#import "QGTimerLabel.h"
#import "QGFirstPageDataModel.h"
@interface QGOptimalProductSkillTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;




@end

@implementation QGOptimalProductSkillTableViewCell

- (void)awakeFromNib {
    _stuatsLab.font=FONT_CUSTOM(14);
    _imageW.constant += (MQScreenW-275)/2;
    self.timeLab.layer.cornerRadius = 5;
    self.timeLab.layer.masksToBounds = YES;
    self.timelab1.layer.cornerRadius = 5;
    self.timelab1.layer.masksToBounds = YES;
    self.timelabe2.layer.cornerRadius = 5;
    self.timelabe2.layer.masksToBounds = YES;
}


- (void)setResult:(QGOptimalProductResultModel *)result {
    _result = result;
    NSMutableArray *Array = [NSMutableArray array];
    NSMutableArray *priceArray = [NSMutableArray array];
    for (QGSeckillinglistItemModel *model in _result.seckillingList.items) {
        [Array addObject:model.coverpath];
        [priceArray addObject:model.sales_price];
        
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_skillImageView.frame imageURLStringsGroup:Array];
    // 模拟网络延时情景

  //  cycleScrollView.showPageControl = NO;
    cycleScrollView.titlesGroup = priceArray;
    [_skillImageView addSubview:cycleScrollView];
    QGTimerLabel *timeLab = [[QGTimerLabel alloc] initWithLabel:_timeLab andTimerType:QGTimerLabelTypeTimer];
    timeLab.timeFormat= @"HH";
    QGTimerLabel *timeLab1 = [[QGTimerLabel alloc] initWithLabel:_timelab1 andTimerType:QGTimerLabelTypeTimer];
    timeLab1.timeFormat= @"ss";
    QGTimerLabel *timeLab2 = [[QGTimerLabel alloc] initWithLabel:_timelabe2 andTimerType:QGTimerLabelTypeTimer];
    timeLab2.timeFormat= @"mm";
    if (_result.seckillingList!=nil)
    {
        //判断当前时间是否在活动期间
        NSInteger count=[QGCommon compareTimeStartTime:_result.seckillingList.start_time endTime:_result.seckillingList.end_time];
        if (count==0)
        {
            int timeInval= abs([[QGCommon testTimeWithTheTime:_result.seckillingList.start_time] intValue]);
            //获取天数
            NSInteger days2=timeInval/(3600*24);
            //获取剩余小时数
            NSInteger remainingHours2=timeInval%(24*3600);
            _stuatsLab.text=[NSString stringWithFormat:@"距开始: %ld 天",(long)days2];
            
            [QGCommon setLableColorAndSize:[NSString stringWithFormat:@"%ld",(long)days2] andLab:_stuatsLab];
            [timeLab setCountDownTime:remainingHours2];
            [timeLab start];
            [timeLab1 setCountDownTime:remainingHours2];
            [timeLab1 start];
            [timeLab2 setCountDownTime:remainingHours2];
            [timeLab2 start];
        }else if (count==1)
        {
            //活动期间
            NSInteger timeCount=[[QGCommon testTimeWithTheTime:_result.seckillingList.end_time]integerValue];
            if (timeCount>0)
            {
                //获取天数
                NSInteger days=timeCount/(3600*24);
                //获取剩余小时数
                NSInteger remainingHours=timeCount%(24*3600);
               _stuatsLab.text=[NSString stringWithFormat:@"距结束: %ld 天",(long)days];
                [QGCommon setLableColorAndSize:[NSString stringWithFormat:@"%ld",(long)days] andLab:_stuatsLab];
                [timeLab setCountDownTime:remainingHours];
                
                [timeLab start];
                [timeLab1 setCountDownTime:remainingHours];
                [timeLab1 start];
                [timeLab2 setCountDownTime:remainingHours];
                [timeLab2 start];
            }else
            {
                _stuatsLab.text=@"本场活动已结束";
                _timeLab.text=[NSString stringWithFormat:@"00:00:00"];
                _timeLab.textColor = PL_COLOR_160;
                _timeLab.backgroundColor=[UIColor whiteColor];
            }
        }else
        {
            //已结束
            _stuatsLab.text=@"本场活动已结束";
            _timeLab.textColor = PL_COLOR_160;
            _timeLab.backgroundColor=PL_COLOR_255;
        }
    }else
    {//没有活动
        _stuatsLab.text=@"暂无活动";
        _timeLab.text=[NSString stringWithFormat:@"00:00:00"];
        _timeLab.textColor = PL_COLOR_160;
        _timeLab.backgroundColor=[UIColor whiteColor];
    }
    
    
}


- (void)setDataModel:(QGFirstPageDataModel *)dataModel {
    
    
    _dataModel = dataModel;
    NSMutableArray *Array = [NSMutableArray array];
    NSMutableArray *priceArray = [NSMutableArray array];
    for (QGSeckillinglistItemModel *model in _dataModel.seckillingList.items) {
        [Array addObject:model.coverpath];
        [priceArray addObject:model.sales_price];
        
    }
    SDCycleScrollView *cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:_skillImageView.frame imageURLStringsGroup:Array];
    
    // 模拟网络延时情景

    //cycleScrollView.showPageControl = NO;
    
    cycleScrollView.titlesGroup = priceArray;
    [_skillImageView addSubview:cycleScrollView];
    
    
    QGTimerLabel *timeLab = [[QGTimerLabel alloc] initWithLabel:_timeLab andTimerType:QGTimerLabelTypeTimer];
    timeLab.timeFormat= @"HH";
    QGTimerLabel *timeLab1 = [[QGTimerLabel alloc] initWithLabel:_timelab1 andTimerType:QGTimerLabelTypeTimer];
    timeLab1.timeFormat= @"ss";
    QGTimerLabel *timeLab2 = [[QGTimerLabel alloc] initWithLabel:_timelabe2 andTimerType:QGTimerLabelTypeTimer];
    timeLab2.timeFormat= @"mm";
    if (_dataModel.seckillingList!=nil)
    {
        //判断当前时间是否在活动期间
        NSInteger count=[QGCommon compareTimeStartTime:_dataModel.seckillingList.start_time endTime:_dataModel.seckillingList.end_time];
        
        if (count==0)
        {
            int timeInval= abs([[QGCommon testTimeWithTheTime:_dataModel.seckillingList.start_time] intValue]);
            //获取天数
            NSInteger days2=timeInval/(3600*24);
            //获取剩余小时数
            NSInteger remainingHours2=timeInval%(24*3600);
            _stuatsLab.text=[NSString stringWithFormat:@"距开始: %ld 天",(long)days2];
            
            [QGCommon setLableColorAndSize:[NSString stringWithFormat:@"%ld",(long)days2] andLab:_stuatsLab];
            [timeLab setCountDownTime:remainingHours2];
            [timeLab start];
            [timeLab1 setCountDownTime:remainingHours2];
            [timeLab1 start];
            [timeLab2 setCountDownTime:remainingHours2];
            [timeLab2 start];
        }else if (count==1)
        {
            //活动期间
            NSInteger timeCount=[[QGCommon testTimeWithTheTime:_dataModel.seckillingList.end_time]integerValue];
            if (timeCount>0)
            {
                //获取天数
                NSInteger days=timeCount/(3600*24);
                //获取剩余小时数
                NSInteger remainingHours=timeCount%(24*3600);
                _stuatsLab.text=[NSString stringWithFormat:@"距结束: %ld 天",(long)days];
                [QGCommon setLableColorAndSize:[NSString stringWithFormat:@"%ld",(long)days] andLab:_stuatsLab];
                [timeLab setCountDownTime:remainingHours];
                
                [timeLab start];
                [timeLab1 setCountDownTime:remainingHours];
                [timeLab1 start];
                [timeLab2 setCountDownTime:remainingHours];
                [timeLab2 start];
            }else
            {
                _stuatsLab.text=@"本场活动已结束";
                _timeLab.text=[NSString stringWithFormat:@"00:00:00"];
                _timeLab.textColor = PL_COLOR_160;
                _timeLab.backgroundColor=[UIColor whiteColor];
            }
        }else
        {
            //已结束
            _stuatsLab.text=@"本场活动已结束";
            _timeLab.textColor = PL_COLOR_160;
            _timeLab.backgroundColor=PL_COLOR_255;
        }
    }else
    {//没有活动
        _stuatsLab.text=@"暂无活动";
        _timeLab.text=[NSString stringWithFormat:@"00:00:00"];
        _timeLab.textColor = PL_COLOR_160;
        _timeLab.backgroundColor=[UIColor whiteColor];
    }
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
