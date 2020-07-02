//
//  QGFindCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/12.
//

#import "QGFindCell.h"
static const CGFloat kPromptImageViewHeight = 32;
static const CGFloat kIndicatorImageViewHeight = 16;

@implementation QGFindCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor =COLOR(242, 243, 244, 1);

		[self p_creatUI];
    }
    return self;
}
-(void)p_creatUI
{
	// Indicator image view
	UIView * bgView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH-30, 62)];
	bgView.backgroundColor = [UIColor whiteColor];
	[self.contentView addSubview:bgView];
		
	self.contentLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15,0, bgView.width,62)];
		label.font = FONT_SYSTEM(16);
//		label.text = @"发解放路健身房房间爱了看见";
		label.textColor = [UIColor colorFromHexString:@"333333"];
		label.textAlignment = NSTextAlignmentLeft;
		[bgView addSubview:label];
		label;
	});
		
	_indicatorImageView = [UIImageView new];
	_indicatorImageView.image = [UIImage imageNamed:@"common-navigation-right-gray-icon"];
	_indicatorImageView.frame = CGRectMake(bgView.width-15-kIndicatorImageViewHeight, (62-kIndicatorImageViewHeight)/2, kIndicatorImageViewHeight, kIndicatorImageViewHeight);
	[bgView addSubview:_indicatorImageView];
	
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
