//
//  QGEduGroupCollectionViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/30.
//
//

#import "QGCourLIstGroupCollectionViewCell.h"

@implementation QGCourLIstGroupCollectionViewCell

-(void)layoutSubviews {

 
   
    
    self.groupImageView.layer.masksToBounds=YES;
    self.groupImageView.layer.cornerRadius=8; //设置为图片宽度的一半出来为圆形
 
    
}
@end
