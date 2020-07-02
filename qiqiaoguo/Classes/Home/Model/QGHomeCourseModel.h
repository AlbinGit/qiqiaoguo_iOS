//
//  QGHomeCourseModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGHomeCourseModel : NSObject
@property (nonatomic,copy) NSString *course_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *createdate;
@property (nonatomic,copy) NSString *ico_name;
@property (nonatomic,copy) NSString *course_class_id;
@property (nonatomic,copy) NSString *cover_path;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *sign_count;
@property (nonatomic,copy) NSString *section_count;
@property (nonatomic,copy) NSString *teacher_name;
@property (nonatomic,copy) NSString *teacher_id;

@property (nonatomic,copy) NSString *is_buy;
@property (nonatomic,copy) NSString *is_new;
@property (nonatomic,copy) NSString *is_hot;

@end

NS_ASSUME_NONNULL_END
