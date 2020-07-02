//
//  QGNewShareModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGNewShareModel : NSObject<BLUShareObject>



@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *shareImg;
@property (nonatomic,copy) NSString *sharUrl;

@end

NS_ASSUME_NONNULL_END
