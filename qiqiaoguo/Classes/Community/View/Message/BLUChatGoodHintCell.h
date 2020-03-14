//
//  BLUChatGoodHintCell.h
//  Blue
//
//  Created by Bowen on 23/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUCell.h"

@interface BLUChatGoodHintCell : BLUCell

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets containerInsets;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat elementSpacing;

@end
