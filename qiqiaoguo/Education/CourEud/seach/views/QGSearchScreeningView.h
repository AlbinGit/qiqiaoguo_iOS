//
//  QGSearchScreeningView.h
//  qiqiaoguo
//
//  Created by cws on 16/9/6.
//
//

#import <UIKit/UIKit.h>
#import "QGVerticalButton.h"
#import "QGSearchScreeningModel.h"

@protocol ScreeningViewDelegate <NSObject>

- (void)buttonShouldClick:(UIButton *)button;

@end

@interface QGSearchScreeningView : UIView

@property (nonatomic, strong)QGVerticalButton *categoryButton;
@property (nonatomic, strong)QGVerticalButton *nearButton;
@property (nonatomic, strong)QGVerticalButton *smartButton;
@property (nonatomic, weak) id<ScreeningViewDelegate> delegate;

@property (nonatomic, weak) QGScreeningModel *selectModel;

@property (nonatomic, assign) NSInteger selectCcateID;

- (void)resetOptions;

@end
