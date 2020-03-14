//
//  QGActOrderListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGActOrderListCell.h"

@implementation QGActOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addBotttomView];
}
- (void)addBotttomView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 80, MQScreenW, 50)];
    view.backgroundColor = [UIColor whiteColor];
    UILabel *labline = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 1)];
    labline.backgroundColor =APPBackgroundColor;
    [view addSubview:labline];
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(18, 1, 70, 50)];
    lab.text = @"买家留言:";
    lab.textColor = [UIColor blackColor];
    lab.font = [UIFont systemFontOfSize:15];
    [view addSubview:lab];

    _textNote = [[QGTextView alloc] initWithFrame:CGRectMake(80,10, SCREEN_WIDTH-110, 38)];
    _textNote.placehoder = @"选填，可填写您的特殊需求...";
    
  
    _textNote.placehoderColor = [UIColor colorFromHexString:@"c1c1c1"];
    _textNote.textColor = [UIColor colorFromHexString:@"333333"];
    [view addSubview:_textNote];
    
    
    [self.contentView addSubview:view];
}


- (void)setItem:(QGActlistDetailModel *)item {
    _item = item;
    _title.text = _item.title;
     [_icon sd_setImageWithURL:[NSURL URLWithString:_item.coverPicPop]placeholderImage:nil];
    _sign.text = _item.type_name;
}

@end
