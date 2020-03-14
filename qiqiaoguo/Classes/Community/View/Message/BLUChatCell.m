//
//  BLUChatCell.m
//  Blue
//
//  Created by Bowen on 27/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUChatCell.h"
#import "BLUContentParagraph.h"
#import "BLUMessageMO.h"
#import "BLUMessageHeader.h"
//#import "BLUGoodMO.h"

@implementation BLUChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        UIView *superview = self.contentView;
        superview.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];

        _avatarButton = [BLUAvatarButton new];
        _avatarButton.backgroundColor = BLUThemeSubTintBackgroundColor;
        [_avatarButton addTarget:self action:@selector(transitToUserAction:) forControlEvents:UIControlEventTouchUpInside];

        _messageView = [UIImageView new];
//        _messageView.cornerRadius = BLUThemeHighActivityCornerRadius * 2;
        _messageView.backgroundColor = [UIColor clearColor];
        
        
        _halfRoundRectView = [UIView new];

        _messageLabel = [UILabel makeThemeLabelWithType:BLULabelTypeContent];

        _sendingIndicator = [[UIActivityIndicatorView alloc] init];
        _sendingIndicator.color = [UIColor colorFromHexString:@"#C9CACB"];

        _failedButton = [UIButton new];
        _failedButton.image = [UIImage imageNamed:@"chat-resend"];
        [_failedButton addTarget:self action:@selector(resendMessageAction:) forControlEvents:UIControlEventTouchUpInside];

        _timeLabel = [UILabel new];
        _timeLabel.textColor = [UIColor colorFromHexString:@"999999"];
        _timeLabel.font = _messageLabel.font;

        [superview addSubview:_avatarButton];
        [superview addSubview:_messageView];
//        [superview addSubview:_halfRoundRectView];
        [superview addSubview:_sendingIndicator];
        [superview addSubview:_failedButton];
        [superview addSubview:_timeLabel];
        [_messageView addSubview:_messageLabel];



        return self;
    }
    return nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    UIView *superview = self.contentView;

    CGSize avatarButtonSize = CGSizeMake(36, 36);
    CGSize halfRoundRectViewSize = CGSizeMake(10, 8);
    CGFloat contentLabelMaxWidth = superview.width - avatarButtonSize.width * 1.5 - halfRoundRectViewSize.width - BLUThemeMargin * 12;
    [_sendingIndicator sizeToFit];
    CGSize indicatorSize = _sendingIndicator.size;

    if (_message.showSendTime) {
        [_timeLabel sizeToFit];
        _timeLabel.y = BLUThemeMargin;
        _timeLabel.centerX = superview.centerX;
    } else {
        _timeLabel.frame = CGRectZero;
    }

    if (_type == BLUChatCellTypeLeft) {
        _avatarButton.x = BLUThemeMargin * 3;
//        _avatarButton.y = BLUThemeMargin * 3;
        _avatarButton.y = _message.showSendTime ? _timeLabel.bottom + BLUThemeMargin * 2 : BLUThemeMargin * 3;
        _avatarButton.size = avatarButtonSize;

        _halfRoundRectView.x = _avatarButton.right + BLUThemeMargin * 2;
        _halfRoundRectView.centerY = _avatarButton.centerY;
        _halfRoundRectView.size = halfRoundRectViewSize;
        _halfRoundRectView.cornerRadius = halfRoundRectViewSize.height / 2;

        CGSize messageLabelSize = [_messageLabel sizeThatFits:CGSizeMake(contentLabelMaxWidth, CGFLOAT_MAX)];
        _messageLabel.x = BLUThemeMargin * 2;
        _messageLabel.y = BLUThemeMargin * 2;
        _messageLabel.size = messageLabelSize;
        UIImage * image = [UIImage imageNamed:@"message_chat_other"];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/8*6)];
        _messageView.image = image;
        _messageView.x = _avatarButton.right + BLUThemeMargin* 2;
        _messageView.y = _avatarButton.y;
        _messageView.size = CGSizeMake(_messageLabel.width + BLUThemeMargin * 5, _messageLabel.height + BLUThemeMargin * 4);
        
        if (_messageView.width < (_messageView.height + BLUThemeMargin * 2)) {
            _messageView.width = _messageView.height + BLUThemeMargin;
            _messageLabel.centerX = _messageView.width / 2.0;
        }
        _messageLabel.centerX = _messageView.width / 2.0 + BLUThemeMargin;
        CGRect indicatorFrame = CGRectMake(_messageView.right + BLUThemeMargin * 2, 0, indicatorSize.width , indicatorSize.height);
        _sendingIndicator.frame = indicatorFrame;
        _sendingIndicator.centerY = _messageView.centerY;

        _failedButton.frame = _sendingIndicator.frame;
    } else {
        _avatarButton.x = superview.width - avatarButtonSize.width - BLUThemeMargin * 3;
//        _avatarButton.y = BLUThemeMargin * 3;
        _avatarButton.y = _message.showSendTime ? _timeLabel.bottom + BLUThemeMargin * 2 : BLUThemeMargin * 3;
        _avatarButton.size = avatarButtonSize;

        _halfRoundRectView.x = superview.width - _avatarButton.width - halfRoundRectViewSize.width - BLUThemeMargin * 5;
        _halfRoundRectView.centerY = _avatarButton.centerY;
        _halfRoundRectView.size = halfRoundRectViewSize;
        _halfRoundRectView.cornerRadius = halfRoundRectViewSize.height / 2;

        CGSize messageLabelSize = [_messageLabel sizeThatFits:CGSizeMake(contentLabelMaxWidth, CGFLOAT_MAX)];
        _messageLabel.x = BLUThemeMargin * 2;
        _messageLabel.y = BLUThemeMargin * 2;
        _messageLabel.size = messageLabelSize;

        _messageView.size = CGSizeMake(_messageLabel.width + BLUThemeMargin * 5, _messageLabel.height + BLUThemeMargin * 4);
        _messageView.x = _messageView.x = _avatarButton.left - BLUThemeMargin * 2 - _messageView.width;
        _messageView.y = _avatarButton.y;
        UIImage * image = [UIImage imageNamed:@"message_chat_me"];
        image = [image stretchableImageWithLeftCapWidth:floorf(image.size.width/2) topCapHeight:floorf(image.size.height/8*6)];
        _messageView.image = image;
        if (_messageView.width < (_messageView.height + BLUThemeMargin * 2)) {
            _messageView.x -= _messageView.height + BLUThemeMargin * 2 - _messageView.width;
            _messageView.width = _messageView.height + BLUThemeMargin * 2;
            _messageLabel.centerX = _messageView.width / 2.0 ;
        }
        
        _messageLabel.centerX = _messageView.width / 2.0 - BLUThemeMargin;

        CGRect indicatorFrame = CGRectMake(_messageView.left - BLUThemeMargin * 2 - indicatorSize.width, 0, indicatorSize.width, indicatorSize.height);
        _sendingIndicator.frame = indicatorFrame;
        _sendingIndicator.centerY = _messageView.centerY;

        _failedButton.frame = _sendingIndicator.frame;
    }
    _avatarButton.cornerRadius = _avatarButton.height / 2;
    _halfRoundRectView.centerY = _avatarButton.centerY;
    if (_avatarButton.height > _messageView.height) {
        _messageView.centerY = _avatarButton.centerY;
    }

    switch (_message.remoteState.integerValue) {
        case BLUMessageMORemoteStateNormal: {
            _sendingIndicator.frame = CGRectZero;
            _failedButton.frame = CGRectZero;
        } break;
            
        case BLUMessageMORemoteStateSending: {
            _failedButton.frame = CGRectZero;
        } break;
        case BLUMessageMORemoteStateSendFailed: {
            _sendingIndicator.frame = CGRectZero;
        } break;
    }

    CGFloat cellBottom = _messageView.bottom > _avatarButton.bottom ? _messageView.bottom : _avatarButton.bottom;
    cellBottom += BLUThemeMargin * 3;
    self.cellSize = CGSizeMake(superview.width, cellBottom);
}

- (void)setModel:(id)model {
    NSParameterAssert([model isKindOfClass:[BLUMessageMO class]]);

    [super setModel:model];

    // Model.
    _message = (BLUMessageMO *)model;

    if (_message.fromUserID.integerValue == [BLUAppManager sharedManager].currentUser.userID) {
        _type = BLUChatCellTypeRight;
    } else {
        _type = BLUChatCellTypeLeft;
    }

    // View
    _avatarButton.image = nil;

    if (_type == BLUChatCellTypeLeft) {
        if (!self.cellForCalcingSize) {
             NSDictionary *dic = @{
                                  BLUUserKeyUserID: _message.fromUserID,
                                  BLUUserKeyNickname:_message.fromUserNickname,
                                  BLUUserKeyGender: _message.fromUserGender,
                                  };
            BLUUser *user = [[BLUUser alloc]initWithDictionary:dic error:nil];
            _avatarButton.user = user;
            
        }
//        _messageView.backgroundColor = BLUThemeMainTintBackgroundColor;
        _messageLabel.textColor = BLUThemeSubDeepContentForegroundColor;
        _messageView.alpha = 1.0;
    } else {
        if (!self.cellForCalcingSize) {
            NSDictionary *dic = @{
                                  BLUUserKeyUserID: _message.fromUserID,
                                  BLUUserKeyNickname:_message.fromUserNickname,
                                  BLUUserKeyGender: _message.fromUserGender,
                                  };
            BLUUser *user = [[BLUUser alloc]initWithDictionary:dic error:nil];
            _avatarButton.user = user;
        }
//        _messageView.backgroundColor = [UIColor colorFromHexString:@"#C9CACB"];
        _messageLabel.textColor = BLUThemeMainTintContentForegroundColor;

    }
    if (_message.fromUserThumbnailAvatarURL.length > 0) {
        _avatarButton.imageURL = [NSURL URLWithString:_message.fromUserThumbnailAvatarURL];
    }
    _halfRoundRectView.backgroundColor = _messageView.backgroundColor;
    _halfRoundRectView.alpha = _messageView.alpha;

    switch (_message.styleType.integerValue) {
        case BLUMessageStyleTypeGoodPrompt: {
                NSString *name = _message.idTitle;
            if (name) {
                NSDictionary *attribute =
                @{NSFontAttributeName: _messageLabel.font,
                  NSForegroundColorAttributeName:
                      [UIColor colorWithRed:0.23 green:0.49 blue:0.95 alpha:1.00],
                  NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
                NSAttributedString *attrStr =
                [[NSAttributedString alloc]
                 initWithString:name attributes:attribute];
                _messageLabel.attributedText = attrStr;
            }

        } break;
        default: {
            _messageLabel.attributedText = nil;
            _messageLabel.text = _message.text;
        } break;
    }

    switch (_message.remoteState.integerValue) {
        case BLUMessageMORemoteStateNormal: {
            [_sendingIndicator stopAnimating];
            _sendingIndicator.hidden = YES;
            _failedButton.hidden = YES;
        } break;
        case BLUMessageMORemoteStateSending: {
            [_sendingIndicator startAnimating];
            _sendingIndicator.hidden = NO;
            _failedButton.hidden = YES;
        } break;
        case BLUMessageMORemoteStateSendFailed: {
            [_sendingIndicator stopAnimating];
            _sendingIndicator.hidden = YES;
            _failedButton.hidden = NO;
        } break;
    }

    if (_message.showSendTime.boolValue) {
        _timeLabel.text = [[NSDateFormatter sharedModelDateFormater] stringFromDate:_message.createDate];
        _timeLabel.hidden = NO;
    } else {
        _timeLabel.text = nil;
        _timeLabel.hidden = YES;
    }
}

- (void)transitToUserAction:(id)sender {
    if (_message.fromUserID) {
        NSDictionary *dict = @{BLUUserKeyUserID: _message.fromUserID};
        if ([self.userTransitionDelegate respondsToSelector:@selector(shouldTransitToUser:fromView:sender:)]) {
            [self.userTransitionDelegate shouldTransitToUser:dict fromView:self sender:self.avatarButton];
        }
    }
}

- (void)resendMessageAction:(id)sender {
    if ([self.delegate respondsToSelector:@selector(shouldResendMessage:fromChatCell:sender:)]) {
        [self.delegate shouldResendMessage:_message fromChatCell:self sender:sender];
    }
}

@end
