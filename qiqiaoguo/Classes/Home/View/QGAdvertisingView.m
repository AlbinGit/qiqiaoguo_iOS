//
//  QGAdvertisingView.m
//  qiqiaoguo
//
//  Created by cws on 2016/9/23.
//
//

#import "QGAdvertisingView.h"

@interface QGAdvertisingView ()

@property (nonatomic, strong)UIImageView *logoView;
@property (nonatomic, strong)UIImageView *AdView;

@end

@implementation QGAdvertisingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    CGFloat logoHeight = [UIScreen mainScreen].bounds.size.height / 6;
    
    _logoView = [[UIImageView alloc]init];
    _logoView.backgroundColor = [UIColor whiteColor];
    _logoView.frame = CGRectMake(0, self.height - logoHeight, self.width, logoHeight);
    _logoView.image = [UIImage imageNamed:@"StartBottomImage"];
    _logoView.contentMode = UIViewContentModeCenter;
    [self addSubview:_logoView];
    
    _AdView = [UIImageView new];
    _AdView.frame = CGRectMake(0, 0, self.width,self.height - logoHeight);
    _AdView.contentMode =  UIViewContentModeScaleAspectFit;
    _AdView.clipsToBounds  = YES;
    [self addSubview:_AdView];
    
    _cannelButton = [UIButton new ];
    _cannelButton.titleFont = [UIFont systemFontOfSize:16.0];
    _cannelButton.title = @"跳过";
    [_cannelButton sizeToFit];
    _cannelButton.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    _cannelButton.clipsToBounds = YES;
    _cannelButton.cornerRadius = _cannelButton.height/2;
    [self addSubview:_cannelButton];
    _cannelButton.hidden = YES;
    [_cannelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(25);
        make.right.equalTo(self).offset(-15);
    }];
    
}

- (void)setAdImage:(UIImage *)adImage{
    _AdView.image = adImage;
    CGFloat multiple = self.width/adImage.size.width;
    CGFloat height = adImage.size.height * multiple;
    _AdView.frame = CGRectMake(0, 0, self.width,height);
    [self bringSubviewToFront:_logoView];
}

@end
