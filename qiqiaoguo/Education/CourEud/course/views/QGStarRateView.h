//
//  QGStarRateView.h
//  LongForTianjie
//
//  Created by Albin on 15/11/12.
//  Copyright © 2015年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QGStarRateView;

/**
 *  选择的星星数回调
 */
@protocol QGStarRateViewDelegate <NSObject>

- (void)starRateView:(QGStarRateView *)starView andScore:(CGFloat)score;

@end
@interface QGStarRateView : UIView

/**得分值，范围为0~1*/
@property (nonatomic, assign) CGFloat score;
/**是否允许动画*/
@property (nonatomic, assign) BOOL hasAnimation;
/**是否整星*/
@property (nonatomic, assign) BOOL isComplete;
@property (nonatomic, weak) id<QGStarRateViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)number;

@end
