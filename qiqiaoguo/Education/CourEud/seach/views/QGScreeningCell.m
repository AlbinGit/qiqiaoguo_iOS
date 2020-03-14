//
//  QGScreeningCell.m
//  qiqiaoguo
//
//  Created by cws on 16/9/12.
//
//

#import "QGScreeningCell.h"

@interface QGScreeningCell ()

@property (nonatomic, copy) NSMutableArray *dataArr;
@property (nonatomic,weak) UIButton *selectButton;

@end

static const CGFloat leftMargin = 10;
static const CGFloat rightMargin = 10;
static const CGFloat buttonHeight = 40;

@implementation QGScreeningCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        _dataArr = [NSMutableArray array];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat maxWidth = MQScreenW/3*2 - leftMargin - rightMargin;
    UIButton *lastbtn = nil;
    for (int i = 0; i < _dataArr.count; i++) {
        
        UIButton *button = _dataArr[i];
        button.X = i%3 > 0 ? leftMargin +(maxWidth/3  - QGOnePixelLineHeight)*(i%3)  : leftMargin ;
        button.width = maxWidth/3;
        button.Y = i/3 < 1 ? 0 : (buttonHeight - QGOnePixelLineHeight) * (i/3);
        button.height = buttonHeight;
        lastbtn = button;
    }
    
    self.cellSize = CGSizeMake(0,lastbtn.maxY + 5);
}

- (void)setScreeningModel:(QGScreeningModel *)model{
    _ScreeningModel = model;
    
    for (UIButton *btn in _dataArr) {
        [btn removeFromSuperview];
    }
    
    [_dataArr removeAllObjects];
    
    for (QGScreeningModel * submodel in model.subListArray) {
        UIButton *button = [UIButton new];
        button.tag = submodel.courseID;
        button.title = submodel.name;
        button.titleFont = [UIFont systemFontOfSize:14.0];
        button.titleColor = QGCellContentColor;
        [button setTitleColor:QGMainRedColor forState:UIControlStateSelected];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button.selected = self.selectID == submodel.courseID ? YES : NO;
        [self addBorderToButton:button index:0];
        [self.contentView addSubview:button];
        [_dataArr addObject:button];
    }
}

- (void)addBorderToButton:(UIButton *)button index:(NSInteger)index{
    
    CALayer *layer = [button layer];
    layer.borderColor = [QGCellContentColor CGColor];
    layer.borderWidth = QGOnePixelLineHeight;
    
}

- (void)buttonClick:(UIButton *)button{
    for (QGScreeningModel * submodel in _ScreeningModel.subListArray){
        if (_ScreeningModel.courseID == button.tag) {
            if (self.btnBlock) {
                _btnBlock(_ScreeningModel);
            }
            return;
        }
        
        if (submodel.courseID == button.tag) {
            if (self.btnBlock) {
                _btnBlock(submodel);
            }
            return;
        }
    }
    
    
}

@end
