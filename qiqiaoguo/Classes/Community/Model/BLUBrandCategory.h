//
//  BLUBrandCategory.h
//  Blue
//
//  Created by Bowen on 19/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUObject.h"

@interface BLUBrandCategory : BLUObject

@property (nullable, nonatomic, retain) NSNumber *parentID;
@property (nullable, nonatomic, retain) NSNumber *categoryID;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) BLUImageRes *logo;
@property (nullable, nonatomic, retain) NSNumber *hot;
@property (nullable, nonatomic, retain) NSArray *subCategories;

@property (nullable, nonatomic, retain) NSString *logoThumbURL;
@property (nullable, nonatomic, retain) NSString *logoOriginURL;
@property (nullable, nonatomic, retain) NSNumber *logoWidth;
@property (nullable, nonatomic, retain) NSNumber *logoHeight;

@end
