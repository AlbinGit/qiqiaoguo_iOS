//
//  QGNewTeacherLessonModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGNewTeacherLessonModel : NSObject
@property (nonatomic,copy) NSString *course_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *createdate;
@property (nonatomic,copy) NSString *access_count;
@property (nonatomic,copy) NSString *ico_name;
@property (nonatomic,copy) NSString *course_class_id;
@property (nonatomic,copy) NSString *cover_path;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *sign_count;
@property (nonatomic,copy) NSString *section_count;
@property (nonatomic,copy) NSString *teacher_name;
@property (nonatomic,copy) NSString *teacher_id;
@property (nonatomic,copy) NSString *good_comment_rate;
@property (nonatomic,copy) NSString *is_buy;
@property (nonatomic,copy) NSArray *tagList;
@property (nonatomic,copy) NSString *teacher_head_img;


@property (nonatomic,copy) NSString *already_study_rate;//已学习比例
@property (nonatomic,copy) NSString *already_study_section_count;//已学习章节
@property (nonatomic,copy) NSString *is_comment;
@property (nonatomic,copy) NSString *share_url;


@end


@interface QGTeacherTagModel : NSObject
@property (nonatomic,copy) NSString *tag_name;
@property (nonatomic,copy) NSString *tag_id;
@end

NS_ASSUME_NONNULL_END
