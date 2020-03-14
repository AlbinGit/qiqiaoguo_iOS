//
//  QGMessageListCell.m
//  qiqiaoguo
//
//  Created by cws on 16/7/4.
//
//

#import "QGMessageListCell.h"
#import "QGMessageListModel.h"


@interface QGMessageListCell ()

@property (nonatomic, strong)UIView * titleBottomLine;
@property (nonatomic, strong) UILabel *MessageTitle;
@property (nonatomic, strong) UILabel *MessageContent;
@property (nonatomic, strong) UIImageView *MessageImage;
@property (nonatomic, strong) UIImageView *nextImage;


@property (nonatomic, strong) UIView *container;

@end

@implementation QGMessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        UIView *superview = self.contentView;
        superview.backgroundColor = APPBackgroundColor;
        
        _container = [UIView new];
        _container.layer.borderWidth = QGOnePixelLineHeight;
        _container.layer.borderColor = [QGCellbottomLineColor CGColor];
        _container.backgroundColor = BLUThemeMainTintBackgroundColor;
        _container.cornerRadius = BLUThemeHighActivityCornerRadius;
        [superview addSubview:_container];
        
        _MessageTitle = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        _MessageTitle.textColor = QGTitleColor;
        _MessageTitle.numberOfLines = 1;
        [_container addSubview:_MessageTitle];
        
        _MessageContent = [UILabel makeThemeLabelWithType:BLULabelTypeMainContent];
        _MessageContent.textColor = QGMainContentColor;
        _MessageContent.numberOfLines = 2;
        
        [_container addSubview:_MessageContent];
        
        _titleBottomLine = [UIView new];
        _titleBottomLine.backgroundColor = QGCellbottomLineColor;
        [_container addSubview:_titleBottomLine];
        
        
        _MessageImage = [UIImageView new];
        [_container addSubview:_MessageImage];
        
        _nextImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Cell_arrow"]];
        [_container addSubview:_nextImage];
        
        return self;
    }
    return nil;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat containerWidth = [UIScreen mainScreen].bounds.size.width - BLUThemeMargin * 6;
    
    _container.x = BLUThemeMargin * 3;
    _container.width = containerWidth;
    

    CGSize titleSize = [_MessageTitle sizeThatFits:CGSizeMake(containerWidth - BLUThemeMargin * 6 , MAXFLOAT)];
    _MessageTitle.x = BLUThemeMargin * 3;
    _MessageTitle.y = BLUThemeMargin * 2;
    _MessageTitle.size = titleSize;
    _MessageTitle.width = containerWidth - BLUThemeMargin * 6;

    _titleBottomLine.x = 0;
    _titleBottomLine.y = _MessageTitle.bottom + BLUThemeMargin * 2;
    _titleBottomLine.height = QGOnePixelLineHeight;
    _titleBottomLine.width = containerWidth;
    
    
    [_nextImage sizeToFit];
    _nextImage.X = _container.width - _nextImage.width - BLUThemeMargin *2;
    _nextImage.Y = _titleBottomLine.bottom + BLUThemeMargin *10;
    
    _container.height = _nextImage.bottom + BLUThemeMargin *10;
    
    CGRect imageFrame = [self imageFrame];
    
    _MessageImage.frame = imageFrame;
    _MessageImage.centerY = _nextImage.centerY;
    
    CGSize contentSize = [_MessageContent sizeThatFits:CGSizeMake(_container.width - _MessageImage.width -  _nextImage.width - BLUThemeMargin * 8 , MAXFLOAT)];
    
    _MessageContent.x = _MessageImage.maxX + BLUThemeMargin * 3;
    _MessageContent.centerY = _nextImage.centerY;
    _MessageContent.size = contentSize;

    _container.height += BLUThemeMargin;
    self.cellSize = CGSizeMake(self.contentView.width, _container.bottom);
}

- (CGRect)imageFrame{
    QGMessageListModel *messageModel = self.model;
    CGRect size = CGRectZero;
    if (messageModel.imageURL.length > 0) {
        switch (self.messageListType) {
            case QGMessageListTypeCard:
            {
                size = CGRectMake(BLUThemeMargin * 3, _titleBottomLine.bottom + BLUThemeMargin * 7, 80, 40);
            }break;
            case QGMessageListTypeOrder:
            {
                size = CGRectMake(BLUThemeMargin * 3, _titleBottomLine.bottom + BLUThemeMargin * 3, 80, 80);
            }break;
            case QGMessageListTypeActivity:
            {
                size = CGRectMake(BLUThemeMargin * 3, _titleBottomLine.bottom + BLUThemeMargin * 6, 80, 50);
            }break;
            default:
                break;
        }
    }
    return size;
}

#pragma mark - Model

- (void)setModel:(id)model {
    [super setModel:model];
    QGMessageListModel *messageModel = model;
    _MessageTitle.text = messageModel.title;
    _MessageContent.text = messageModel.content;
    _MessageImage.image = [UIImage imageNamed:@"message-card-icon"];
    if (messageModel.imageURL.length > 0) {
        [_MessageImage sd_setImageWithURL:[NSURL URLWithString:messageModel.imageURL]];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];

}


@end
