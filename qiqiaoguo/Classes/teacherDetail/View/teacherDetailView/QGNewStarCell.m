//
//  QGNewStarCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import "QGNewStarCell.h"
@interface QGNewStarCell()
@property (nonatomic,strong) UILabel *starLabel;

@end

@implementation QGNewStarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
	}
	return self;
}
- (void)p_creatUI
{
	self.starLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(15,0,100,67)];
		label.font = [UIFont boldSystemFontOfSize:48];
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});

	UIImageView * starImg = [[UIImageView alloc]initWithFrame:CGRectMake(_starLabel.right+15, 10, SCREEN_WIDTH-_starLabel.right-15-15, 47)];
	[self.contentView addSubview:starImg];
	starImg.image = [UIImage imageNamed:@"star"];

}
- (void)setStarStr:(NSString *)starStr
{
	_starStr = starStr;
	_starLabel.attributedText = [self attributedStringWithString:[NSString stringWithFormat:@"%@ 星",_starStr]];
}

/*
 *  @param aString aString description
 *
 *  @return return value description
 */
- (NSMutableAttributedString *)attributedStringWithString:(NSString *)aString
{
    //数字放大处理
    NSArray * arr = [aString componentsSeparatedByString:@" "];
    NSString * aString1 = arr[0];
    NSString * aString2 = arr[1];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString: aString];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, aString1.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"333333"] range:NSMakeRange(aString1.length, aString2.length+1)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:48] range:NSMakeRange(0, aString1.length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:18] range:NSMakeRange(aString1.length, aString2.length+1)];
    return attributedString;
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
