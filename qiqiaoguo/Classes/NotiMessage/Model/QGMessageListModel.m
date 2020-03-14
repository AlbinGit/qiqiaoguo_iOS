//
//  QGMessageListModel.m
//  qiqiaoguo
//
//  Created by cws on 16/7/5.
//
//

#import "QGMessageListModel.h"

@implementation QGMessageListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"title"            :@"title",
             @"content"          :@"content",
             @"imageURL"         :@"cover",
             @"createDate"       :@"createdate",
             @"messageID"        :@"id",
             @"type"             :@"type",
             };
    
}

@end
