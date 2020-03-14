//
//  QGShowTimeView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGBtnTagView.h"

@interface QGBtnTagView()


@property (nonatomic,strong)UIView *whiteView;

@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong)SAButton *btn;

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation QGBtnTagView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self p_createUI];
    }
    return self;
}

- (void)p_createUI
{

    
}

- (void)setArr:(NSArray *)arr {
    
    _arr = arr;
    float upX = 10;
    for (int i = 0; i<_arr.count; i++) {
        NSString *str = [_arr objectAtIndex:i] ;

        NSDictionary *dic = [NSDictionary dictionaryWithObject:[UIFont boldSystemFontOfSize:14] forKey:NSFontAttributeName];
        CGSize size = [str sizeWithAttributes:dic];

        //NSLog(@"%f",size.height);

        if (i==0 ) {
            upX = 10;
        }

        UIImage *im = [UIImage resizedImage:@"Label_box"];
        UIButton *btn= [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(upX, 10, size.width+10,20);
        [btn setBackgroundImage:im];
        [btn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:0];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:11];
        [btn setTitle:[_arr objectAtIndex:i] forState:0];

        upX+=size.width+20;

        [self addSubview:btn];

    }
    
}


@end
