//
//  QGPhotoCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import "QGPhotoCell.h"
@interface QGPhotoCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoView;

@end
@implementation QGPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _videoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"post-common-video-indicator"]];
    _videoView.center = _imageView.center;
    [_imageView addSubview:_videoView];
    [_videoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_imageView);
    }];
    _videoView.hidden = YES;
}
- (void)setImageName:(NSString *)imageName{
    
    //设置cell的图片
    _imageName = [imageName copy];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:[UIImage imageNamed:@"children_elegant_ icon2"]];
}

- (void)setShowVideoIcon:(BOOL)showVideoIcon{
    _videoView.hidden = !showVideoIcon;
}

@end
