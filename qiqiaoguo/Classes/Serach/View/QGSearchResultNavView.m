//
//  QGSearchResultNavView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGSearchResultNavView.h"

@interface QGSearchResultNavView ()

@property (nonatomic, strong) UIView *textfieldBackview;
@property (nonatomic, strong) UIImageView *searchimage;
@property (nonatomic, strong) UIView *bottomLine;
@end

@implementation QGSearchResultNavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, Height_TopBar);
        
        _backButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _backButton.image = [[UIImage imageNamed:@"nav-back-icon"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _backButton.contentEdgeInsets = UIEdgeInsetsMake(10,10,10, 10);
        [_backButton sizeToFit];
        
        _textfieldBackview = [UIView new];
        _textfieldBackview.backgroundColor = APPBackgroundColor;
        _textfieldBackview.layer.masksToBounds = YES;
        _textfieldBackview.layer.cornerRadius = 4.0;
        
        _searchimage = [UIImageView new];
        _searchimage.image = [UIImage imageNamed:@"icon_classification_search"];
        
        _searchTextField = [UITextField new];
        [_searchTextField setFont:[UIFont systemFontOfSize:15.0]];
        _searchTextField.returnKeyType = UIReturnKeySearch;
        
        _categoryButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _categoryButton.titleColor = QGTitleColor;
        UIImage *image = [[UIImage imageNamed:@"search-drop-down-icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_categoryButton setImage:image forState:UIControlStateNormal];
        UILabel *label = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        label.text = @"课程";
        [label sizeToFit];
        [_categoryButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - image.size.width - 3, 0, image.size.width + 3)];
        [_categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, label.width + 3, 0, -label.width - 3)];
        
        _messageCenterButton = [UIButton makeThemeButtonWithType:BLUButtonTypeDefault];
        _messageCenterButton.image = [[UIImage imageNamed:@"message_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [_messageCenterButton sizeToFit];
        
        _bottomLine = [UIView new];
        _bottomLine.backgroundColor = QGCellbottomLineColor;
        
        _SearchButton = [UIButton new];
        
        
        [self addSubview:_backButton];
        [self addSubview:_categoryButton];
        [self addSubview:_messageCenterButton];
        [self addSubview:_textfieldBackview];
        [self addSubview:_SearchButton];
        [self addSubview:_bottomLine];
        [_textfieldBackview addSubview:_searchTextField];
        [_textfieldBackview addSubview:_searchimage];
        
        self.searchOptionType = QGSearchOptionTypeCourse;
        
        [self configConstraint];
    }
    return self;
}

- (void)configConstraint{
    CGFloat backButtonwidth = _backButton.width;
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.left.equalTo(self).offset(BLUThemeMargin * 1);
        make.width.equalTo(@(backButtonwidth+BLUThemeMargin));
    }];
    
    
    [_categoryButton sizeToFit];
    CGFloat categoryButtonwidth = _categoryButton.width;
    [_categoryButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.left.equalTo(_backButton.mas_right).offset(BLUThemeMargin * 3);
        make.width.equalTo(@(categoryButtonwidth+BLUThemeMargin));
    }];
    
    [_messageCenterButton sizeToFit];
    CGFloat cancelButtonwidth = _messageCenterButton.width ;
    CGFloat cancelButtonheight = _messageCenterButton.height;
    [_messageCenterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-BLUThemeMargin * 2);
        make.width.equalTo(@(cancelButtonwidth));
        make.height.equalTo(@(cancelButtonheight));
    }];
    
    [_textfieldBackview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.left.equalTo(_categoryButton.mas_right).offset(BLUThemeMargin * 3);
        make.right.equalTo(_messageCenterButton.mas_left).offset(-BLUThemeMargin * 3);
        make.height.equalTo(@(30));
    }];
    
    [_SearchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(10);
        make.left.equalTo(_categoryButton.mas_right).offset(BLUThemeMargin * 3);
        make.right.equalTo(_messageCenterButton.mas_left).offset(-BLUThemeMargin * 3);
        make.height.equalTo(@(30));
    }];
    
    [_searchimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textfieldBackview);
        make.left.equalTo(_textfieldBackview).offset(BLUThemeMargin * 2);
        make.width.height.equalTo(_textfieldBackview.mas_height).offset(-BLUThemeMargin * 3);
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_textfieldBackview);
        make.left.equalTo(_searchimage.mas_right).offset(BLUThemeMargin * 2);
        make.right.equalTo(_textfieldBackview).offset(-BLUThemeMargin * 2);
    }];
    
    [_bottomLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.left.right.equalTo(self);
        make.height.equalTo(@(QGOnePixelLineHeight));
    }];
    
}

- (void)setSearchOptionType:(QGSearchOptionType)searchOptionType{
    
    _searchOptionType = searchOptionType;
    
    switch (searchOptionType) {
        case QGSearchOptionTypeCourse:
        {
            self.categoryButton.title = @"课程";
            self.searchTextField.placeholder = @"搜索 课程";
        }break;
        case QGSearchOptionTypeInstitution:
        {
            self.categoryButton.title = @"机构";
            self.searchTextField.placeholder = @"搜索 机构";
        }break;
        case QGSearchOptionTypeGoods:
        {
            self.categoryButton.title = @"商品";
            self.searchTextField.placeholder = @"搜索 商品";
        }break;
            
        default:
            break;
    }
    
}

#pragma mark - QGPOPViewDelegate

- (void)popViewDidClickButton:(UIButton *)button{
    
    self.searchOptionType = button.tag;
    
}


@end
