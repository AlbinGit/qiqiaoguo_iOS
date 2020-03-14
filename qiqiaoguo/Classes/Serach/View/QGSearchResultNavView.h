//
//  QGSearchResultNavView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import <UIKit/UIKit.h>
#import "QGSearchNavView.h"
#import "QGPOPView.h"

@interface QGSearchResultNavView : UIView <QGPOPViewDelegate>

@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) UIButton *categoryButton;
@property (nonatomic, strong) UIButton *messageCenterButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *SearchButton;
@property (nonatomic ,assign) QGSearchOptionType searchOptionType;

@end
