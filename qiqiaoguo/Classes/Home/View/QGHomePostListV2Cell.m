//
//  QGHomePostListV2Cell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/8.
//
//

#import "QGHomePostListV2Cell.h"

@interface  QGHomePostListV2Cell ()


/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UILabel *introLabel;

@property (nonatomic,strong) UIButton *name;

@property (nonatomic,strong) UIButton *acc;
@property (nonatomic,strong) UIButton *comm;
@property (nonatomic,strong) UILabel *line;

@property (nonatomic,strong) UIImageView *imageview;

@property (nonatomic,strong) UIView *imageBGView;
@end


@implementation QGHomePostListV2Cell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
  
        [self p_createCollectionView];
    }
    return self;
}
- (void) p_createCollectionView

{     
           // 创建正文
        UILabel *introLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        introLabel.textColor = [UIColor colorFromHexString:@"666666"];
        introLabel.numberOfLines = 2;
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.borderColor =  QGlineBackgroundColor.CGColor;
        btn.layer.borderWidth= QGOnePixelLineHeight;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 3;
        [btn setTitleFont:[UIFont systemFontOfSize:10]];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [btn setTitleColor: QGlineBackgroundColor forState:(UIControlStateNormal)];
        btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:btn];
        self.name = btn;
        
        UIButton *acc = [[UIButton alloc] init];
        [acc setImage:[UIImage imageNamed:@"reading-image"] forState:(UIControlStateNormal)];
        
        acc.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [acc  setTitleColor: QGlineBackgroundColor forState:(UIControlStateNormal)];
        [self.contentView addSubview:acc];
        self.acc = acc;
        [_acc setTitleFont:[UIFont systemFontOfSize:11]];
        
        UIButton *com =[[UIButton alloc] init];
        com.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [com setImage:[UIImage imageNamed:@"com"] forState:(UIControlStateNormal)];
        [com  setTitleColor: QGlineBackgroundColor forState:(UIControlStateNormal)];
        [self.contentView addSubview:com];
        
        self.comm = com;
        [_comm setTitleFont:[UIFont systemFontOfSize:11]];
        CGFloat Width  = (MQScreenW-20)/2.0-15;
         CGFloat Height1 = Width*0.53+8;
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(-15, Height1-QGOnePixelLineHeight, Width+30,QGOnePixelLineHeight)];
        line.backgroundColor = QGlineBackgroundColor;
        [self.contentView addSubview:line];
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(-15, 0,QGOnePixelLineHeight+0.1, Width)];
        line1.backgroundColor = QGlineBackgroundColor;
  
       [self.contentView addSubview:line1];

    
     [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(@0);
         make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-13);
    }];
    [_acc mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@5);
       make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [_comm mas_makeConstraints:^(MASConstraintMaker *make) {
        
       
         make.left.equalTo(_acc.mas_right).offset(10);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    [self.introLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
         CGFloat Width  = (MQScreenW-20)/2.0-15;
        make.left.equalTo(@0);
        make.top.equalTo(self.contentView).offset(13);
        make.width.equalTo(@(Width));
        
    }];
    
  
}


-(void)setPo:(QGPostListModel *)po {
      _po = po;
     self.introLabel.text = po.title;
    
     [_name setTitle:po.circle_name];
    
     [_acc setTitle:po.access_count];
    
     [_comm setTitle:po.comment_count];

   

    
}
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}
@end
