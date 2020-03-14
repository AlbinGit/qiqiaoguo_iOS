//
//  BLUCircleFollowHeader.h
//  Blue
//
//  Created by Bowen on 7/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLUCircleFollowHeaderDelegate.h"

@interface BLUCircleFollowHeader : UIToolbar

@property (nonatomic, strong) UILabel *promptLabel;
@property (nonatomic, strong) UIButton *changeButton;
@property (nonatomic, weak) id <BLUCircleFollowHeaderDelegate> headerDelegate;

- (NSAttributedString *)attributedRecommendedUser;
- (NSAttributedString *)attributedChange;
- (void)tapAndChange:(id)sender;

@end
