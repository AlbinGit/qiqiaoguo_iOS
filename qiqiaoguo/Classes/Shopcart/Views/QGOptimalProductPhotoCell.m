//
//  QGOptimalProductPhotoCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGOptimalProductPhotoCell.h"

@interface QGOptimalProductPhotoCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation QGOptimalProductPhotoCell

- (void)awakeFromNib {
    self.imageView.layer.borderColor = COLOR(242, 243, 244, 1).CGColor;
    self.imageView.layer.borderWidth = 1;
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = [imageName copy];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
}

@end
