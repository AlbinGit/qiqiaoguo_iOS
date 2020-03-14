//
//  QGActShopInfoCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/5.
//
//

#import "QGActShopInfoCell.h"

@implementation QGActShopInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopImage.layer.masksToBounds =YES;
    self.shopImage.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
