//
//  QGSecKillTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import "QGSecKillTableViewCell.h"
#import "QGSecKillDetailViewController.h"
@implementation QGSecKillTableViewCell
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
    _coverImageView =[SAImageView createImageViewWithRect:CGRectMake(8, 8, 100, 100) andWithImg:nil andWithEnable:NO];
    [self.contentView addSubview:_coverImageView];
    //标题
    _product_name=[[SALabel alloc]init];
    _product_name.font=[UIFont systemFontOfSize:16];
    _product_name.textColor=QGTitleColor;
    _product_name.numberOfLines=2;
    [self.contentView addSubview:_product_name];

    //秒杀价
    _seckilling_price=[[SALabel alloc] init];
    _seckilling_price.textColor = QGMainRedColor;
    _seckilling_price.font=[UIFont boldSystemFontOfSize:16];
    [self.contentView addSubview:_seckilling_price];
    //原销售价
    _saleprice=[[SALabel alloc] init];
    _saleprice.textColor = QGCellContentColor;
    _saleprice.font=FONT_SYSTEM(15);
    [self.contentView addSubview:_saleprice];
    //已抢数量
    _sold=[[SALabel alloc] init];
    _sold.font = [UIFont systemFontOfSize:12];
    _sold.textColor= QGMainRedColor;
    [self.contentView addSubview:_sold];
    //马上抢btn
    _Immediately_grabBtn=[SAButton createBtnWithRect:CGRectMake(SCREEN_WIDTH-80, 110-54/2.0, 140/2.0, 27) andWithImg:nil andWithTag:8765 andWithBg:nil andWithTitle:@"马上抢" andWithColor:PL_UTILS_COLORRGB(255,255, 255)];
    
    _Immediately_grabBtn.layer.cornerRadius = 5;
    _Immediately_grabBtn.layer.masksToBounds = YES;
    _Immediately_grabBtn.titleLabel.font=FONT_CUSTOM(16);
    
    [self.contentView addSubview:_Immediately_grabBtn];
    
    //进度条
    _progressView = [[customProgressView alloc] initWithFrame:CGRectMake(_coverImageView.maxX+5, 100, 60, 10) withTheProgress:0.0];
    
    _progressView.autoresizingMask =  UIViewAutoresizingNone ;
    _progressView.progressViewBorderColor=COLOR(253, 168, 185, 1);
    _progressView.progressViewCorlor=PL_UTILS_COLORRGB(231, 80, 93);
       _progressView.progressViewBackGroundCorlor = COLOR(253, 168, 185, 1);
    [self.contentView addSubview: _progressView];
    _percent=[SALabel createLabelWithRect:CGRectMake(_progressView.maxX+5, 97,[QGCommon rectWithString:@"¥已抢购100%" withFont:11],[QGCommon rectWithFont:11]) andWithColor:QGCellContentColor  andWithFont:11 andWithAlign:NSTextAlignmentLeft andWithTitle:nil];
    [self.contentView addSubview:_percent];
    
    [_product_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(8);
        make.left.equalTo( _coverImageView).offset(105);
    }];
    [_sold mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_Immediately_grabBtn);
        make.top.equalTo(self.contentView).offset(65);
        
    }];
    

}
- (void)setListModel:(QGSeckillListItemModel *)listModel
{
    _listModel = listModel;
    NSLog(@"sssssss443333 %@",listModel.title);
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:listModel.coverpath] placeholderImage:LOADING_200];
    
    _product_name.text = listModel.title;
    
    _seckilling_price.text=[NSString stringWithFormat:@"¥%@",listModel.sales_price];
    _saleprice.text=[NSString stringWithFormat:@"¥%@",listModel.market_price];
    _saleprice.lineColor=PL_COLOR_160;
    _saleprice.lineType=LineTypeMiddle;
    CGFloat present=0;
    present=[listModel.sales_volume floatValue]/[listModel.stock floatValue];
    _progressView.progress=present;
    _sold.text=[NSString stringWithFormat:@"已抢%@件",listModel.sales_volume];
    
    _percent.text=[NSString stringWithFormat:@"已抢购%d%@",(int)(present*100),@"%"];
    //比较当前时间和活动开始结束时间
    //判断是否结束
    //活动未开始状态为0，开始状态为1，结束状态为2
  
    if ([QGCommon compareTimeStartTime:_listModel.start_time endTime:_listModel.end_time]==0)
    {
        _Immediately_grabBtn.userInteractionEnabled=NO;
        _Immediately_grabBtn.backgroundColor = COLOR(224, 225, 226, 1);
        [_Immediately_grabBtn setTitleColor:COLOR(190, 191, 192, 1) forState:(UIControlStateNormal)];
        [_Immediately_grabBtn setTitle:@"即将开抢" forState:UIControlStateNormal];
        _Immediately_grabBtn.userInteractionEnabled=NO;
        _percent.hidden = YES;
        _progressView.hidden = YES;
        _sold.hidden = YES;
    }else if([QGCommon compareTimeStartTime:_listModel.start_time endTime:_listModel.end_time]==1)
    {
        //是否抢完
        _Immediately_grabBtn.backgroundColor = COLOR(253, 57, 91, 1);
        [_Immediately_grabBtn setTitleColor:COLOR(255, 255, 255, 1) forState:(UIControlStateNormal)];
        _Immediately_grabBtn.userInteractionEnabled=YES;
        _percent.hidden = NO;
        _progressView.hidden = NO;
        _sold.hidden = NO;
        if ([listModel.sales_volume integerValue]==[listModel.stock integerValue])
        {     [_Immediately_grabBtn setTitleColor:COLOR(190, 191, 192, 1) forState:(UIControlStateNormal)];
            _Immediately_grabBtn.backgroundColor = COLOR(224, 225, 226, 1);
            [_Immediately_grabBtn setTitle:@"抢光了" forState:UIControlStateNormal];
            _Immediately_grabBtn.userInteractionEnabled=NO;
        }else
        {
            _Immediately_grabBtn.userInteractionEnabled=YES;
            
            [_Immediately_grabBtn setTitle:@"马上抢" forState:UIControlStateNormal];
        }
    }else
    {
        //活动结束
        _Immediately_grabBtn.userInteractionEnabled=NO;
        
        [_Immediately_grabBtn setTitle:@"已结束" forState:UIControlStateNormal];
    }
    
    NSInteger count=[QGCommon compareTimeStartTime:listModel.start_time endTime:listModel.end_time];
    if (count== 0) {
       [_Immediately_grabBtn setTitle:@"即将开抢" forState:UIControlStateNormal];
        _Immediately_grabBtn.userInteractionEnabled=NO;
    }
    
    
           PL_CODE_WEAK(ws);
    [_Immediately_grabBtn addClick:^(SAButton *button) {
  
      
        
        QGSecKillDetailViewController *seckDetail=[QGSecKillDetailViewController new];
        seckDetail.goods_id=listModel.id;
        seckDetail.seckilling_no = listModel.seckilling_no;
        NSLog(@"asssdddds %@",listModel.id);
        //seckDetail.sid=listModel2.sid;
         UIViewController *viewController = [SAUtils findViewControllerWithView:ws];
        [viewController.navigationController pushViewController:seckDetail animated:YES];
        
        
 
    }];
     CGRect rect = [QGCommon rectForString:_seckilling_price.text withBoldFont:16];
    _seckilling_price.frame = CGRectMake(_coverImageView.maxX+5, 50, rect.size.width , rect.size.height) ;
    _saleprice.frame = CGRectMake(_seckilling_price.maxX +5, _seckilling_price.Y, [QGCommon rectWithString: _saleprice.text withFont:15], rect.size.height) ;
    
    
    
}
@end
