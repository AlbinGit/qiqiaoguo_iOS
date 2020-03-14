//
//  BLUCategory.h
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

//class Category(BlueModel):
//category_id = PrimaryKeyField(unique=True)
//create_date = DateTimeField(default=datetime.datetime.now())
//name = CharField(index=True, unique=True)
//# category 1: 1 logo
//logo = ForeignKeyField(Image, unique=True)
//description = CharField(null=True)
//circle_count = IntegerField(default=0)

@class BLUImageRes;

@interface BLUCategory : BLUObject

@property (nonatomic, assign, readonly) NSInteger categoryID;
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy, readonly) BLUImageRes *logo;
@property (nonatomic, copy, readonly) NSString *categoryDescription;
@property (nonatomic, assign, readonly) NSInteger circleCount;
@property (nonatomic, copy, readonly) NSDate *createDate;

@end
