//
//  BLUChatCell.h
//  Blue
//
//  Created by Bowen on 27/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCell.h"
#import "BLUUserTransitionProtocal.h"

typedef NS_ENUM(NSInteger, BLUChatCellType) {
    BLUChatCellTypeLeft = 0,
    BLUChatCellTypeRight,
};

@class BLUMessageMO, BLUChatCell, BLUGoodMO;

@protocol BLUChatCellProtocol <NSObject>

- (void)shouldResendMessage:(BLUMessageMO *)message
               fromChatCell:(BLUChatCell *)chatCell
                     sender:(id)sender;

@end

@interface BLUChatCell : BLUCell

@property (nonatomic, strong) BLUAvatarButton *avatarButton;
@property (nonatomic, strong) UIImageView *messageView;
@property (nonatomic, strong) UIView *halfRoundRectView;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIActivityIndicatorView *sendingIndicator;
@property (nonatomic, strong) UIButton *failedButton;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) BLUMessageMO *message;

@property (nonatomic, assign) BLUChatCellType type;

@property (nonatomic, weak) id <BLUUserTransitionDelegate> userTransitionDelegate;
@property (nonatomic, weak) id <BLUChatCellProtocol> delegate;

@end
