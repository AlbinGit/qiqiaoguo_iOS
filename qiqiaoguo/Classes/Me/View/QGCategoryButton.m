//
//  QGCategoryButton.m
//  qiqiaoguo
//
//  Created by cws on 16/7/14.
//
//

#import "QGCategoryButton.h"

@interface QGCategoryButton ()

@property (nonatomic, strong)UIView *lineView;

@end

@implementation QGCategoryButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _showLine = YES;
        _lineView = [UIView new];
        _lineView.translatesAutoresizingMaskIntoConstraints = NO;
        _lineView.backgroundColor = QGCellbottomLineColor;
        [self addSubview:_lineView];
        [self setNeedsUpdateConstraints];
    }
    return self;
}

- (void)updateConstraints
{
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_dotView(8)]-0-|"
//                                                                 options:0
//                                                                 metrics:nil
//                                                                   views:NSDictionaryOfVariableBindings(_lineView)]];
//    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[_dotView(8)]"
//                                                                 options:0
//                                                                 metrics:nil
//                                                                   views:NSDictionaryOfVariableBindings(_lineView)]];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.equalTo(@(28));
        make.right.equalTo(self);
        make.width.equalTo(@(QGOnePixelLineHeight));
        
    }];
    
    [super updateConstraints];
}

- (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    _lineView.hidden = !showLine;
}

@end
