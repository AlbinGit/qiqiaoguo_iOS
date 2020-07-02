//
//  QGStarView.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, QGStarType) {
///整数
    QGStarTypeInteger = 0,
///允许浮点(半颗星)
    QGStarTypeFloat,
};

@interface QGStarView : UIView
///回调
@property(nonatomic,copy)void(^starBlock)(NSString *value);

///星级 0-5(默认5)
@property(nonatomic,assign)CGFloat star;

///是否允许触摸改变星级   默认YES
@property(nonatomic,assign)BOOL isTouch;

///类型（整形或者浮点型）
//@property(nonatomic,assign)WTKStarType      starType;

/**
 *  构建方法
 *  @param starSize 星星大小（默认为平分，间距是大小的一半）,默认填CGSizeZero
 *  @param style    类型（WTKStarTypeInteger-不允许半颗星）WTKStarTypeInteger下，star最低为1颗星
 */
- (instancetype)initWithFrame:(CGRect)frame
                     starSize:(CGSize)starSize
                    withStyle:(QGStarType)style;

@end

NS_ASSUME_NONNULL_END
