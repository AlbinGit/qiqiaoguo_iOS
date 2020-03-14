//
//  QGCategoryCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGCategoryCell.h"

@implementation QGCategoryCell

- (void)awakeFromNib {
    // Initialization code
    _categoryTitleLbl.font=FONT_CUSTOM(15);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(QGCategroyModel *)model
{
    _categoryTitleLbl.text = model.name;

    
}

@end
