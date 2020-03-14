//
//  QGSearchCourseTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGSearchCourseTableViewCell.h"
#import "QGBtnTagView.h"
@interface QGSearchCourseTableViewCell ()
/**课程图片*/
@property (nonatomic, strong) UIImageView * courseImageView;
/**课程名称*/
@property (nonatomic, strong) UILabel * titleLabel;
/**课程地址*/
@property (nonatomic, strong) UIImageView * addressimage;
@property (nonatomic, strong) UILabel * addressLabel;
// 教师名称
@property (nonatomic, strong) UILabel * numteacher;
//教年
@property (nonatomic, strong) UILabel * linteacher;

/**教育条件*/
@property (nonatomic, strong) UIImageView * eduimage;
@property (nonatomic,strong) UIButton *btnexit;
@property (nonatomic,strong) UIButton *btnexit1;
/**退班条件*/
@property (nonatomic, strong) UILabel * exitLabel;
@property (nonatomic,strong) NSMutableArray *arrM;
// 适学年龄标题
@property (nonatomic, strong) UILabel * suittitle;

/**适合人群*/
@property (nonatomic, strong) UILabel * suitLabel;

// 线
@property (nonatomic, strong) UILabel * lablina;
// 线
@property (nonatomic, strong) UILabel * lablina2;


/**机构名称*/
@property (nonatomic, strong) UILabel * organtitle;
/**班级安排人数*/
@property (nonatomic, strong) UILabel * numLabel;
/**课程安排时间*/

@property (nonatomic, strong) UILabel * timetitle;
@property (nonatomic, strong) UILabel * timeLabel;
/**价格*/
@property (nonatomic, strong) UILabel * priceLabel;
/**报名按钮*/
@property (nonatomic, strong) UIButton * signUpBtn;
@property (nonatomic, copy) QGSearchCourseTableViewCellBlock block;
@property (nonatomic,strong) UILabel *bottonlab;

@property (nonatomic, strong)  QGBtnTagView* typeView;

@end
@implementation QGSearchCourseTableViewCell
#define TEXTFONT [UIFont systemFontOfSize:12]

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _arrM = [[NSMutableArray alloc]init];
        [self p_createUI];
    }
    return self;
}



- (void)p_createUI {
    // 课程封面
    UIImageView *icon = [[UIImageView alloc] init];
 
    [self.contentView addSubview:icon];
    self.courseImageView = icon;
    //课程标题
    UILabel *title = [[UILabel alloc] init];
    title.font = [UIFont systemFontOfSize:16.f];
    [self.contentView addSubview:title];
    _titleLabel = title;
    _titleLabel.textColor =QGTitleColor;
    UILabel *ll = [[UILabel alloc] init];
    ll.font = FONT_CUSTOM(13);
    ll.textColor = [UIColor colorFromHexString:@"999999"];
    ll.text = @"";
    [self.contentView addSubview:ll];
    self.numteacher = ll;
    UILabel *tea = [[UILabel alloc] init];
    tea.text = @"0年教年";
    tea.font =FONT_CUSTOM(13);
    tea.textColor = [UIColor colorFromHexString:@"999999"];
    [self.contentView addSubview:tea];
    self.linteacher = tea;
    // 课程地址
    UIImageView *ima = [[UIImageView alloc] init];
    ima.image = [UIImage imageNamed:@"address_icon"];
    [self.contentView addSubview:ima];
    self.addressimage = ima;
       _addressLabel = [[UILabel alloc]init];
    [self.contentView addSubview:_addressLabel];
    _addressLabel.font = FONT_CUSTOM(12);
    _addressLabel.textColor = [UIColor colorFromHexString:@"999999"];
    //教育说明
    //Label_box
    UIImageView *iconimage = [[UIImageView alloc] init];
    [self.contentView addSubview:iconimage];
    self.eduimage = iconimage;
    // 类型
    _typeView = [[QGBtnTagView alloc]initWithFrame:CGRectMake(40, 100, MQScreenW, 20)];
    [self.contentView addSubview:_typeView];
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:@"随时插班" forState:(UIControlStateNormal)];
    btn.titleLabel.font = FONT_CUSTOM(12);
    [btn setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    [self.contentView addSubview:btn];
    self.btnexit = btn;
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"艺术教育" forState:(UIControlStateNormal)];
    btn1.titleLabel.font = TEXTFONT;
    [btn1 setTitleColor:COLOR(153, 153, 153, 1) forState:UIControlStateNormal];
    
    [self.contentView addSubview:btn1];
    
    self.btnexit1 = btn1;
    // 线
    UILabel * line1 = [[UILabel alloc] init];
    line1.backgroundColor = [UIColor colorFromHexString:@"f5f5f5"];
    [self.contentView addSubview:line1];
    
    self.lablina = line1;
    // 适学年龄标题
    UILabel * suitLabel = [[UILabel alloc]init];
    suitLabel.textColor = [UIColor colorFromHexString:@"999999"];
    suitLabel.font = TEXTFONT;
    [self.contentView addSubview:suitLabel];
    suitLabel.text = @"适学年龄";
    self.suittitle = suitLabel;
     // 适学人群
    _suitLabel = [[UILabel alloc]init];
    _suitLabel.textColor = [UIColor colorFromHexString:@"666666"];
    _suitLabel.font = TEXTFONT;
    [self.contentView addSubview:_suitLabel];
     // 班级安排标题
    UILabel * numLabel = [[UILabel alloc]init];
    numLabel.textColor =[UIColor colorFromHexString:@"999999"];
    numLabel.font = TEXTFONT;
    [self.contentView addSubview:numLabel];
    numLabel.text = @"机构名称";
    self.organtitle = numLabel;
      //
    _numLabel = [[UILabel alloc]init];
    _numLabel.textColor = [UIColor colorFromHexString:@"666666"];
    _numLabel.font = TEXTFONT;
    [self.contentView addSubview:_numLabel];
    
    
    // 时间安排标题
    UILabel * timeLabel = [[UILabel alloc]init];
    timeLabel.textColor = [UIColor colorFromHexString:@"999999"];
    timeLabel.font = TEXTFONT;
    [self.contentView addSubview:timeLabel];
    timeLabel.text = @"时间安排";
    
    self.timetitle= timeLabel;
    
    // 课程安排
    _timeLabel = [[UILabel alloc]init];
    _timeLabel.textColor =[UIColor colorFromHexString:@"666666"];
    _timeLabel.font = TEXTFONT;
    [self.contentView addSubview:_timeLabel];
    // 线
    UILabel * line2 = [[UILabel alloc]init];
    line2.backgroundColor =  [UIColor colorFromHexString:@"f5f5f5"];
    [self.contentView addSubview:line2];
    self.lablina2 = line2;
    // 价格
    _priceLabel =  [[UILabel alloc]init];
    _priceLabel.textColor = [UIColor colorFromHexString:@"ff3859"];
    _priceLabel.font = FONT_CUSTOM(17);
    _priceLabel.font = [UIFont boldSystemFontOfSize:17];
    [self.contentView addSubview:_priceLabel];
    
    // 底部空隙
    UILabel * label = [[UILabel alloc]init];
    label.backgroundColor = COLOR(242, 243, 244, 1);
    [self.contentView addSubview:label];
    self.bottonlab= label;

}
/**
 *  根据model给cell上的控件赋值
 *
 *  @param model 课程模型
 */
- (void)setModel:(QGCourseInfoModel *)model {
    _model = model;
    [self addData];
  
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
   [self countFrame];
   
}

#pragma mark 计算frame
- (void)countFrame {
    
    // 课程封面
    _courseImageView.frame = CGRectMake(10, 20, 150, 150*0.625);
    // 课程标题
    _titleLabel.frame = CGRectMake(_courseImageView.maxX + 10, _courseImageView.minY, SCREEN_WIDTH - _courseImageView.maxX - 30, 15);
    CGRect rect = [QGCommon rectForString:_numteacher.text withFont:13 WithWidth:MQScreenW];
    self.numteacher.frame = CGRectMake(_courseImageView.maxX + 10, _titleLabel.maxY + 10, rect.size.width, 15);
    self.linteacher.frame = CGRectMake(self.numteacher.maxX +10,_titleLabel.maxY+10, 60, 15);
    // 课程地址
    self.addressimage.frame = CGRectMake(_courseImageView.maxX + 10, self.numteacher.maxY + 10, 13, 13);
    _addressLabel.frame = CGRectMake(_titleLabel.minX+15, self.numteacher.maxY + 10, MQScreenW- _courseImageView.maxX - 45, 15);
    //教育说明
    
    UIImage *image = [UIImage imageNamed:@"Label_box"];
    _eduimage.image = [image stretchableImageWithLeftCapWidth:image .size.width * 0.5 topCapHeight:image.size.height  * 0.5];


    _typeView.frame = CGRectMake(_courseImageView.maxX, _addressLabel.maxY, MQScreenW, 20);

    // 线1
    self.lablina.frame = CGRectMake(_courseImageView.minX, _courseImageView.maxY + 10, SCREEN_WIDTH - 20,1);
    
    //适合年龄
    self.suittitle.frame = CGRectMake(_courseImageView.minX, self.lablina.maxY + 5, 50, 15);
    
    _suitLabel.frame = CGRectMake( self.suittitle.maxX + 5,  self.suittitle.minY, SCREEN_WIDTH -  self.suittitle.maxX - 10, 15);
    
    //机构名称
    _organtitle.frame = CGRectMake(_courseImageView.minX , self.suittitle.maxY + 5, self.suittitle.maxX , 15);
    
    _numLabel.frame = CGRectMake(_suitLabel.minX, _suitLabel.maxY + 5, _suitLabel.width, 15);
    
    //时间安排
    
    _timetitle.frame = CGRectMake(_courseImageView.minX, _numLabel.maxY + 5, self.suittitle.maxX, 15);
    _timeLabel.frame = CGRectMake(_numLabel.minX, _numLabel.maxY + 5, _numLabel.width, 15);
    //线2
    _lablina2.frame = CGRectMake(_lablina.minX, _timeLabel.maxY + 5, _lablina.width, 1);
    //价格cg
    _priceLabel.frame = CGRectMake(_courseImageView.minX, _lablina2.maxY + 10, SCREEN_WIDTH -25, 20);
    
    _bottonlab.frame = CGRectMake(0, _priceLabel.maxY+15, MQScreenW, 10);

}
#pragma mark 赋值数据

- (void)addData {

    // 课程封面
    [_courseImageView sd_setImageWithURL:[NSURL URLWithString:_model.cover_path] placeholderImage:LOADING_200];
    
        // 课程标题
    if ([_model.type isEqualToString:@"3"] || [_model.type isEqualToString:@"4"]) {
         _titleLabel.attributedText = [self configTitle:_model.title];
    }else {
         _titleLabel.text = _model.title ;
    }
    // 地址
    _addressLabel.text = _model.address;
    
    _numteacher.text = _model.teacher_name;
    
    self.linteacher.text= [NSString stringWithFormat:@"%@年教龄",_model.teacher_experience];

    _exitLabel.width = [SAUtils getCGSzieWithText:_exitLabel.text width:MQScreenW height:15 font:FONT_CUSTOM(11)].width + 10;
    // 适学人群
    _suitLabel.text = _model.student_range;
    // 班级安排
    _numLabel.text = _model.org_name;
    // 课程安排
    _timeLabel.text = _model.section;

    [_arrM removeAllObjects];

    for (UIView*son in _typeView.subviews) {
        [son removeFromSuperview];
    }

    for ( QGCourseTagModel *tag  in _model.tagList) {
        [_arrM addObject:tag.tag_name];
    }
    [_typeView setArr:_arrM];

    // 价格
    _priceLabel.text = [NSString stringWithFormat:@"￥%@",_model.class_price];

    
}

- (NSMutableAttributedString *)configTitle:(NSString *)title{
    
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",title]];
    NSTextAttachment *attch = [[NSTextAttachment alloc] init];
    // 表情图片
    UIImageView *image =[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"audition-icon"]];
    [image sizeToFit];
    attch.image = [UIImage imageNamed:@"audition-icon"];
    // 设置图片大小
    attch.bounds = CGRectMake(0, -2,image.width, image.height);
    // 创建带有图片的富文本
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri insertAttributedString:string atIndex:0];
    
    return attri;
}
- (void)btnClicked:(UIButton *)btn {
    if (_block)
        _block(_model);
}

- (void)signUpBtnClicked:(QGSearchCourseTableViewCellBlock)block {
    _block = block;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
