//
//  QGOrgAllCourseModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import <Foundation/Foundation.h>
#import "QGCourseInfoModel.h"
@interface QGOrgAllCourseModel : NSObject

/**课程ID*/
@property (nonatomic,copy)NSString *course_id;
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,copy)NSString *per_page;
@property (nonatomic,copy)NSString *current_page;
@property (nonatomic,copy)NSString *total_page;

@property (nonatomic,copy)NSString *total_count;

@end

