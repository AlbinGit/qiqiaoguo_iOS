//
//  QGSingleItemModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import "QGSingleItemModel.h"

@implementation QGSingleItemModel
+ (NSDictionary *)replacedKeyFromPropertyName {
    return @{@"Id" : @"id"};
}
@end
