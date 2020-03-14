//
//  BLUPostTag.m
//  Blue
//
//  Created by Bowen on 2/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostTag.h"
//#import "BLUGoodSearchResultMO.h"
//#import "BLUGoodMO.h"
//#import "BLUGood.h"
#import "BLUBrandCategoryMO.h"

static const NSInteger BLUPostTagShortTitleLength = 1116;

@implementation BLUPostTag

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tagID":      @"post_tag_id",
             @"title":      @"post_tag_name",
             @"postCount":  @"post_count",
             @"image":      @"image",
             @"face":       @"face",
             @"tagDescription":       @"post_tag_description",
             @"joinCount":       @"join_count",
             };
}

+ (NSValueTransformer *)imageJSONTransformer {
    return [self imageResJSONTransformer];
}

+ (NSValueTransformer *)faceJSONTransformer {
    return [self imageResJSONTransformer];
}

+ (NSArray *)tagsFromTagTitles:(NSArray *)tagTitles {

    NSMutableArray *tags = [NSMutableArray new];

    [tagTitles enumerateObjectsUsingBlock:^(NSString *title,
                                            NSUInteger idx,
                                            BOOL * _Nonnull stop) {

        NSParameterAssert([title isKindOfClass:[NSString class]]);

        NSDictionary *tagDict = @{@"tagID": @(0),
                                  @"title": title};

        BLUPostTag *tag = [[BLUPostTag alloc]
                           initWithDictionary:tagDict error:nil];

        NSParameterAssert(tag);

        [tags addObject:tag];
    }];

    return tags;
}

+ (NSArray *)tagTitlesFromTags:(NSArray *)tags {

    NSMutableArray *tagTitles = [NSMutableArray new];

    [tags enumerateObjectsUsingBlock:^(BLUPostTag *tag,
                                       NSUInteger idx,
                                       BOOL * _Nonnull stop) {

        NSParameterAssert([tag isKindOfClass:[BLUPostTag class]]);

        NSString *title = tag.title;

        NSParameterAssert(title);

        [tagTitles addObject:title];
    }];

    return tagTitles;
}

- (NSString *)shortTitle {
    if (self.title.length > BLUPostTagShortTitleLength) {
        NSString *str = [self.title substringWithRange:NSMakeRange(0, BLUPostTagShortTitleLength)];
        return [NSString stringWithFormat:@"%@...", str];
    } else {
        return self.title;
    }
}

+ (instancetype)testTag {
    NSDictionary *dict = @{
                           @"tagID": @(1),
                           @"title": @"Toys",
                           };
    return [[BLUPostTag alloc] initWithDictionary:dict error:nil];
}

@end

@implementation BLUPostTag (Share)

- (BLUShareObjectType)objectType {
    return BLUShareObjectTypeTag;
}

- (NSString *)shareTitle {
    NSString *title = NSLocalizedString(@"post-tag.share-title-count-%@-tag-%@",
                                        @"Share tag title");
    return [NSString stringWithFormat:title, @(self.postCount), self.title];

}

- (NSString *)shareContent {
    return NSLocalizedString(@"post-tag.share-content", @"Share tag content");
}

- (NSURL *)shareRedirectURL {
    NSString *str = [NSString stringWithFormat:@"%@/posttag/share/post_tag_id/%@",[[BLUServer sharedServer] baseURLString], @(self.tagID)];
//    NSLog(@"%@",str);
    return [NSURL URLWithString:str];
}

- (NSURL *)shareImageURL {
    return self.image.originURL;
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}

@end

@implementation BLUPostTag (Good)

+ (NSArray *)tagsFromGoodMOs:(NSArray *)goodMOs {
//    NSMutableArray *titles = [NSMutableArray new];
//    for (BLUGoodMO *goodMO in goodMOs) {
//        if (![goodMO.name isEmpty]) {
//            NSString *name = goodMO.name;
//            [titles addObject:name];
//        }
//    }
//    return [BLUPostTag tagsFromTagTitles:titles];
    return nil;
}

+ (NSArray *)tagsFromGoodSearchResultsMOs:(NSArray *)goodSearchResultsMOs {
//    NSMutableArray *titles = [NSMutableArray new];
//    for (BLUGoodSearchResultMO *good in goodSearchResultsMOs) {
//        if (![good.name isEmpty]) {
//            NSString *name = good.name;
//            [titles addObject:name];
//        }
//    }
//    return [BLUPostTag tagsFromTagTitles:titles];
    return nil;
}

+ (NSArray *)tagsFromGoods:(NSArray *)goods {
//    NSMutableArray *titles = [NSMutableArray new];
//    for (BLUGood *good in goods) {
//        if (![good.name isEmpty]) {
//            NSString *name = good.name;
//            [titles addObject:name];
//        }
//    }
//    return [BLUPostTag tagsFromTagTitles:titles];
    return nil;
}

+ (NSArray *)tagsFromBrandCategoryMOs:(NSArray *)brandCategories {
    NSMutableArray *titles = [NSMutableArray new];
    for (BLUBrandCategoryMO *category in brandCategories) {
        if (![category.name isEmpty]) {
            NSString *name = category.name;
            [titles addObject:name];
        }
    }
    return [BLUPostTag tagsFromTagTitles:titles];
}

@end
