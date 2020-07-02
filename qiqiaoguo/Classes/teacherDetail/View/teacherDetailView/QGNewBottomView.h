//
//  QGNewBottomView.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import <UIKit/UIKit.h>
typedef void(^CollectionBlock)(BOOL isSel);
typedef void(^PayForLessonsBlock)();

NS_ASSUME_NONNULL_BEGIN

@interface QGNewBottomView : UIView
@property (nonatomic,copy) NSString *service_id;
@property (nonatomic,assign) BOOL  isFollowed;
@property (nonatomic,strong) CollectionBlock collectionBlock;
@property (nonatomic,strong) PayForLessonsBlock payForLessonsBlock;

@end

NS_ASSUME_NONNULL_END
