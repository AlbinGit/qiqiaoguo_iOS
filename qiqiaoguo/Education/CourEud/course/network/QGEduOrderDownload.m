//
//  QGEduOrderDownload.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/12.
//
//

#import "QGEduOrderDownload.h"

@implementation QGEduOrderDownload
-(NSString *)path
{
    return QGEduSignOrderDetailsPath;
}
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"shoppingCart":@"QGShoppingCartModel"};
    
}
@end
