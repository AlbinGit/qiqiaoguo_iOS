//
//  BLUCirleHotTagNode.m
//  Blue
//
//  Created by cws on 16/4/6.
//  Copyright © 2016年 com.boki. All rights reserved.
//

#import "BLUCirleHotTagNode.h"

@implementation BLUCirleHotTagNode

-(instancetype)initWithTag:(BLUPostTag *)tag
{
    if (self = [super init]) {
        
        _TagImageNode = [[ASNetworkImageNode alloc] initWithWebImage];
        _TagImageNode.URL = tag.face.originURL;
        _TagImageNode.layerBacked = YES;
        
        _TagNode = [ASTextNode new];
        _TagNode.maximumNumberOfLines = 1 ;
        _TagNode.attributedString = [self attributedTag:tag.title];
        _TagNode.layerBacked = YES;
        
        _connetNode = [ASTextNode new];
        _connetNode.maximumNumberOfLines = 2;
        _connetNode.attributedString = [self attributedConnetNode:tag.tagDescription];
        _connetNode.layerBacked = YES;
        
        _joinNode = [ASTextNode new];
        _joinNode.attributedString = [self attributedJoin:[NSString stringWithFormat:@"%ld人参与",(long)tag.joinCount]];
        _joinNode.layerBacked = YES;
        
        _lineNode = [ASDisplayNode new];
        _lineNode.backgroundColor = [UIColor colorFromHexString:@"e5e5e5"],
        _lineNode.layerBacked = YES;
        
        [self addSubnode:_TagImageNode];
        [self addSubnode:_TagNode];
        [self addSubnode:_connetNode];
        [self addSubnode:_joinNode];
        [self addSubnode:_lineNode];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (CGSize)calculateSizeThatFits:(CGSize)constrainedSize {
    CGSize calculatedSize = CGSizeZero;
    if (constrainedSize.width <= 0) {
        constrainedSize.width = [UIScreen mainScreen].bounds.size.width;
    }
    
    float scale = constrainedSize.width/5;
    
    CGFloat requiredHeight = 0;
    
    CGFloat contentWidth = constrainedSize.width;

    
    requiredHeight += BLUThemeMargin * 6;

    requiredHeight += scale;
    
    [_TagNode measure:CGSizeMake(contentWidth - scale - BLUThemeMargin * 5, MAXFLOAT)];
    
//    [_connetNode measure:CGSizeMake(contentWidth - scale - BLUThemeMargin * 5, MAXFLOAT)];
    
    [_joinNode measure:CGSizeMake(contentWidth - scale - BLUThemeMargin * 5, MAXFLOAT)];
    
    calculatedSize = CGSizeMake(constrainedSize.width, requiredHeight);
    
    return calculatedSize;
}


- (void)layout
{
    [super layout];
    
    float scale = self.calculatedSize.width/5;
    
    float viewW = self.frame.size.width;
    
    CGFloat imageX = BLUThemeMargin * 3;
    CGFloat imageY = imageX;
    _TagImageNode.frame = CGRectMake(imageX, imageY,scale, scale);
    _TagImageNode.layer.masksToBounds = YES;
    _TagImageNode.layer.cornerRadius = scale/2;
    
    
    CGSize tagSize =CGSizeMake(_TagNode.calculatedSize.width,_TagNode.calculatedSize.height);
    CGFloat tagX = CGRectGetMaxX(_TagImageNode.frame) + 10;
    CGFloat tagY = CGRectGetMinY(_TagImageNode.frame);
    _TagNode.frame = CGRectMake(tagX, tagY,viewW - imageX * 2 - _TagImageNode.frame.size.width , tagSize.height);
    
    
    CGSize joinSize = CGSizeMake(_joinNode.calculatedSize.width,_joinNode.calculatedSize.height);
    CGFloat joinX = tagX;
    CGFloat joinY = CGRectGetMaxY(_TagImageNode.frame) - joinSize.height + 2;
    _joinNode.frame = CGRectMake(joinX, joinY,viewW - imageX * 2 - _TagImageNode.frame.size.width, joinSize.height);
    
//    CGSize connetSize =CGSizeMake(_connetNode.calculatedSize.width,_connetNode.calculatedSize.height);
    CGFloat connetX = tagX;
    CGFloat connetY = CGRectGetMaxY(_TagNode.frame) + 8;
    CGFloat connetH = CGRectGetMinY(_joinNode.frame) - 4 - CGRectGetMaxY(_TagNode.frame);
    _connetNode.frame = CGRectMake(connetX, connetY, viewW - imageX*2 - _TagImageNode.frame.size.width, connetH);
    
    
    
    _lineNode.frame = CGRectMake(imageX, self.view.frame.size.height - 1, viewW - BLUThemeMargin * 6, 1);
    
}


- (CGFloat)cellVerticalPadding {
    return BLUThemeMargin * 4;
}

- (CGFloat)cellHorizonPadding {
    return BLUThemeMargin * 4;
}

- (CGFloat)contentMargin {
    return BLUThemeMargin * 3;
}

- (CGSize)tagImageSize {
    return CGSizeMake(80, 80);
}

- (CGFloat)joinBackgroundHorizonPadding {
    return BLUThemeMargin * 4;
}

- (CGFloat)joinBackgroundVerticalPadding {
    return BLUThemeMargin * 2;
}



@end




@implementation BLUCirleHotTagNode (Text)

- (NSAttributedString *)attributedTag:(NSString *)Tag {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName:[UIColor colorFromHexString:@"333333"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeLarge)};
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"#%@#",Tag]
                                           attributes:attributed];
}

- (NSAttributedString *)attributedConnetNode:(NSString *)connet {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5];//调整行间距
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"999999"],
      NSFontAttributeName: [UIFont systemFontOfSize:12],
      NSParagraphStyleAttributeName:paragraphStyle};

    
    return [[NSAttributedString alloc] initWithString:connet
                                           attributes:attributed];
}

- (NSAttributedString *)attributedJoin:(NSString *)Join {
    NSDictionary *attributed =
    @{NSForegroundColorAttributeName: [UIColor colorFromHexString:@"c1c1c1"],
      NSFontAttributeName: BLUThemeMainFontWithType(BLUUIThemeFontSizeTypeSmall)};
    
    return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",Join]
                                           attributes:attributed];
}
@end
