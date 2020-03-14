//
//  BLUBrandMO.m
//  
//
//  Created by Bowen on 14/1/2016.
//
//

#import "BLUBrandMO.h"
#import "BLUBrand.h"

const NSInteger BLUBrandMOToyHomeFakeID = -1;
NSString *const BLUBrandMOToyHomeFakeInitial = @"0";
NSString *const BLUBrandMOToyHomeReplaceInitial = @"☆";
const NSInteger BLUBrandMOToyHomeFakeSection = 0;

@implementation BLUBrandMO

//@synthesize objectInteractionDelegate = _objectInteractionDelegate;

- (void)configureWithBrand:(BLUBrand *)brand {
    NSParameterAssert(brand.brandID.integerValue > 0);
    BLUAssertObjectIsKindOfClass(brand.name, [NSString class]);
    BLUAssertObjectIsKindOfClass(brand.initials, [NSString class]);

    self.brandID = brand.brandID;
    self.name = brand.name;
    self.initials = brand.initials;
    self.fake = @(NO);

    if (self.hot.boolValue != YES) {
        self.hot = brand.hot;
    } else {
        self.hot = @(YES);
    }

    if (brand.logoHeight && brand.logoWidth &&
        brand.logoOriginURL && brand.logoThumbURL) {
        BLUAssertObjectIsKindOfClass(brand.logoHeight, [NSNumber class]);
        BLUAssertObjectIsKindOfClass(brand.logoWidth, [NSNumber class]);
        BLUAssertObjectIsKindOfClass(brand.logoOriginURL, [NSString class]);
        BLUAssertObjectIsKindOfClass(brand.logoThumbURL, [NSString class]);

        self.logoHeight = brand.logoHeight;
        self.logoWidth = brand.logoWidth;
        self.logoOriginURL = brand.logoOriginURL;
        self.logoThumbURL = brand.logoThumbURL;
    }
}

+ (void)createFaleBrandForToyHomeIfNeeded {
    BLUBrandMO *brandMO = [BLUBrandMO MR_findFirstByAttribute:@"brandID" withValue:@(BLUBrandMOToyHomeFakeID)];
    if (brandMO == nil) {
        brandMO = [BLUBrandMO MR_createEntity];
    }
    [brandMO configureAsFakeBrandForToyHome];
}

- (void)configureAsFakeBrandForToyHome {
    self.brandID = @(BLUBrandMOToyHomeFakeID);
    self.initials = BLUBrandMOToyHomeFakeInitial;
    self.name = @"Toy home header";
    self.fake = @(YES);
}

- (BLUImageRes *)logo {
    if (self.logoHeight && self.logoWidth && self.logoOriginURL && self.logoThumbURL) {
        return [[BLUImageRes alloc] initWithWidth:self.logoWidth.floatValue
                                           height:self.logoHeight.floatValue
                                        originURL:[NSURL URLWithString:(NSString * _Nonnull)self.logoOriginURL]
                                     thumbnailURL:[NSURL URLWithString:(NSString * _Nonnull)self.logoThumbURL]];
    }
    
    return nil;
    
}

#pragma mark - ToyHomeGuideItemModel

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

//- (void)showModelDetailsFromSender:(id)sender {
//    if ([self.objectInteractionDelegate respondsToSelector:@selector(shouldShowObjectDetails:fromSender:)]) {
//        [self.objectInteractionDelegate shouldShowObjectDetails:self fromSender:sender];
//    }
//}

@end
