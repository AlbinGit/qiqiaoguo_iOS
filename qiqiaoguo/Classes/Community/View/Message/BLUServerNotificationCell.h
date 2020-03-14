//
//  BLUServerNotificationCell.h
//  Blue
//
//  Created by Bowen on 3/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"
#import "BLUServerNotification.h"

@class BLUServerNotificationMO;

@interface BLUServerNotificationCell : BLUCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) BLUSolidLine *separator;
@property (nonatomic, strong) BLUServerNotification *notificaton;
@property (nonatomic, assign) BOOL showSeparator;

@end
