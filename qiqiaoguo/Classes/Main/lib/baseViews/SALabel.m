//
//  SALabel.m
//  SaleAssistant
//
//  Created by Albin on 14-8-25.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import "SALabel.h"

@interface SALabel ()

@property (nonatomic,copy)SALabelClickBlock click;

@end

@implementation SALabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self createBaseLabel];
    }
    return self;
}

- (void)createBaseLabel
{
    self.backgroundColor = [UIColor clearColor];
    self.numberOfLines = 0;
}

//创建一个UILabel
+ (SALabel *)createLabelWithRect:(CGRect)r
                    andWithColor:(UIColor *)c
                     andWithFont:(CGFloat)f
                    andWithAlign:(NSTextAlignment)a
                    andWithTitle:(NSString *)t {
    
    SALabel *mLabel = [[SALabel alloc] initWithFrame:r];
    mLabel.backgroundColor = CLEARCOLOR;
    mLabel.textAlignment   = a;
    mLabel.text            = t;
    mLabel.textColor       = c;
//    mLabel.font            = [UIFont systemFontOfSize:f];
    mLabel.font            = FONT_CUSTOM(f);
    //DFPShaoNvW5-GB
    mLabel.numberOfLines   = 1;
    
    return mLabel;
}

//点击事件
- (void)addClick:(SALabelClickBlock)click;
{
    self.userInteractionEnabled = YES;
    _click = click;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(_click)
    {
        _click(self);
    }
}


// 根据内容大小设置Label
- (void)setFrameWithPoint:(CGPoint)point text:(NSString *)text
{
    self.text = text;
    CGSize size = [SAUtils getCGSzieWithText:self.text width:10000 height:10000 font:self.font];
    self.frame = CGRectMake(point.x, point.y, size.width, size.height);
}

// 根据内容大小设置Label(固定宽度)
- (void)setFrameWithPoint:(CGPoint)point width:(CGFloat)width text:(NSString *)text
{
//   ÷ self.text = [text isNull:text];
    CGSize size = [SAUtils getCGSzieWithText:self.text width:width height:10000 font:self.font];
    self.frame = CGRectMake(point.x, point.y, size.width, size.height);
}
// 根据内容大小设置Label(固定宽度,有最大高度)
- (void)setFrameWithPoint:(CGPoint)point width:(CGFloat)width maxHeight:(CGFloat)maxHeight text:(NSString *)text
{
//    self.text = [text isNull:text];
    CGSize size = [SAUtils getCGSzieWithText:self.text width:width height:10000 font:self.font];
    if (size.height > maxHeight) {
        self.frame = CGRectMake(point.x, point.y, size.width, maxHeight);
    }
    else
    {
        
        self.frame = CGRectMake(point.x, point.y, size.width, size.height);
        
    }
    
}
// 根据内容大小设置Label(固定高度,有最大宽度)
- (void)setFrameWithPoint:(CGPoint)point maxWidth:(CGFloat)maxWidth Height:(CGFloat)height text:(NSString *)text
{
//    self.text = [text isNull:text];
    CGSize size = [SAUtils getCGSzieWithText:self.text width:maxWidth height:height font:self.font];
    if (size.width > maxWidth) {
        self.frame = CGRectMake(point.x, point.y, maxWidth, height);
    }
    else
    {
        self.frame = CGRectMake(point.x, point.y, size.width, height);
    }
}

// 添加下划线
- (void)addUnderLineWithText:(NSString *)text
{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    self.attributedText = content;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (void)drawTextInRect:(CGRect)rect{
    [super drawTextInRect:rect];
    
    CGSize textSize = [[self text] sizeWithFont:[self font]];
    CGFloat strikeWidth = textSize.width;
    CGRect lineRect;
    CGFloat origin_x;
    CGFloat origin_y = 0.0;
    
    
    if ([self textAlignment] == NSTextAlignmentRight) {
        
        origin_x = rect.size.width - strikeWidth;
        
    } else if ([self textAlignment] == NSTextAlignmentCenter) {
        
        origin_x = (rect.size.width - strikeWidth)/2 ;
        
    } else {
        
        origin_x = 0;
    }
    
    
    if (self.lineType == LineTypeUp) {
        
        origin_y =  2;
    }
    
    if (self.lineType == LineTypeMiddle) {
        
        origin_y =  rect.size.height/2;
    }
    
    if (self.lineType == LineTypeDown) {//下画线
        
        origin_y = rect.size.height - 2;
    }
    
    lineRect = CGRectMake(origin_x ,origin_y, strikeWidth, 1);
    
    if (self.lineType != LineTypeNone) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGFloat R, G, B, A;
        UIColor *uiColor = self.lineColor;
        CGColorRef color = [uiColor CGColor];
        int numComponents = CGColorGetNumberOfComponents(color);
        
        if( numComponents == 4)
        {
            const CGFloat *components = CGColorGetComponents(color);
            R = components[0];
            G = components[1];
            B = components[2];
            A = components[3];
            
            CGContextSetRGBFillColor(context, R, G, B, 1.0);
            
        }
        
        CGContextFillRect(context, lineRect);
    }
}

@end
