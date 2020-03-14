//
//  QGSearchNavView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/7.
//
//

#import <UIKit/UIKit.h>
#import "QGPOPView.h"

typedef NS_ENUM(NSInteger){
    QGSearchOptionTypeCourse = 0,
    QGSearchOptionTypeInstitution,
    QGSearchOptionTypeGoods,
    QGSearchOptionTypeTeacher,
} QGSearchOptionType;


@interface QGSearchNavView : UIView <QGPOPViewDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic ,assign) QGSearchOptionType searchOptionType;

@end
