//
//  QGNewCatalogModel.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import "QGNewCatalogModel.h"

@implementation QGNewCatalogModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
	return @{@"myID":@"id"};
}
+(NSDictionary *)mj_objectClassInArray {
 return @{@"fileList":@"QGfileListModel"};
}
@end

@implementation QGfileListModel
//+(NSDictionary *)mj_objectClassInArray {
// return @{@"fileList":@"QGfileListModel"};
//}

@end
