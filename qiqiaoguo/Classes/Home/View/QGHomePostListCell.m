//
//  QGHomePostListCellTableViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/19.
//
//

#import "QGHomePostListCell.h"

#import "QGPhotoCell.h"
@interface QGHomePostListCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

/**
 *  昵称
 */
@property (nonatomic, weak) UILabel *nameLabel;
/**
 *  正文
 */
@property (nonatomic, weak) UILabel *introLabel;

@property (nonatomic,strong) UIButton *name;

@property (nonatomic,strong) UIButton *acc;
@property (nonatomic,strong) UIButton *comm;
@property (nonatomic,strong) UILabel *line;

@property (nonatomic,strong) UIImageView *imageview;

@property (nonatomic,strong) UIView *imageBGView;

@end

@implementation QGHomePostListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_video"]];
        _imageview = view;
        [self addSubview:_imageview];
        

        //创建标题
        UILabel *nameLabel = [UILabel makeThemeLabelWithType:BLULabelTypeTitle];
        nameLabel.textColor = QGTitleColor;
        [self.contentView addSubview:nameLabel];
        self.nameLabel = nameLabel;
        
        // 创建正文
        UILabel *introLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];
        introLabel.textColor = [UIColor colorFromHexString:@"666666"];
        introLabel.numberOfLines = 2;
        [self.contentView addSubview:introLabel];
        self.introLabel = introLabel;
        
        UIButton *btn = [[UIButton alloc] init];
        [btn setBackgroundImage:[UIImage resizedImage:@"Label_box"] forState:(UIControlStateNormal)];
        [btn setTitleFont:[UIFont systemFontOfSize:10]];
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        [btn setTitleColor:[UIColor colorFromHexString:@"999999"] forState:(UIControlStateNormal)];
        btn.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentCenter;
        [self.contentView addSubview:btn];
        self.name = btn;
        
        UIButton *acc = [[UIButton alloc] init];
        [acc setImage:[UIImage imageNamed:@"reading_icon"] forState:(UIControlStateNormal)];
        
        acc.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [acc  setTitleColor:[UIColor colorFromHexString:@"999999"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:acc];
        self.acc = acc;
        [_acc setTitleFont:[UIFont systemFontOfSize:12]];
        
        UIButton *com =[[UIButton alloc] init];
        com.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [com setImage:[UIImage imageNamed:@"评论"] forState:(UIControlStateNormal)];
        [com  setTitleColor:[UIColor colorFromHexString:@"999999"] forState:(UIControlStateNormal)];
        [self.contentView addSubview:com];
        
        self.comm = com;
        [_comm setTitleFont:[UIFont systemFontOfSize:12]];
        
        
        _imageBGView = [UIView new];
        [self.contentView addSubview:_imageBGView];
        
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = APPBackgroundColor;
        [self.contentView addSubview:line];
        self.line = line;
        
    }
    return self;
}


- (void)ViewClick{
    if (self.block) {
        _block();
    }
}


-(void)setPostframe:(QGPostListFrameModel *)postframe {
    _postframe = postframe;
    
    _introLabel.text =_postframe.post.content;
    _nameLabel.text = postframe.post.title;
    
    _introLabel.hidden = _postframe.post.content.length < 1;
    
    [_name setTitle:postframe.post.circle_name];
    
    [_acc setTitle:postframe.post.access_count];
    
    [_comm setTitle:postframe.post.comment_count];

    _line.frame = _postframe.lineF;
    _imageBGView.frame = _postframe.iconF;
    _nameLabel.frame = _postframe.nameF;
    _introLabel.frame = _postframe.introF;
    _comm.frame = postframe.commentbtnF;
    _name.frame = _postframe.circlenameF;
    _acc.frame = _postframe.accessbtnF;
    _imageview.frame = _postframe.videoImageF;
    
    int imageCount = postframe.post.imageList.count > 3 ? 3 : postframe.post.imageList.count;
    
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = _postframe.iconF.size.height;
    CGFloat imageH = _postframe.iconF.size.height;
    
    for (UIView *view in _imageBGView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < imageCount; i++) {
        QGImageListModel *model = postframe.post.imageList[i];
        UIImageView *imageview = [[UIImageView alloc] init];
        [imageview sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
        imageview.clipsToBounds = YES;
        imageview.contentMode =  UIViewContentModeScaleAspectFill;
        imageview.frame = CGRectMake(imageX, imageY, imageH, imageH);
        imageX += (imageW + 12);
        [_imageBGView addSubview:imageview];
        
        if (postframe.post.is_video.integerValue == 1) {
            UIImageView *video = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"video_icon"]];
            [imageview addSubview:video];
            video.x = (imageview.width - video.width)/2;
            video.Y = (imageview.height - video.height)/2;
        }
        
        if (i == 2 && postframe.post.imageList.count > 3) {
            UIView *labelBGView = [UIView new];
            labelBGView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
            labelBGView.cornerRadius = 4;
            [imageview addSubview:labelBGView];

            UILabel *label = [UILabel makeThemeLabelWithType:BLULabelTypeSub];
            NSString *str = [NSString stringWithFormat:@"共%ld张",postframe.post.imageList.count];
            label.attributedText = [[NSAttributedString alloc]initWithString:str attributes:
                                    @{NSFontAttributeName:
                                          BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall),
                                      NSForegroundColorAttributeName:
                                          [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:1],
                                      }];
            [imageview addSubview:label];
            [label sizeToFit];
            label.frame = CGRectMake(imageview.width - label.width - 8, imageview.height - label.height -6, label.width, label.height);
            labelBGView.frame = CGRectMake(imageview.width - label.width - 12, imageview.height - label.height - 8, label.width + 8, label.height + 4);

        }
    }
    

}

@end
