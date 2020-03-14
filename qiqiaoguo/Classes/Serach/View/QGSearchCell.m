//
//  QGSearchCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGSearchCell.h"

@interface QGSearchCell ()

@property (nonatomic,strong)NSMutableArray *btnArr;

@end

@implementation QGSearchCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _TagArray = [NSArray new];
        _btnArr = [NSMutableArray new];
        
        return self;
    }
    return nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat contentWidth = [UIScreen mainScreen].bounds.size.width;
    UIButton *btn = [_btnArr lastObject];
    self.cellSize = CGSizeMake(contentWidth,CGRectGetMaxY(btn.frame)+15);
}

- (void)setTagArray:(NSArray *)TagArray
{
    _TagArray = TagArray;
    [_btnArr removeAllObjects];
    [self removeAllView];
    [self configUI];
    
}

- (void)configUI
{
    for (int i = 0; i<_TagArray.count; i++) {
//        BLUPostTag *tag = _TagArray[i];
        UIButton *btn = ({
            UIButton *btn =[UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:_TagArray[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [btn.layer setBorderColor:[UIColor grayColor].CGColor];
            [btn.layer setBorderWidth:0.5];
            [btn.layer setMasksToBounds:YES];
            btn.contentEdgeInsets = UIEdgeInsetsMake(2,8, 2, 8);
            [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
                if ([self.searchDelegate
                     respondsToSelector:@selector(searchWithKeyword:)]) {
                    [self.searchDelegate searchWithKeyword:_TagArray[i]];
                }
            }];
            btn;
        });
        [btn sizeToFit];
        [self configBtnFrameWithBtn:btn];
    }
}

- (void)configBtnFrameWithBtn:(UIButton *)btn
{
    CGFloat btnX = 10;
    CGFloat btnY = 15;
    CGFloat btnW = btn.frame.size.width;
    CGFloat btnH = btn.frame.size.height;
    
    if (_btnArr.count > 0) {
        UIButton *lastBtn = [_btnArr lastObject];
        btnX = CGRectGetMaxX(lastBtn.frame) + 10;
        btnY = lastBtn.frame.origin.y;
    }
    if ([UIScreen mainScreen].bounds.size.width - btnX < btn.frame.size.width + 10) {
        btnY += (btn.frame.size.height + 15);
        btnX = 10;
    }
    btn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    [_btnArr addObject:btn];
    btn.layer.cornerRadius = btnH/2;
    [self.contentView addSubview:btn];
}

- (void)removeAllView
{
    for (UIView *view in self.contentView.subviews) {
        [view removeFromSuperview];
    }
}

@end
