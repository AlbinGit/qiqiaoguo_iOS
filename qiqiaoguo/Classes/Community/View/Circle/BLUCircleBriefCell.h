//
//  BLUCircleBriefCell.h
//  Blue
//
//  Created by Bowen on 3/7/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCell.h"
#import "BLUCircleActionProtocal.h"

@class BLUCircleMO, BLUCircle;

@interface BLUCircleBriefCell : BLUCell

@property (nonatomic, weak) id <BLUCircleActionDelegate> circleActionDelegate;

@property (nonatomic, strong) UIButton *circleButton;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *addButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UILabel *unreadPostCountLabel;

@property (nonatomic, strong) BLUCircle *circle;
@property (nonatomic, strong) BLUSolidLine *solidLine;

@property (nonatomic, assign, readonly) BOOL showSeparatorLine;
@property (nonatomic, assign, readonly) BOOL showQuit;
@property (nonatomic, assign, readonly) BOOL showUnreadPostCount;

- (void)            setModel:(id)model
     shouldShowSeparatorLine:(BOOL)showSeparatorLine
              shouldShowQuit:(BOOL)showQuit
   shouldShowUnreadPostCount:(BOOL)showUnreadPostCount
        circleActionDelegate:(id <BLUCircleActionDelegate>)circleActionDelegate;

@end
