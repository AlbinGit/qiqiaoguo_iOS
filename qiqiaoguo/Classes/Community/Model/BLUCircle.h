//
//  BLUCircle.h
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString * const BLUCircleKeyCircle;
UIKIT_EXTERN NSString * const BLUCircleKeyCircleID;

@class BLUImageRes, BLUCategory, BLUCircleMO;

@interface BLUCircle : BLUObject

@property (nonatomic, assign, readonly) NSInteger circleID;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *slogan;
@property (nonatomic, copy, readonly) NSString *circleDescription;
@property (nonatomic, assign, readonly) NSInteger postCount;
@property (nonatomic, assign, readonly) NSInteger followedUserCount;
@property (nonatomic, copy, readonly) BLUImageRes *logo;
@property (nonatomic, copy, readonly) BLUCategory *category;
@property (nonatomic, copy, readonly) UIColor *circleColor;
@property (nonatomic, assign) BOOL didFollowCircle;
@property (nonatomic, assign, readonly) BOOL shouldVisible;
@property (nonatomic, assign) NSInteger unreadPostCount;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) BOOL isFollowRequesting;


+ (BLUCircle *)circleFromCircleMO:(BLUCircleMO *)circleMO;

@end
