//
//  QGVerticalButton.m
//  qiqiaoguo
//
//  Created by cws on 16/9/7.
//
//

#import "QGVerticalButton.h"

@implementation QGVerticalButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.titleFont = [UIFont systemFontOfSize:14];
        self.titleColor = QGMainContentColor;
        [self setTitleColor:QGMainRedColor forState:UIControlStateSelected];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2 + 8;
    self.imageView.center = center;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + 10;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = UITextAlignmentCenter;
}

@end
