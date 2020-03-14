//
//  BLUMessageCategory.h
//  Blue
//
//  Created by Bowen on 13/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

typedef NS_ENUM(NSInteger, BLUMessageCategoryType) {
    BLUMessageCategoryTypeDynamic = 1,
    BLUMessageCategoryTypeChat,
};

@interface BLUMessageCategory : BLUObject

@property (nonatomic, assign, readonly) BLUMessageCategoryType type;
@property (nonatomic, copy, readonly) NSString *content;
@property (nonatomic, copy, readonly) NSDate *lastTime;
@property (nonatomic, assign, readonly) NSInteger unreadCount;
@property (nonatomic, copy, readonly) BLUUser *targetUser;

@end

@interface BLUMessageCategory (Test)

+ (BLUMessageCategory *)testDynamicCategory;
+ (BLUMessageCategory *)testChatCategory;

@end
