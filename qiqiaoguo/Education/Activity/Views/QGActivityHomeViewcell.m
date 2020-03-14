//
//  QGActivityHomeViewcellTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import "QGActivityHomeViewcell.h"

@implementation QGActivityHomeViewcell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor =RGB(242, 242, 242);
        CGFloat iconW = MQScreenW-20;
        _imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, iconW ,iconW*5/9 +55)];



        _imageview.backgroundColor =[UIColor whiteColor];
         [self.contentView addSubview:_imageview];
     
        [_imageview addSubview:self.headimage];
        _actname = [[UILabel alloc] init];
        _actname.font=[UIFont systemFontOfSize:16];
        
        _actname.textColor = [UIColor blackColor];
        [_imageview addSubview:_actname];
        
         _actadress  = [[UIButton alloc] init];
        [_actadress setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:(UIControlStateNormal)];
        [_actadress setTitleFont:[UIFont systemFontOfSize:12]];
        [_actadress setImage:[UIImage imageNamed:@"address_icon"] forState:(UIControlStateNormal)];
        [_imageview addSubview:_actadress];
        
        _dateTime  = [[UIButton alloc] init];
        [_dateTime setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:(UIControlStateNormal)];
        [_dateTime setTitleFont:[UIFont systemFontOfSize:12]];
        [_dateTime setImage:[UIImage imageNamed:@"card_time"] forState:(UIControlStateNormal)];
        [_imageview addSubview: _dateTime];
        
         _userrang  = [[UIButton alloc] init];
        [_userrang setTitleColor: [UIColor colorFromHexString:@"#999999"] forState:(UIControlStateNormal)];
        [_userrang setTitleFont:[UIFont systemFontOfSize:12]];
        [_userrang setImage:[UIImage imageNamed:@"card_icon"] forState:(UIControlStateNormal)];
        [_imageview addSubview:_userrang];
        
        _signtips = [[UIButton alloc ] init];
        _signtips.backgroundColor = [UIColor colorFromHexString:@"#000000"];
        _signtips.alpha = 0.5f;
        [_signtips setTitleFont:[UIFont systemFontOfSize:13]];
        _signtips.layer.masksToBounds = YES;
        _signtips.layer.cornerRadius = 11;
        [_signtips  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_imageview addSubview:_signtips];
        
        
        _price = [[UIButton alloc ] init];
         _price.backgroundColor = [UIColor colorFromHexString:@"ff3859"];
        [ _price setTitleFont:[UIFont boldSystemFontOfSize:15]];
        _price.layer.masksToBounds = YES;
        _price.layer.cornerRadius = 5;
        [ _price  setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        [_imageview addSubview: _price];
        
        [_price mas_makeConstraints:^(MASConstraintMaker *make) {
      
            make.right.equalTo(@-10);
          
            make.bottom.equalTo(_headimage).offset(-20);
        }];
        [_signtips mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(@-10);
            make.height.equalTo(@20);
            make.bottom.equalTo(_headimage).offset(-20);
        }];
            }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.imageview.layer.cornerRadius = 8;
    self.imageview.layer.masksToBounds = YES;
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.headimage.bounds byRoundingCorners: UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.headimage.bounds;
    maskLayer.path = maskPath.CGPath;
    self.headimage.layer.mask = maskLayer;
 }


- (UIImageView *)headimage
{
    if (!_headimage) {
          CGFloat iconW = MQScreenW-20;
        _headimage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MQScreenW-20,iconW*5/9)] ;

        
    }
    return _headimage;
}


- (void)setActModel:(QGActlistHomeModel *)actModel {
    
    _actModel = actModel ;
     _actname.text = actModel.title;

    CGRect rect = [QGCommon rectForString:_actname.text withFont:16 WithWidth:MQScreenW-40];
    _actname.frame =CGRectMake(10, _headimage.maxY+5, rect.size.width, 20);
       [_actadress setTitle:actModel.address];
      CGRect rectadress = [QGCommon rectForString:actModel.address withFont:12 WithWidth:MQScreenW-20];
    _actadress.frame = CGRectMake(5, _actname.maxY+5, rectadress.size.width+20, 20);
    
    [_dateTime setTitle:[SAUtils getYearMonthDayCountWithString:actModel.apply_begin_date]];
    CGRect recttime = [QGCommon rectForString:_dateTime.titleLabel.text withFont:12 WithWidth:MQScreenW-40];
    _dateTime.frame = CGRectMake(_actadress.maxX, _actname.maxY+5, recttime.size.width+20, 20);
    [_userrang setTitle:actModel.user_range];
     CGRect rectrang = [QGCommon rectForString:actModel.user_range withFont:12 WithWidth:MQScreenW-40];
    _userrang.frame = CGRectMake(_dateTime.maxX, _actname.maxY+5, rectrang.size.width+20, 20);
     [_signtips setTitle:[NSString stringWithFormat:@"     %@   ",actModel.sign_tips]];
    [_price setTitle:[NSString stringWithFormat:@" %@%@ ",actModel.price,actModel.price_tail]];

     [_headimage sd_setImageWithURL:[NSURL URLWithString:actModel.coverPicPop] placeholderImage:nil];
    
}
@end
