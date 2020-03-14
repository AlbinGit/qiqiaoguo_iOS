//
//  QGActivOrderModel.m
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGActivOrderModel.h"

@implementation QGActivOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return
    @{
      @"mallOrder":         @"item",
      @"activID":           @"activityInfo.id",
      @"activTitle":        @"activityInfo.title",
      @"coverPicOrgImage":  @"activityInfo.coverPicOrg",
      @"typeName":          @"activityInfo.type_name",
      };
}

+ (NSValueTransformer *)mallOrderJSONTransformer {
    return [self makeDicModelTransformer:[QGMallOrderModel class]];
}

@end
