//
//  BLUUserNavCell.h
//  Blue
//
//  Created by Bowen on 14/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"

typedef NS_ENUM(NSInteger, BLUUserNavType) {
    BLUUserNavTypePost = 0,
    BLUUserNavTypeCommented,
    BLUUserNavTypeCollection,
    BLUuserNavTypeUserOrders,
    BLUUserNavTypeMall,
    BLUUserNavTypeSetting,
    BLUUserNavTypeCount,
};

@interface BLUUserNavCell : BLUCell

@property (nonatomic, assign) BLUUserNavType navType;
@property (nonatomic, assign) BOOL showSeparatorLine;

@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@end
