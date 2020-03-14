//
//  BLUUserSimpleTableCell.h
//  Blue
//
//  Created by Bowen on 12/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"

typedef NS_ENUM(NSInteger, BLUUserSimpleTableCellStyle) {
    BLUUserSimpleTableCellStyleTitle = 0,
    BLUUserSimpleTableCellStyleContent,
};

@interface BLUUserSimpleTableCell : BLUCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) BLUSolidLine *leftLine;
@property (nonatomic, strong) BLUSolidLine *rightLine;

@property (nonatomic, assign) BLUUserSimpleTableCellStyle style;

@end
