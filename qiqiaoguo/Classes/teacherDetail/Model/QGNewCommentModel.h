//
//  QGNewCommentModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGNewCommentModel : NSObject
@property (nonatomic,copy) NSString *myID;
@property (nonatomic,copy) NSString *teacher_id;
@property (nonatomic,copy) NSString *course_id;
@property (nonatomic,copy) NSString *order_id;
@property (nonatomic,copy) NSString *level;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *headimgurl;
@property (nonatomic,copy) NSString *createdate;

@end

NS_ASSUME_NONNULL_END
