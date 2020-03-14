//
//  BLUAPSetting.h
//  Blue
//
//  Created by Bowen on 12/10/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUAPSetting : BLUObject

@property (nonatomic, assign) NSInteger settingID;
@property (nonatomic, assign) BOOL systemNotification;
@property (nonatomic, assign) BOOL commentNotification;
@property (nonatomic, assign) BOOL likeNotification;
@property (nonatomic, assign) BOOL followNotification;
@property (nonatomic, assign) BOOL privateMessageNotification;

- (instancetype)initWithSystemNotification:(BOOL)systemNotification commentNotification:(BOOL)commentNotification likeNotification:(BOOL)likeNotification followNitification:(BOOL)followNotification privateMessageNotification:(BOOL)privateMessageNotification;

@end
