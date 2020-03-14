//
//  BLULogistics.h
//  Blue
//
//  Created by Bowen on 7/3/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLULogistics : BLUObject

@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, strong, readonly) NSArray *details;
@property (nonatomic, strong, readonly) BLUImageRes *logo;
@property (nonatomic, strong, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSString *imageCover;

@end
