//
//  QGSearchScreeningView.m
//  qiqiaoguo
//
//  Created by cws on 16/9/6.
//
//

#import "QGSearchScreeningView.h"

@interface QGSearchScreeningView ()

@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, weak)QGVerticalButton *oldButton;

@end

@implementation QGSearchScreeningView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _categoryButton = [QGVerticalButton new];
    _categoryButton.title = @"全部分类";
    _categoryButton.tag = 0;
    _categoryButton.image = [UIImage imageNamed:@"category-icon"];
    [_categoryButton setImage:[UIImage imageNamed:@"category-select-icon"] forState:UIControlStateSelected];
    [_categoryButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_categoryButton];
    
    _nearButton = [QGVerticalButton new];
    _nearButton.tag = 1;
    _nearButton.title = @"全部区域";
    _nearButton.image = [UIImage imageNamed:@"near-icon"];
    [_nearButton setImage:[UIImage imageNamed:@"near-select-icon"] forState:UIControlStateSelected];
    [_nearButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_nearButton];
    
    
    _smartButton = [QGVerticalButton new];
    _smartButton.tag = 2;
    _smartButton.title = @"智能排序";
    _smartButton.image = [UIImage imageNamed:@"smart-icon"];
    [_smartButton setImage:[UIImage imageNamed:@"smart-select-icon"] forState:UIControlStateSelected];
    [_smartButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_smartButton];
    
    _lineView = [UIView new];
    _lineView.backgroundColor = QGlineBackgroundColor;
    [self addSubview:_lineView];
    
    
    [_categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
    [_nearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_categoryButton.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
    [_smartButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self);
        make.left.equalTo(_nearButton.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/3));
    }];
    
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self);
        make.height.equalTo(@(QGOnePixelLineHeight));
    }];
}

- (void)setSelectModel:(QGScreeningModel *)selectModel{
    
    _selectModel = selectModel;
    _categoryButton.selected = NO;
    _nearButton.selected = NO;
    _smartButton.selected = NO;
    
    if (selectModel) {
        _oldButton.title = selectModel.name;
        if (!_oldButton) {
            _categoryButton.title = selectModel.name;
        }
    }
    
}


- (void)resetOptions{
    _categoryButton.title = @"全部分类";
    _nearButton.title = @"全部区域";
    _smartButton.title = @"智能排序";
}

- (void)buttonClick:(UIButton *)button{
    
//    if (_oldButton == button) {
//        return;
//    }
    _oldButton.selected = NO;
    button.selected = YES;
    _oldButton = button;
    
    
    if ([self.delegate respondsToSelector:@selector(buttonShouldClick:)]) {
        [self.delegate buttonShouldClick:button];
    }
    
}

@end
