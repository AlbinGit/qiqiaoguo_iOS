//
//  QGSlideClassficationCollectionViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import "QGSlideClassficationCollectionViewCell.h"

@implementation QGSlideClassficationCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        [self p_createUI];
    }
    return self;
}
- (void)p_createUI
{
    self.backgroundColor=PL_COLOR_255;
    _titleName=[[UILabel alloc]init];
    _titleName.frame=self.bounds;
    _titleName.textAlignment=NSTextAlignmentCenter;
    _titleName.font=[UIFont systemFontOfSize:17];
    _titleName.textColor=PL_COLOR_160;
    [self.contentView addSubview:_titleName];
    

}
@end
