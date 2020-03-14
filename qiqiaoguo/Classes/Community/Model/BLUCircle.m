//
//  BLUCircle.m
//  Blue
//
//  Created by Bowen on 19/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUCircle.h"
#import "BLUCircleMO.h"

NSString * const BLUCircleKeyCircle = @"circle";
NSString * const BLUCircleKeyCircleID = @"circleID";

@implementation BLUCircle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"circleID": @"circle_id",
             @"name": @"name",
             @"slogan": @"slogan",
             @"circleDescription": @"description",
             @"postCount": @"post_count",
             @"followedUserCount": @"followed_user_count",
             @"logo": @"logo",
             @"category": @"category",
             @"createDate": @"create_date",
             @"didFollowCircle": @"is_follow_circle",
             @"circleColor": @"circle_colour",
             @"unreadPostCount": @"new_post_count",
             @"shouldVisible": @"title_visible_status",
             @"priority": @"sort_weight",
             
             };
}

+ (NSValueTransformer *)logoJSONTransformer {
    return [self imageResJSONTransformer];
}

+ (NSValueTransformer *)circleColorJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *circleColorStr, BOOL *success, NSError *__autoreleasing *error) {
        return [UIColor colorFromHexString:circleColorStr];
    } reverseBlock:^id(UIColor *color, BOOL *success, NSError *__autoreleasing *error) {
        return color.hexString;
        
    }];
}

+ (BLUCircle *)circleFromCircleMO:(BLUCircleMO *)circleMO {
    NSMutableDictionary *circleDict = [NSMutableDictionary new];
    if (circleMO.circleID != nil) {
        circleDict[@"circleID"] = circleMO.circleID;
    }
    
    if (circleMO.name != nil) {
        circleDict[@"name"] = circleMO.name;
    }
    
    if (circleMO.slogan != nil) {
        circleDict[@"slogan"] = circleMO.slogan;
    }
    
    if (circleMO.circleDescription != nil) {
        circleDict[@"circleDescription"] = circleMO.circleDescription;
    }
    
    if (circleMO.postCount != nil) {
        circleDict[@"postCount"] = circleMO.postCount;
    }
    
    if (circleMO.followedUserCount) {
        circleDict[@"followedUserCount"] = circleMO.followedUserCount;
    }
    
    if (circleMO.logoThumb) {
        BLUImageRes *logo = [[BLUImageRes alloc] initWithDictionary:@{BLUImageResKeyThumbnailURL: [NSURL URLWithString:circleMO.logoThumb]} error:nil];
        if (logo != nil) {
            circleDict[@"logo"] = logo;
        }
    }
    
    if (circleMO.createDate) {
        circleDict[@"createDate"] = circleMO.createDate;
    }
    
    if (circleMO.didFollowCircle) {
        circleDict[@"didFollowCircle"] = circleMO.didFollowCircle;
    }
    
    if (circleMO.unreadPostCount) {
        circleDict[@"unreadPostCount"] = circleMO.unreadPostCount;
    }
    
    if (circleMO.shouldVisible) {
        circleDict[@"shouldVisible"] = circleMO.shouldVisible;
    }
    
    if (circleMO.priority) {
        circleDict[@"priority"] = circleMO.priority;
    }
    
    if (circleMO.isFollowRequesting) {
        circleDict[@"isFollowRequesting"] = circleMO.isFollowRequesting;
    }
    
    return [[BLUCircle alloc] initWithDictionary:circleDict error:nil];
}

@end
