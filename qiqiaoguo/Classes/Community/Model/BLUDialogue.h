//
//  BLUDialogue.h
//  Blue
//
//  Created by Bowen on 26/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUDialogue : BLUObject

@property (nonatomic, assign, readonly) NSInteger dialogueID;
@property (nonatomic, copy, readonly) NSDate *createDate;
@property (nonatomic, copy, readonly) NSDate *lastTime;
@property (nonatomic, assign, readonly) NSInteger unreadCount;
@property (nonatomic, copy, readonly) NSString *lastMessage;
@property (nonatomic, copy, readonly) BLUUser *fromUser;

@property (nonatomic, copy, readonly) NSString *targetName;
@property (nonatomic, assign, readonly) NSInteger targetID;
@property (nonatomic, copy, readonly) NSString *targetImage;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat heigth;

@end

@interface BLUDialogue (Test)

+ (instancetype)testDialogue;

@end
