//
//  BLUPostTagTitleView.h
//  Blue
//
//  Created by Bowen on 9/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BLUPostTag;

@interface BLUPostTagTitleView : UIView

@property (nonatomic, strong) BLUPostTag *postTag;
@property (nonatomic, strong) UILabel *postTagLabel;
@property (nonatomic, strong) UILabel *postCountLabel;

+ (CGFloat)postTagTitleViewHeight;

@end
