//
//  QGApplyFieldListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/5.
//
//

#import "QGApplyFieldListCell.h"

@interface  QGApplyFieldListCell ()

@property (nonatomic,strong) UIButton *name;
@property (nonatomic,strong) UILabel *price;


@end

@implementation QGApplyFieldListCell
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


    
    UIButton *btn = [[UIButton alloc] init];
   
    [btn setTitleFont:[UIFont systemFontOfSize:15]];
    [btn setTitleColor:[UIColor colorFromHexString:@"666666"]];

    [self.contentView addSubview:btn];
    _name = btn;
    UILabel *price = [[UILabel alloc] init];
    price.font = [UIFont systemFontOfSize:15];
    price.textColor =[UIColor colorFromHexString:@"666666"];
    [self.contentView addSubview:price];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@10);
        make.height.equalTo(@44);
        
    }];
    [price mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.right.equalTo(@-10);
        make.height.equalTo(@44);

    }];
   
    _price = price;
 
 
   
}

- (void)setTicketListModel:(QGActlistTicketListModel *)ticketListModel {

    
    _ticketListModel = ticketListModel;
    [_name setTitle:[NSString stringWithFormat:@"%@/人",ticketListModel.name]];
    _price.text =[NSString stringWithFormat:@"￥%@", ticketListModel.price];
    
}
@end
