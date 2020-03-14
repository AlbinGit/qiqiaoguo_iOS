//
//  BLUCircleCarouseAndTaglCell.m
//  Blue
//
//  Created by cws on 16/4/5.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUCircleCarouselAndTagCell.h"
#import "SDWebImageManager.h"

@interface BLUCircleCarouselAndTagCell ()

@property (nonatomic, strong) BLUTagView *tagView;
@property (nonatomic, strong) NSArray *tags;

@end


@implementation BLUCircleCarouselAndTagCell

#pragma mark - Cell size

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds=YES;
        self.contentView.backgroundColor = [UIColor clearColor];
        UIView *bgView=[[UIView alloc] initWithFrame:self.frame];
        bgView.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = bgView;
        _tagView = [[BLUTagView alloc]init];
        _tagView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_tagView];
        

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    CGRect ad_rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    if (self.ads) {
        ad_rect = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.width * 5.0 / 9.0);
    }
    CGRect tag_rect = CGRectMake(rect.origin.x, ad_rect.origin.y+ad_rect.size.height, rect.size.width, rect.size.height - ad_rect.size.height);
    
    [self setPageViewFrame:ad_rect];
    _tagView.frame = tag_rect;
}

#pragma mark - Model

- (void)setTagModel:(id)model {
    self.tags = (NSArray *)model;
    
    if (!self.cellForCalcingSize) {
        [_tagView removeAllViews];
        [self initheadview];
        
        @weakify(self);
        [self.tags enumerateObjectsUsingBlock:^(BLUPostTag *ptag, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            
            UIView *hottag = [self createTagView:ptag withTag:idx];
            
            [_tagView addView:hottag];
        }];
        [_tagView setNeedsLayout];
        [_tagView layoutIfNeeded];
    }

}

-(UIView*) createTagView:(BLUPostTag*)ptag withTag:(NSInteger)iTag
{
    UIView *htv = [UIView new];
    
    htv.layer.masksToBounds=YES;
    
    UIImageView *iv= [UIImageView new];
    [iv sd_setImageWithURL:ptag.face.originURL];
    [htv addSubview:iv];
    
    
    
    UILabel *tv = [UILabel new];
    [htv addSubview:tv];
    tv.numberOfLines = 1;
    tv.font = [UIFont systemFontOfSize:11];
    tv.translatesAutoresizingMaskIntoConstraints = NO;
    tv.text =[NSString stringWithFormat:@"#%@#",ptag.title];
    tv.textAlignment = NSTextAlignmentCenter;
    tv.backgroundColor=[UIColor clearColor];
    tv.textColor = [UIColor grayColor];
    tv.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    UIButton *button = [UIButton new];
    button.backgroundColor = [UIColor clearColor];
    button.tag = iTag;
    button.frame = htv.frame;
    [button addTarget:self action:@selector(transitionTagAction:) forControlEvents:UIControlEventTouchUpInside];
    [htv addSubview:button];
    return htv;
}

- (void) initheadview
{
    UILabel *tv = [[UILabel alloc]init];
    tv.font = [UIFont fontWithName:@"STHeitiTC-Light" size:16];
    tv.text = @"热门话题";
    tv.textColor = [UIColor colorFromHexString:@"#999999"];
    tv.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tagView addHeadView:tv];
//    tv.frame = CGRectMake([BLUCurrentTheme leftMargin] * 2, 5, 80 , 30);
//    _tagLabel = tv;
    
    UIButton *btn =[UIButton new];
    btn.titleFont = [UIFont fontWithName:@"STHeitiSC-Light" size:14];
    btn.backgroundColor=[UIColor clearColor];
    [btn setTitle:@"更多"];
    [btn setTitleColor:BLUThemeMainColor];
    btn.tag = -1;
    [btn sizeToFit];
    [self.tagView addHeadView:btn];
    
    [btn addTarget:self action:@selector(transitionMoreAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)transitionTagAction:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(shouldTransitWithPostTag:fromView:sender:)]) {
        
        BLUPostTag *ptag = nil;
        if(button.tag >=0 && button.tag < self.tags.count)
        {
            ptag =self.tags[button.tag];
        }
        [self.delegate shouldTransitWithPostTag:ptag fromView:self sender:button];
    }
}

- (void)transitionMoreAction:(UIButton *)button {
    
    if ([self.delegate respondsToSelector:@selector(shouldTransMoreTagFromView:sender:)]) {
        
        [self.delegate shouldTransMoreTagFromView:self sender:button];
    }
}


@end
