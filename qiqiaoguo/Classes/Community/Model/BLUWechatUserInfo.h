//
//  BLUWechatUserInfo.h
//  Blue
//
//  Created by Bowen on 18/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

@interface BLUWechatUserInfo : BLUObject

@property (nonatomic, copy, readonly) NSString *openID;
@property (nonatomic, copy, readonly) NSString *unionID;
@property (nonatomic, copy, readonly) NSString *nickname;
@property (nonatomic, assign, readonly) NSInteger sex;
@property (nonatomic, copy, readonly) NSString *avatarURLString;

@end
