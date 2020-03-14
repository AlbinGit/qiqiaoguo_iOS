//  QGQGEduFristVideoListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/30.
//
//

#import "QGEduFristActivityCell.h"
@interface QGEduFristActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
@implementation QGEduFristActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.imageView.layer.masksToBounds=YES;
    self.imageView.layer.cornerRadius=8; //设置为图片宽度的一半出来为圆形
}
- (void)setImageName:(NSString *)imageName{
    
    _imageName = [imageName copy];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
}

@end
