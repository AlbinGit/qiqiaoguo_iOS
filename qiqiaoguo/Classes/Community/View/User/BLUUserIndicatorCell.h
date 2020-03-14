//
//  BLUUserIndicatorCell.h
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"

@interface BLUUserIndicatorCell : BLUCell

@property (nonatomic, assign) BOOL shouldShowIndicator;
@property (nonatomic, strong) NSURL *avatarURL;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) NSString *infoType;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, assign) BOOL showSeparatorLine;

@end
