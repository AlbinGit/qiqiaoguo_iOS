//
//  BLUBrand.h
//  Blue
//
//  Created by Bowen on 14/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUObject.h"

@class BLUBrandMO;

@interface BLUBrand : BLUObject

@property (nonatomic, copy, readonly) NSNumber *brandID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) NSString *initials;
@property (nonatomic, copy, readonly) BLUImageRes *logo;
@property (nonatomic, copy, readwrite) NSNumber *hot;

@property (nonatomic, readonly) NSNumber *logoHeight;
@property (nonatomic, readonly) NSNumber *logoWidth;
@property (nonatomic, readonly) NSString *logoOriginURL;
@property (nonatomic, readonly) NSString *logoThumbURL;

@end
