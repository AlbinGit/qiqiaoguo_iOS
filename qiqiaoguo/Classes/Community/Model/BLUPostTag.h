//
//  BLUPostTag.h
//  Blue
//
//  Created by Bowen on 2/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUObject.h"
#import "BLUShareObject.h"

@class BLUGoodMO, BLUGoodSearchResultMO, BLUGood;

@interface BLUPostTag : BLUObject

@property (nonatomic, assign, readonly) NSInteger tagID;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) BLUImageRes *image;
@property (nonatomic, copy, readonly) BLUImageRes *face;
@property (nonatomic, assign, readonly) BOOL available;
@property (nonatomic, assign) BOOL selected;
@property (nonatomic, assign, readonly) NSInteger postCount;
@property (nonatomic, copy, readonly) NSString *tagDescription;
@property (nonatomic, assign, readonly) NSInteger joinCount;


+ (NSArray *)tagsFromTagTitles:(NSArray *)tagTitles;
+ (NSArray *)tagTitlesFromTags:(NSArray *)tags;

- (NSString *)shortTitle;

+ (instancetype)testTag;

@end

@interface BLUPostTag (Share) <BLUShareObject>

@end

@interface BLUPostTag (Good)

+ (NSArray *)tagsFromGoodMOs:(NSArray *)goodMOs;
+ (NSArray *)tagsFromGoodSearchResultsMOs:(NSArray *)goodSearchResultsMOs;
+ (NSArray *)tagsFromGoods:(NSArray *)goods;
+ (NSArray *)tagsFromBrandCategoryMOs:(NSArray *)brandCategories;

@end
