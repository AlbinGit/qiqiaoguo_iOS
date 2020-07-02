//
//  PCSheetPickerView.h
//  PunchCard
//
//  Created by 史志杰 on 2019/6/19.
//  Copyright © 2019年 Albin. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PCSheetPickerView;
//回调  pickerView 回传类本身 用来做调用 销毁动作
//     choiceString  回传选择器 选择的单个条目字符串
typedef void(^pcSheetPickerViewBlock)(PCSheetPickerView *pickerView,NSString *choiceString,NSInteger indexRow);

@interface PCSheetPickerView : UIView

@property (nonatomic,copy)pcSheetPickerViewBlock callBack;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;

//------单条选择器
+(instancetype)PCSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(pcSheetPickerViewBlock)callBack;
//显示
-(void)show;
//销毁类
-(void)dismissPicker;


@end

NS_ASSUME_NONNULL_END
