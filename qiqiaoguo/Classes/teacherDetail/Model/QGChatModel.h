//
//  QGChatModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGChatModel : NSObject
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *role;
@property (nonatomic,copy) NSString *content;
@property (nonatomic, copy) NSString *logTime;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *uuid;

@end

NS_ASSUME_NONNULL_END
