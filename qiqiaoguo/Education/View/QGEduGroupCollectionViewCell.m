//
//  QGEduGroupCollectionViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/30.
//
//

#import "QGEduGroupCollectionViewCell.h"

@implementation QGEduGroupCollectionViewCell{
    NSArray *_nameArray;
}


-(void)layoutSubviews {
    
    
    self.groupImageView.layer.cornerRadius= 5.f;
    self.groupImageView.layer.masksToBounds = YES;
    
}


@end
