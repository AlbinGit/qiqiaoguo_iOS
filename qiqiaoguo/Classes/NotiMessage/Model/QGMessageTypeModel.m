//
//  QGMessageTypeModel.m
//  qiqiaoguo
//
//  Created by cws on 16/6/30.
//
//

#import "QGMessageTypeModel.h"

@implementation QGMessageTypeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"type"            :@"type",
             @"unreadCount"     :@"unread_count",
             @"kefuUserID"      :@"extra.id",
             @"createDate"      :@"createdate",
             @"content"         :@"content",
             @"title"           :@"title",
             };
    
}

@end
