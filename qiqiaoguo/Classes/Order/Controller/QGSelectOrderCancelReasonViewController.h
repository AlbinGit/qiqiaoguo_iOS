//
//  QGSelectOrderCancelReasonViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/21.
//
//

#import "QGViewController.h"

typedef NS_ENUM(NSUInteger, QGPickViewType) {
    QGPickViewTypeCannel,
    QGPickViewTypeAfter,
    QGPickViewTypeGoodRefund,
};

@protocol QGSelectOrderCancelReasonDelegate <NSObject>

- (void)SelectOrderCancelReason:(NSString *)reason andType:(QGPickViewType)type;

@end

@interface QGSelectOrderCancelReasonViewController : QGViewController

@property (nonatomic ,strong)NSArray *pickViewDataArray;
@property (nonatomic, weak) id<QGSelectOrderCancelReasonDelegate> delegate;
@property (nonatomic, assign) QGPickViewType type;;

@end
