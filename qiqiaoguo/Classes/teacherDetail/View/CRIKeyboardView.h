//
//  CRIKeyboardView.h
//  CRINewLaosNews
//
//  Created by 史志杰 on 2018/9/19.
//  Copyright © 2018年 史志杰. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,InputViewStyle){
	InputViewStyleDefault,
	InputViewStyleLarge,
};
@class CRIKeyboardView;

@protocol keyboardInputViewDelegate <NSObject>

@optional

- (void)keyboardInputViewWillShow:(CRIKeyboardView *)inputView;


- (void)keyboardInputViewWillHide:(CRIKeyboardView *)inputView;

@end

@interface CRIKeyboardView : UIView

@property (nonatomic, assign) id<keyboardInputViewDelegate> delegate;

/** 最大输入字数 */
@property (nonatomic, assign) NSInteger maxCount;
/** 字体 */
@property (nonatomic, strong) UIFont * font;
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位符颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;
/** 输入框背景颜色 */
@property (nonatomic, strong) UIColor* textViewBackgroundColor;

/** 发送按钮背景色 */
@property (nonatomic, strong) UIColor *sendButtonBackgroundColor;
/** 发送按钮Title */
@property (nonatomic, copy) NSString *sendButtonTitle;
/** 发送按钮圆角大小 */
@property (nonatomic, assign) CGFloat sendButtonCornerRadius;
/** 发送按钮字体 */
@property (nonatomic, strong) UIFont * sendButtonFont;

+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(CRIKeyboardView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock cancleBlock:(BOOL(^)(void))cancleBlock;
@end
