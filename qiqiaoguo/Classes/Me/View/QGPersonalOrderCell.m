


//
//  QGPersonalOrderCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/11.
//
//

#import "QGPersonalOrderCell.h"

@interface QGPersonalOrderCell ()

@property (nonatomic, strong) UIButton *mallOrderButton;
@property (nonatomic, strong) UIButton *ActivOrderButton;
@property (nonatomic, strong) UIButton *CourseButton;

@property (nonatomic, strong) UILabel *mallOrderLabel;
@property (nonatomic, strong) UIImageView *mallOrderImage;
@property (nonatomic, strong) UILabel *ActivOrderLabel;
@property (nonatomic, strong) UIImageView *ActivOrderImage;
@property (nonatomic, strong) UILabel *CourseOrderLabel;
@property (nonatomic, strong) UIImageView *CourseOrderImage;
@property (nonatomic, strong) UIView *mallOrderView;
@property (nonatomic, strong) UIView *ActivOrderView;
@property (nonatomic, strong) UIView *CourseOrderView;
@property (nonatomic, strong) UIView *centerLine1;
@property (nonatomic, strong) UIView *centerLine2;
@end

@implementation QGPersonalOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        
        _CourseOrderLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _CourseOrderLabel.textColor = QGMainRedColor;
        _CourseOrderLabel.text = @"课程订单";
        
        _CourseOrderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_courseOrder"]];
        
        _CourseOrderView = [UIView new];
        [_CourseOrderView addSubview:_CourseOrderLabel];
        [_CourseOrderView addSubview:_CourseOrderImage];
        [superview addSubview:_CourseOrderView];
        
        _ActivOrderLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _ActivOrderLabel.textColor = QGMainRedColor;
        _ActivOrderLabel.text = @"活动订单";
        
        _ActivOrderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_activOrder"]];
        
        _ActivOrderView = [UIView new];
        [_ActivOrderView addSubview:_ActivOrderLabel];
        [_ActivOrderView addSubview:_ActivOrderImage];
        [superview addSubview:_ActivOrderView];
        
        
        
        _mallOrderLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _mallOrderLabel.textColor = QGMainRedColor;
        _mallOrderLabel.text = @"商城订单";
        
        _mallOrderImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon_mallOrder"]];
        _mallOrderView = [UIView new];
        [_mallOrderView addSubview:_mallOrderLabel];
        [_mallOrderView addSubview:_mallOrderImage];
        [superview addSubview:_mallOrderView];

        _centerLine1 = [UIView new];
        _centerLine1.backgroundColor = QGCellbottomLineColor;
        [superview addSubview:_centerLine1];
        
        _centerLine2 = [UIView new];
        _centerLine2.backgroundColor = QGCellbottomLineColor;
        [superview addSubview:_centerLine2];
        
        
        _mallOrderButton = [UIButton new];
        _mallOrderButton.tag = 102;
        [_mallOrderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_mallOrderButton];
        
        
        _mallOrderLabel.hidden = YES;
        _mallOrderView.hidden = YES;
         _centerLine2.hidden = YES;
        _mallOrderButton.hidden = YES;
        
        
        _ActivOrderButton = [UIButton new];
        _ActivOrderButton.tag = 101;
        [_ActivOrderButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_ActivOrderButton];
        
        _CourseButton = [UIButton new];
        _CourseButton.tag = 103;
        [_CourseButton addTarget:self action:@selector(orderButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [superview addSubview:_CourseButton];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_CourseOrderImage sizeToFit];
    [_CourseOrderLabel sizeToFit];
   
    
    
    _CourseOrderImage.X = _CourseOrderImage.width/2 + _CourseOrderLabel.width/2  + BLUThemeMargin ;
    _CourseOrderImage.Y = 0;
    
    _CourseOrderLabel.X = _CourseOrderImage.maxX + BLUThemeMargin*2;
    _CourseOrderLabel.centerY = _ActivOrderImage.centerY;
    
    _CourseOrderView.Y = BLUThemeMargin * 4;
 //   _CourseOrderView.width = _CourseOrderLabel.maxX;
    _CourseOrderView.width = SCREEN_WIDTH/2;
    
    _CourseOrderView.height = _CourseOrderImage.maxY;
    
    _centerLine1.width = QGOnePixelLineHeight;
    _centerLine1.X = SCREEN_WIDTH/2;
    
    _centerLine2.width = QGOnePixelLineHeight;
    _centerLine2.X = (self.width - _centerLine1.width*2)/3*2;
    
      [_ActivOrderImage sizeToFit];
    [_ActivOrderLabel sizeToFit];
    
    _ActivOrderImage.X = 0;
    _ActivOrderImage.Y = 0;
    
    _ActivOrderLabel.X = _ActivOrderImage.maxX + BLUThemeMargin*2;
    _ActivOrderLabel.centerY = _ActivOrderImage.centerY;
    
    _ActivOrderView.Y = BLUThemeMargin * 4;
    _ActivOrderView.width = _ActivOrderLabel.maxX;
    _ActivOrderView.height = _ActivOrderImage.maxY;
    
    [_mallOrderImage sizeToFit];
    [_mallOrderLabel sizeToFit];
    
    _mallOrderImage.X = 0;
    _mallOrderImage.Y = 0;
    
    _mallOrderLabel.X = _mallOrderImage.maxX + BLUThemeMargin*2;
    _mallOrderLabel.centerY = _mallOrderImage.centerY;
    
    _mallOrderView.Y = BLUThemeMargin * 4;
    _mallOrderView.width = _mallOrderLabel.maxX;
    _mallOrderView.height = _mallOrderImage.maxY;
    
    _ActivOrderButton.frame = CGRectMake(_centerLine1.maxX, 0, _centerLine1.X, _mallOrderView.bottom + BLUThemeMargin * 4);
    _mallOrderButton.frame = CGRectMake(_centerLine2.maxX, 0, _centerLine1.X, _mallOrderView.bottom + BLUThemeMargin * 4);
    _CourseButton.frame = CGRectMake(0, 0, _centerLine1.X, _mallOrderView.bottom + BLUThemeMargin * 4);
    
    _CourseOrderView.centerX = _CourseButton.centerX;
    _ActivOrderView.centerX = _ActivOrderButton.centerX;
    
    _mallOrderView.centerX = _mallOrderButton.centerX;
    
    _centerLine1.height = _mallOrderButton.height - 2;
    _centerLine1.y = 1;
    _centerLine2.height = _mallOrderButton.height - 2;
    _centerLine2.y = 1;
    
   
    _centerLine1.height = _mallOrderButton.height - 2;
    _centerLine1.y = 1;
    self.cellSize = CGSizeMake(self.contentView.width, _mallOrderView.bottom + BLUThemeMargin * 4);
}


- (void)orderButtonClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(shouldPushOrderVC:)]) {
        [self.delegate shouldPushOrderVC:button];
    }
}

@end
