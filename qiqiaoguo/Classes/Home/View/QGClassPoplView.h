//
//  QGClassPoplView.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectClassBlock)(NSString *className);

@interface QGClassPoplView : UIView

@property (nonatomic,copy) SelectClassBlock selectBlock;

@end

NS_ASSUME_NONNULL_END
