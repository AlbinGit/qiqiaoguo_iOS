
//
//  QGTypeView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/14.
//
//

#import "QGTypeView.h"

@implementation QGTypeView
-(instancetype)initWithFrame:(CGRect)frame andDatasource:(NSArray *)arr :(NSString *)typename
{
    self = [super initWithFrame:frame];
    if (self) {

        float upX = 10;

        for (int i = 0; i<arr.count; i++) {

            NSString *str = [arr objectAtIndex:i] ;
            
            NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];

            CGSize size = [str sizeWithAttributes:dic];

            if (i == 0) {
                upX = 10;
            }

           UIImage *im = [UIImage resizedImage:@"Label_box"];
            UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(upX, 10, size.width+20,22);
            [btn setBackgroundImage:im];
            [btn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:0];
           
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn setTitle:[arr objectAtIndex:i] forState:0];

            [self addSubview:btn];
            upX+=size.width+25;
        }

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
