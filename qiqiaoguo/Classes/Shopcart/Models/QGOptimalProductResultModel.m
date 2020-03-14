//
//  QGOptimalProductModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGOptimalProductResultModel.h"


@implementation QGOptimalProductHttpDownload

- (NSString *)path {
    
    return QGStoreCityMainPagePath;
    
}

@end
@implementation QGOptimalProductBannerListModel



@end
@implementation QGOptimalProductResultModel
+ (NSDictionary *)mj_objectClassInArray {
    
    return @{@"bannerList":@"QGOptimalProductBannerListModel",@"cateList":@"QGEducateListtModel",@"subjectList":@"QGOptimalProductSubjrctListModel"};
}
@end
