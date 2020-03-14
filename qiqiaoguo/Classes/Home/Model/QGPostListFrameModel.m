//
//  QGPostListFrameModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/19.
//
//

#import "QGPostListFrameModel.h"

@implementation QGPostListFrameModel


- (void)setPost:(QGPostListModel *)post {
    _post = post;
    CGFloat padding = 8;
    CGFloat padding1 = 12;
    
    
    if (post.is_video.integerValue == 1) {
        
        UIImageView *view = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"ic_video"]];
        
        _videoImageF = CGRectMake(12, 11, view.width, view.height);
    }
    
    CGFloat w = post.is_video.integerValue == 1 ? _videoImageF.size.width + 4 : 0;
    
    CGSize nameSize =  [self sizeWithString:_post.title font:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];

   _nameF = CGRectMake(12 + w, 8, MQScreenW- 24-w
                        , nameSize.height);
    
    CGSize infosize =  [self sizeWithString:_post.content font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(MQScreenW-2*padding, 40)];
    _introF = CGRectMake(padding1, CGRectGetMaxY(_nameF) +padding, MQScreenW-30, infosize.height);
    
    
    /**
     *有图列表
     */
    
  CGSize namesize  =[self sizeWithString:_post.circle_name font:[UIFont systemFontOfSize:14] maxSize:CGSizeMake(200, 30)];
    
    CGFloat h = 0;
    if (_post.imageList.count) {
        
        CGFloat iconfY = _post.content.length > 0 ? CGRectGetMaxY(_introF)+padding : CGRectGetMaxY(_nameF)+padding;
        CGFloat imageHeight = (MQScreenW - padding1 * 4)/3;
        _iconF = CGRectMake(padding1,iconfY, MQScreenW-padding1*2, imageHeight);
        
        h = CGRectGetMaxY(_iconF) +padding;
    }else if(_post.content.length < 1){
        h = CGRectGetMaxY(_nameF) +padding;
    }else{
        h = CGRectGetMaxY(_introF) +padding;
    }
    _circlenameF = CGRectMake(padding1, h, namesize.width, nameSize.height);
    
    _commentbtnF = CGRectMake(MQScreenW-padding1-60, h, 60, 20);
    
    _accessbtnF = CGRectMake(MQScreenW-padding1-120, h, 60, 20);
    _lineF = CGRectMake(0,CGRectGetMaxY(self.accessbtnF) + padding, MQScreenW, 0.5);
    _cellHeight = CGRectGetMaxY(_lineF);
    
}
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};

    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

@end
