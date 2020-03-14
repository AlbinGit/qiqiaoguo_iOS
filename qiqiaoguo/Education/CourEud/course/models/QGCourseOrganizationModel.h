//
//  QGCourseOrganizationModel.h
//  LongForTianjie
//
//  Created by Albin on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGCourseOrganizationModel : NSObject

/**城市*/
@property(nonatomic,copy)NSString *city;
/**机构ID*/
@property(nonatomic,copy)NSString *org_id;
/**机构名称*/
@property(nonatomic,copy)NSString *name;
/**区域*/
@property(nonatomic,copy)NSString *area;
/**地址*/
@property(nonatomic,copy)NSString *address;
/**电话*/
@property(nonatomic,copy)NSString *tel;
/**省份*/
@property(nonatomic,copy)NSString *province;
/**图标*/
@property(nonatomic,copy)NSString *head_img;
/**我到机构的距离*/
@property(nonatomic,copy)NSString *distance;

@end
