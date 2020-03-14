//
//  BLUServerNotificationHeader.h
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BLUServerNotificationHeader : UIToolbar

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) BLUSolidLine *separator;

+ (CGFloat)headerHeight;

@end
