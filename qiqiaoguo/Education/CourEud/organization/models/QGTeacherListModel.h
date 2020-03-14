//
//  QGTeacherListModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.


#import <Foundation/Foundation.h>

@interface QGTeacherListModel : NSObject

/**教师ID号*/
@property (nonatomic,copy)NSString *teacher_id;
@property (nonatomic,copy)NSString *head_img;
/**教师名称*/
@property (nonatomic,copy)NSString *name;
/**教师介绍*/

/**教师签名*/
@property (nonatomic,copy)NSString *signature;
@property (nonatomic,copy)NSString *org_id;
@property (nonatomic,strong) NSArray *tagList;

@end
