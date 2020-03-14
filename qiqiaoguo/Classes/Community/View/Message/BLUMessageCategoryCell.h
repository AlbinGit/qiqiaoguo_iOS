//
//  BLUMessageCategoryCell.h
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"
#import "QGMessageTypeModel.h"

@class BLUMessageCategoryMO;

@interface BLUMessageCategoryCell : BLUCell

@property (nonatomic, strong) UIImageView *messageImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageCountLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) BLUSolidLine *solidLine;

//@property (nonatomic, strong) BLUMessageCategoryMO *messageCategory;
@property (nonatomic, strong) QGMessageTypeModel *messageModel;

@end
