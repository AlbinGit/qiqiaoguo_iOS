//
//  QGTeacherPublishController.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import "QGViewController.h"

typedef void(^RefreshBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface QGTeacherPublishController : QGViewController
@property (nonatomic,strong) RefreshBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
