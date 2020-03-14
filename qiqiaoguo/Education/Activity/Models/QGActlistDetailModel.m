//
//  QGActlistDetailModel.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/7.
//
//

#import "QGActlistDetailModel.h"




@implementation QGActlistDetailResultModel



@end


@implementation QGActlistDetailModel
+(NSDictionary *)mj_objectClassInArray {
    return @{@"ticketList":@"QGActlistTicketListModel",
             @"applyFieldList":@"QGActlistApplyFieldListModel"};
}


- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return @"我在七巧国发现了一个不错的少儿活动，感兴趣的朋友快来报名吧！";
}

- (NSString *)shareContent {
    return self.title;
}

- (NSURL *)shareImageURL {
    return [NSURL URLWithString:self.coverPicPop];
}

- (NSURL *)shareRedirectURL {
    
    return [NSURL URLWithString:self.sharUrl];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}



@end
@implementation QGActlistTicketListModel


@end

@implementation QGActlistApplyFieldListModel

+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{
             @"value" : @"name",
             
             };
}

@end

@implementation QGActlistQuantityModel



@end
@implementation QGActlistShopInfoModel



@end
@implementation QGActlistDetailDownload

-(NSString *)path
{
    return QGActivetyDetailPath;
}
-(NSString *)method
{
    return @"GET";
}

@end