//
//  QGNearActSignCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import "QGActSignCell.h"

@implementation QGActSignCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell
{
    self.contentView.backgroundColor = [UIColor whiteColor];
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    
     [self.contentView addSubview:backImageView];
     backImageView.userInteractionEnabled = YES;
    _titLabel = [[UILabel alloc] init];
    _titLabel.font = [UIFont systemFontOfSize:16];
    [backImageView addSubview:_titLabel];
    
    _textField = [[UITextField alloc] init];
    _textField.font = [UIFont systemFontOfSize:15];
     _textField.returnKeyType = UIReturnKeyDone;
    [backImageView addSubview:_textField];
    
     UILabel *line = [[UILabel alloc] init];
     line.frame =  CGRectMake(0, 49, MQScreenW, 1);
     line.backgroundColor =APPBackgroundColor;
     [backImageView addSubview:line];

}

- (void)setSignModel:(QGNearActSignModel *)signModel
{     
      _signModel = signModel;
      _titLabel.text = [NSString stringWithFormat:@"%@:",_signModel.name];
      CGRect  rect = [QGCommon rectForString:_titLabel.text withFont:16 WithWidth:MQScreenW];
     _titLabel.frame = CGRectMake(18, 0, rect.size.width+5, 50);
     _textField.frame = CGRectMake(_titLabel.maxX +5, 0, 200, 50);
    
}




@end
