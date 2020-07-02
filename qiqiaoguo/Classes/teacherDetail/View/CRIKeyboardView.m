//
//  CRIKeyboardView.m
//  CRINewLaosNews
//
//  Created by 史志杰 on 2018/9/19.
//  Copyright © 2018年 史志杰. All rights reserved.
//

#import "CRIKeyboardView.h"


#define InputView_StyleLarge_LRSpace 10
#define InputView_StyleLarge_TBSpace 8
#define InputView_StyleDefault_LRSpace 5
#define InputView_StyleDefault_TBSpace 5
#define InputView_StyleLarge_Height 170
#define InputView_StyleDefault_Height 45
#define InputView_BgViewColor [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6]

static CGFloat keyboardAnimationDuration = 0.5;

@interface CRIKeyboardView ()<UITextViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIView * textBgView;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *placeholderLab;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *cancleButton;
@property (nonatomic, assign) InputViewStyle style;

@property (nonatomic, assign) CGRect showFrameDefault;
@property (nonatomic, assign) CGRect sendButtonFrameDefault;
@property (nonatomic, assign) CGRect textViewFrameDefault;

@property (nonatomic,copy) BOOL (^sendBlcok)(NSString * text);

@property (nonatomic,copy) BOOL (^cancleBlcok)(void);
@end
@implementation CRIKeyboardView

- (void)dealloc
{
	if (_style == InputViewStyleDefault) {
		[_textView removeObserver:self forKeyPath:@"contentSize"];
	}
}
+(void)showWithStyle:(InputViewStyle)style configurationBlock:(void(^)(CRIKeyboardView *inputView))configurationBlock sendBlock:(BOOL(^)(NSString *text))sendBlock cancleBlock:(BOOL(^)(void))cancleBlock{
	CRIKeyboardView *inputView = [[CRIKeyboardView alloc] initWithStyle:style];
	UIWindow *window = [UIApplication sharedApplication].delegate.window;
	[window addSubview:inputView];
	if(configurationBlock) configurationBlock(inputView);
	inputView.sendBlcok = [sendBlock copy];
	inputView.cancleBlcok = [cancleBlock copy];
	[inputView show];
}

- (void)show{
	if ([self.delegate respondsToSelector:@selector(keyboardInputViewWillShow:)]) {
		[self.delegate keyboardInputViewWillShow:self];
	}
	_textView.text = nil;
	_placeholderLab.hidden = NO;
	
	[_textView becomeFirstResponder];
}

- (void)hide{
	if ([self.delegate respondsToSelector:@selector(keyboardInputViewWillHide:)]) {
		[self.delegate keyboardInputViewWillHide:self];
	}
	[_textView resignFirstResponder];
}

- (instancetype)initWithStyle:(InputViewStyle)style
{
	if (self = [super init]) {
		_style = style;
		[self setupUI];
		/** 键盘监听 */
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisappear:) name:UIKeyboardWillHideNotification object:nil];
	}
	return self;
}
- (void)setupUI
{
	self.backgroundColor = [UIColor whiteColor];
	self.frame = [UIScreen mainScreen].bounds;
	UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewClick)];
	tap.delegate = self;
	[self addGestureRecognizer:tap];
	
	_inputView = [[UIView alloc]init];
	_inputView.backgroundColor = [UIColor whiteColor];
	[self addSubview:_inputView];
	
	CGFloat height = 170;
	if(SCREEN_WIDTH<=320){
		height = 90;
	}else if(SCREEN_WIDTH<=375){
		height = 140;
	}
	_inputView.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, height);
	/** StyleLargeUI */
	CGFloat sendButtonWidth = 58;
	CGFloat sendButtonHeight = 29;
	_sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_sendButton.frame = CGRectMake(SCREEN_WIDTH - InputView_StyleLarge_LRSpace - sendButtonWidth,InputView_StyleLarge_TBSpace, sendButtonWidth, sendButtonHeight);
	_sendButton.backgroundColor = [UIColor whiteColor];
//	[_sendButton setTitle:@"发布" forState:UIControlStateNormal];
	[_sendButton setTitle:NSLocalizedString(@"发送", @"发送") forState:UIControlStateNormal];

	
	[_sendButton setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
	_sendButton.titleLabel.font = [UIFont systemFontOfSize:16.];
//	_sendButton.layer.cornerRadius = 1.5;
	[_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	[_inputView addSubview:_sendButton];
	
	_cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
	_cancleButton.frame = CGRectMake(InputView_StyleLarge_LRSpace,InputView_StyleLarge_TBSpace, 50, sendButtonHeight);
//	_cancleButton.backgroundColor = [UIColor redColor];
	[_cancleButton setTitle:@"取消" forState:UIControlStateNormal];
	_cancleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
	[_cancleButton setTitleColor:[UIColor colorFromHexString:@"999999"] forState:UIControlStateNormal];
	_cancleButton.titleLabel.font = [UIFont systemFontOfSize:15];
	_cancleButton.layer.cornerRadius = 1.5;
	[_cancleButton addTarget:self action:@selector(bgViewClick) forControlEvents:UIControlEventTouchUpInside];
	[_inputView addSubview:_cancleButton];
	
//	NSString * titleStr = @"发布评论";
//	CGFloat titleWidth = [QGCommon getLabelSizeWidthWith:titleStr Height:sendButtonHeight andFont:[UIFont systemFontOfSize:15.]].width;
//	UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(InputView_StyleLarge_LRSpace,InputView_StyleLarge_TBSpace, titleWidth, sendButtonHeight)];
//	label.font = [UIFont systemFontOfSize:15.];
//	label.text = titleStr;
//	[_inputView addSubview:label];
	
	
	
	_textBgView = [[UIView alloc] initWithFrame:CGRectMake(InputView_StyleLarge_LRSpace, _sendButton.bottom+InputView_StyleLarge_TBSpace, SCREEN_WIDTH-2*InputView_StyleLarge_LRSpace, self.inputView.height-InputView_StyleLarge_TBSpace)];
	_textBgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	[_inputView addSubview:_textBgView];
	
	_textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, _textBgView.bounds.size.width, _textBgView.bounds.size.height-20)];
	_textView.backgroundColor = [UIColor clearColor];
	_textView.font = [UIFont systemFontOfSize:15];
	_textView.delegate = self;
	[_textBgView addSubview:_textView];
	
	_placeholderLab = [[UILabel alloc] initWithFrame:CGRectMake(7, 0, _textView.bounds.size.width-14, 35)];
	_placeholderLab.font = _textView.font;
	_placeholderLab.text = @"请输入...";
//	_placeholderLab.text = NSLocalizedString(@"talkSomething", ni);
	_placeholderLab.textColor = [UIColor lightGrayColor];
	[_textView addSubview:_placeholderLab];
	
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
	if(object == _textView && [keyPath isEqualToString:@"contentSize"]){
		CGFloat height = _textView.contentSize.height;
		CGFloat heightDefault = InputView_StyleDefault_Height;
		if(height >= heightDefault){
			[UIView animateWithDuration:0.3 animations:^{
				//调整frame
				CGRect frame = _showFrameDefault;
				frame.size.height = height;
				frame.origin.y = _showFrameDefault.origin.y - (height - _showFrameDefault.size.height);
				_inputView.frame = frame;
				//调整sendButton frame
				_sendButton.frame = CGRectMake(SCREEN_WIDTH - InputView_StyleDefault_LRSpace - _sendButton.frame.size.width, _inputView.bounds.size.height - _sendButton.bounds.size.height - InputView_StyleDefault_TBSpace, _sendButton.bounds.size.width, _sendButton.bounds.size.height);
				//调整textView frame
				_textView.frame = CGRectMake(InputView_StyleDefault_LRSpace, InputView_StyleDefault_TBSpace, _textView.bounds.size.width, _inputView.bounds.size.height - 2*InputView_StyleDefault_TBSpace);
			}];
		}else{
			[UIView animateWithDuration:0.3 animations:^{
				[self resetFrameDefault];//恢复到,键盘弹出时,视图初始位置
			}];
		}
	}else{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
	if ([touch.view isDescendantOfView:_inputView]) {
		return NO;
	}
	return YES;
}
-(void)resetFrameDefault{
	self.inputView.frame = _showFrameDefault;
	self.sendButton.frame = _sendButtonFrameDefault;
	self.textView.frame =_textViewFrameDefault;
}
-(void)textViewDidChange:(UITextView *)textView{
	if(textView.text.length){
		_placeholderLab.hidden = YES;
	}else{
		_placeholderLab.hidden = NO;
	}
	if(_maxCount>0){
		if(textView.text.length>=_maxCount){
			textView.text = [textView.text substringToIndex:_maxCount];
		}
		if(_style == InputViewStyleLarge){
			_countLab.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)_maxCount];
		}
	}
}

#pragma mark - Action
-(void)bgViewClick{
	if (self.cancleBlcok) {
		[self hide];
	}
	[self hide];
}
-(void)sendButtonClick:(UIButton *)button{
	if(self.sendBlcok){
		BOOL hideKeyBoard = self.sendBlcok(self.textView.text);
		if(hideKeyBoard){
			[self hide];
		}
	}
}

#pragma mark - 监听键盘
- (void)keyboardWillAppear:(NSNotification *)noti{
	if(_textView.isFirstResponder){
		NSDictionary *info = [noti userInfo];
		NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
		keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
		CGSize keyboardSize = [value CGRectValue].size;
		//NSLog(@"keyboardSize.height = %f",keyboardSize.height);
		[UIView animateWithDuration:keyboardAnimationDuration animations:^{
			CGRect frame = self.inputView.frame;
			frame.origin.y = SCREEN_HEIGHT - keyboardSize.height - frame.size.height;
			self.inputView.frame = frame;
			self.backgroundColor = InputView_BgViewColor;
			self.showFrameDefault = self.inputView.frame;
		}];
	}
}
- (void)keyboardWillDisappear:(NSNotification *)noti{
	
	if(_textView.isFirstResponder){
		[UIView animateWithDuration:keyboardAnimationDuration animations:^{
			CGRect frame = self.inputView.frame;
			frame.origin.y = SCREEN_HEIGHT;
			self.inputView.frame = frame;
			self.backgroundColor = [UIColor clearColor];
		} completion:^(BOOL finished) {
			[self removeFromSuperview];
		}];
	}
}

#pragma mark - set
//-(void)setMaxCount:(NSInteger)maxCount{
//	_maxCount = maxCount;
//	if(_style == InputViewStyleLarge){
//		_countLab.text = [NSString stringWithFormat:@"0/%ld",(long)maxCount];
//	}
//}
-(void)setTextViewBackgroundColor:(UIColor *)textViewBackgroundColor{
	_textViewBackgroundColor = textViewBackgroundColor;
	_textBgView.backgroundColor = textViewBackgroundColor;
}
-(void)setFont:(UIFont *)font{
	_font = font;
	_textView.font = font;
	_placeholderLab.font = _textView.font;
}
-(void)setPlaceholder:(NSString *)placeholder{
	_placeholder = placeholder;
	_placeholderLab.text = placeholder;
}
//-(void)setPlaceholderColor:(UIColor *)placeholderColor{
//	_placeholderColor = placeholderColor;
//	_placeholderLab.textColor = placeholderColor;
//	_countLab.textColor = placeholderColor;
//}
-(void)setSendButtonBackgroundColor:(UIColor *)sendButtonBackgroundColor{
	_sendButtonBackgroundColor = sendButtonBackgroundColor;
	_sendButton.backgroundColor = sendButtonBackgroundColor;
}
-(void)setSendButtonTitle:(NSString *)sendButtonTitle{
	_sendButtonTitle = sendButtonTitle;
	[_sendButton setTitle:sendButtonTitle forState:UIControlStateNormal];
}
-(void)setSendButtonCornerRadius:(CGFloat)sendButtonCornerRadius{
	_sendButtonCornerRadius = sendButtonCornerRadius;
	_sendButton.layer.cornerRadius = sendButtonCornerRadius;
}
-(void)setSendButtonFont:(UIFont *)sendButtonFont{
	_sendButtonFont = sendButtonFont;
	_sendButton.titleLabel.font = sendButtonFont;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
