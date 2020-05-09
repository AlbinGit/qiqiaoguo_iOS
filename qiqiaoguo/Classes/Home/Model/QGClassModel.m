//
//  QGClassModel.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/9.
//

#import "QGClassModel.h"

@implementation QGClassModel
+(NSDictionary *)mj_objectClassInArray {
 return @{@"sublist":@"QGClassListModel"};
}
@end

@implementation QGClassListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{@"myID" : @"id"};
}

@end
