//
//  QGActivityDetailCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/6.
//
//

#import "QGActivityDetailCell.h"

@implementation QGActivityDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setItem:(QGActlistDetailModel *)item {
        _item = item;
    [_actadress setTitle:item.active_address];
    _actadress.titleLabel.numberOfLines = 2;
    NSString *str = [SAUtils getYearMonthDayCountWithString:_item.valid_begin_date];
    NSString *str1 = [SAUtils getYearMonthDayWithString:_item.valid_end_date];
    NSString *str2 = [SAUtils getYearMonthDayTimeCountWithString:_item.apply_end_date];
    [_actTime setTitle:[NSString stringWithFormat:@"活动时间:%@-%@",str,str1]];
    _enddate.text =[NSString stringWithFormat:@"报名截止:%@",str2] ;
    [_user_rang setTitle:_item.user_range];
 
    
    

}

@end
