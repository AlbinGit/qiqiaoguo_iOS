//
//  QGSearchPromptHistoryHeader.m
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGSearchPromptHistoryHeader.h"

@implementation QGSearchPromptHistoryHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _buttonInsets = UIEdgeInsetsMake(BLUThemeMargin * 2, BLUThemeMargin * 2,
                                         BLUThemeMargin * 2, BLUThemeMargin * 2);
        
        _clearButton = [UIButton new];
        //        _clearButton.backgroundColor = [UIColor randomColor];
        _clearButton.backgroundImage = [UIImage imageNamed:@"seach-clear-history"];
        // TODO: 添加图片
        
        [self.contentView addSubview:_clearButton];
    }
    return self;
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

- (void)updateConstraints {
    [_clearButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@(-self.buttonInsets.right));
        make.centerY.equalTo(self.contentView);
    }];
    [super updateConstraints];
}
@end
