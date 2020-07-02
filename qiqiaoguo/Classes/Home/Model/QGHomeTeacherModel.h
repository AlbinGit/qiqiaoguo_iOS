//
//  QGHomeTeacherModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGHomeTeacherModel : NSObject
@property (nonatomic,copy) NSString *myID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *resources;
@property (nonatomic,copy) NSString *resource_type;
@property (nonatomic,copy) NSString *cover_img;
@property (nonatomic,copy) NSString *likes_num;
@property (nonatomic,copy) NSString *replies_num;
@property (nonatomic,copy) NSString *teacher_id;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *head_img;
@property (nonatomic,copy) NSString *createdate;
@property (nonatomic,copy) NSString *time_format;

@end

NS_ASSUME_NONNULL_END
