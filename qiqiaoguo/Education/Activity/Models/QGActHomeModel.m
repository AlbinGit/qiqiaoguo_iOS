//
//  QGActHomeModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import "QGActHomeModel.h"


@implementation QGActHomeResultModel

+(NSDictionary *)mj_objectClassInArray {
    
    
    return @{@"items":@"QGActHomeModel"};
}

@end


@implementation QGActHomeModel

@end
@implementation QGActHomeHttpDownload

-(NSString *)path
{
    return QGActHomePath;
}
-(NSString *)method
{
    return @"GET";
}




@end