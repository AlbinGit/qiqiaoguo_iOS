//
//  BLUUserBlurView.h
//  Blue
//
//  Created by Bowen on 18/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *BLUUserBlurViewMaleImageCacheKey;

UIKIT_EXTERN NSString *BLUUserBlurViewFemaleImageCacheKey;

@interface BLUUserBlurView : UIView

@property (nonatomic, strong) BLUUser *user;

@end
