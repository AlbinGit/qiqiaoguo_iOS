//
//  QGTeacherReginsterCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import "QGTeacherReginsterCell.h"

@implementation QGTeacherReginsterCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
	}
	return self;
}
- (void)p_creatUI
{
	self.titleLabel = ({
		UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(20,0,70,50)];
		label.font = FONT_SYSTEM(16);
		label.text = @"姓名";
		label.textColor = [UIColor blackColor];
		label.textAlignment = NSTextAlignmentLeft;
		[self.contentView addSubview:label];
		label;
	});

	
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
