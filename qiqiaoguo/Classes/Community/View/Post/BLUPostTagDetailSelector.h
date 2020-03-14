//
//  BLUPostTagDetailSelector.h
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BLUPostTagDetailSelectedIndex) {
    BLUPostTagDetailSelectedIndexAll = 0,
    BLUPostTagDetailSelectedIndexRecommended,
};

@interface BLUPostTagDetailSelector : UIControl

@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *recommendedLabel;

@property (nonatomic, strong) UIView *allBottomLine;
@property (nonatomic, strong) UIView *recommendedBottomLine;
@property (nonatomic, strong) UIView *separator;

@property (nonatomic, strong) UIToolbar *backgroundView;

@property (nonatomic, assign) BLUPostTagDetailSelectedIndex selectedIndex;

+ (CGFloat)postTagDetailSelectorHeight;

@end
