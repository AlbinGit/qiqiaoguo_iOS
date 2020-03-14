//
//  QGChatHeaderView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/31.
//
//

#import <UIKit/UIKit.h>

@interface QGChatHeaderView : UIView

@property (nonatomic, strong) UIImageView *goodImageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *sendButton;

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets containerInsets;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) CGFloat elementSpacing;

@property (nonatomic, strong) id good;

- (instancetype)initWithGoodMO:(id)good;

@end
