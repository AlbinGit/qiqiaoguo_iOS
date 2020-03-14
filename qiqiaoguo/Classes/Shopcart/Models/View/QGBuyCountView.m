
//
//  QGBuyCountView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import "QGBuyCountView.h"

@implementation QGBuyCountView
@synthesize bt_add,bt_reduce,tf_count,lb;
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        lb = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
        lb.text = @"购买数量";
        lb.textColor = [UIColor blackColor];
        lb.font = [UIFont systemFontOfSize:14];
        [self addSubview:lb];
        
        bt_add= [UIButton buttonWithType:UIButtonTypeCustom];
        bt_add.frame = CGRectMake(self.frame.size.width-10-30, 10,30,30);

        [bt_add setBackgroundImage:[UIImage imageNamed:@"_+可选"] forState:(UIControlStateNormal)];
        [bt_add setTitleColor:[UIColor blackColor] forState:0];
        bt_add.titleLabel.font = [UIFont systemFontOfSize:20];

        [self addSubview:bt_add];
        
        tf_count = [[UITextField alloc] initWithFrame:CGRectMake(bt_add.frame.origin.x -30-10-5, 10, 40, 30)];
        tf_count.text = @"1";
        tf_count.textAlignment = NSTextAlignmentCenter;
        tf_count.font = [UIFont systemFontOfSize:15];
        tf_count.userInteractionEnabled= NO;
        [self addSubview:tf_count];
        
        bt_reduce= [UIButton buttonWithType:UIButtonTypeCustom];
        bt_reduce.frame = CGRectMake(tf_count.frame.origin.x -30-5, 10, 30, 30);
       
      
        bt_reduce.titleLabel.font = [UIFont systemFontOfSize:20];
        [bt_reduce setBackgroundImage:[UIImage imageNamed:@"_-不可选"] forState:(UIControlStateNormal)];
        [self addSubview:bt_reduce];
        

    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
