//
//  QGActlistHomeModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/6.
//
//

#import "QGActlistHomeModel.h"

@implementation QGActlistHomeModel

//+ (NSDictionary *)mj_replacedKeyFromPropertyName
//{
//    return @{@"activityid" : @"id"};
//}

@end
@implementation QGActlistHomeResultModel

+(NSDictionary *)mj_objectClassInArray {
    
    
    return @{@"items":@"QGActlistHomeModel"};
}

@end

@implementation QGActlistHomeDownload

-(NSString *)path
{
    return QGActivityHomeListPath;
}

@end


@implementation QGUserActivDownload

-(NSString *)path
{
    return QGCollectionActivListPath;
}

@end


@implementation QGUserPartActivDownload
-(NSString *)path
{
    return QGUserActivityListPath;
}
@end