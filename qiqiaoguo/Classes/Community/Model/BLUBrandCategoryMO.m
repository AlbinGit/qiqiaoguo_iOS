//
//  BLUBrandCategoryMO.m
//  
//
//  Created by Bowen on 19/1/2016.
//
//

#import "BLUBrandCategoryMO.h"
#import "BLUBrandCategory.h"

const NSInteger BLUBrandCategoryMOTotalRankCategoryID = 0;
const NSInteger BLUBrandCategoryMONoParentID = 0;

@implementation BLUBrandCategoryMO

//@synthesize objectInteractionDelegate = _objectInteractionDelegate;

- (void)configureWithBrandCategory:(BLUBrandCategory *)category {
    BLUAssertObjectIsKindOfClass(category.categoryID, [NSNumber class]);
    BLUAssertObjectIsKindOfClass(category.name, [NSString class]);

    self.parentID = category.parentID;
    self.categoryID = category.categoryID;
    self.name = category.name;

    if (self.hot.boolValue != YES) {
        self.hot = category.hot;
    } else {
        self.hot = @(YES);
    }

    if (category.logoHeight && category.logoWidth &&
        category.logoThumbURL && category.logoOriginURL) {
        BLUAssertObjectIsKindOfClass(category.logoHeight, [NSNumber class]);
        BLUAssertObjectIsKindOfClass(category.logoWidth, [NSNumber class]);
        BLUAssertObjectIsKindOfClass(category.logoOriginURL, [NSString class]);
        BLUAssertObjectIsKindOfClass(category.logoThumbURL, [NSString class]);

        self.logoHeight = category.logoHeight;
        self.logoWidth = category.logoWidth;
        self.logoOriginURL = category.logoOriginURL;
        self.logoThumbURL = category.logoThumbURL;
    }
}

- (BLUImageRes *)logo {
    if (self.logoHeight && self.logoWidth && self.logoOriginURL && self.logoThumbURL) {
        return [[BLUImageRes alloc] initWithWidth:self.logoWidth.floatValue
                                           height:self.logoHeight.floatValue
                                        originURL:[NSURL URLWithString:(NSString * _Nonnull)self.logoOriginURL]
                                     thumbnailURL:[NSURL URLWithString:(NSString * _Nonnull)self.logoThumbURL]];
    } else {
        return nil;
    }
}

- (void)showModelDetailsFromSender:(id)sender {
//    if ([self.objectInteractionDelegate
//         respondsToSelector:@selector(shouldShowObjectDetails:fromSender:)]) {
//        [self.objectInteractionDelegate
//         shouldShowObjectDetails:self fromSender:sender];
//    }
}

- (NSString *)modelName {
    return self.name;
}

- (NSURL *)modelImageURL {
    if (self.logoThumbURL) {
        NSString *URLString = self.logoThumbURL;
        return [NSURL URLWithString:URLString];
    } else {
        return nil;
    }
}

@end
