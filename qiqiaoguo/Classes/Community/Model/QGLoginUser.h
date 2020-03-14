//
//  BLULoginUser.h
//  LongForTianjie
//
//  Created by cws on 16/4/14.
//  Copyright © 2016年 platomix. All rights reserved.
//

#import "BLUUser.h"

@interface QGLoginUser : BLUUser
@property (nonatomic, copy, readonly) NSString *email;
@property (nonatomic, copy, readonly) NSString *pushToken;

@end
