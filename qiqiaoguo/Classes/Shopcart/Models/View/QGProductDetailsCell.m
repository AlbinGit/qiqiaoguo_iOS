//
//  QGProductDetailsCell.m
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/17.
//
//

#import "QGProductDetailsCell.h"

@implementation QGProductDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 5;
    _name.font=  [UIFont fontWithName:@"Heiti SC" size:16];
    [_storeBtnClick setTitleFont:[UIFont fontWithName:@"Heiti SC" size:16]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
