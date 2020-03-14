//
//  QGSearchScreeningSelectView.h
//  qiqiaoguo
//
//  Created by cws on 16/9/8.
//
//

#import <UIKit/UIKit.h>
#import "QGSearchNavView.h"
#import "QGSearchScreeningModel.h"

typedef NS_ENUM(NSUInteger, QGScreeningSelectType) {
    QGScreeningSelectTypeCourseCate = 0,
    QGScreeningSelectTypeArea,
    QGScreeningSelectTypeSort,
};

@protocol QGScreeningSelectViewDelegate <NSObject>

- (void)shouldSelectedWithModel:(QGScreeningModel *)model selectType:(QGScreeningSelectType)type;

@end

@interface QGSearchScreeningSelectView : UIView

@property (nonatomic, assign) QGSearchOptionType type;
@property (nonatomic, assign) QGScreeningSelectType selectType;
@property (nonatomic, strong) QGSearchScreeningModel *model;
@property (nonatomic, strong) QGSearchScreeningModel *courseModel;
@property (nonatomic, strong) QGSearchScreeningModel *orgModel;
@property (nonatomic, assign) NSInteger leftTabselectedID;
@property (nonatomic, assign) NSInteger rightTabselectedID;
@property (nonatomic, assign) NSInteger tabselectedID;
@property (nonatomic, assign) NSInteger selectCouseID;
@property (nonatomic, assign) NSInteger cateID;
@property (nonatomic, assign) NSInteger areaSelectID;
@property (nonatomic, weak) id<QGScreeningSelectViewDelegate> delegate;

- (void)show;
- (void)hidden;
- (void)resetOptions;

@end
