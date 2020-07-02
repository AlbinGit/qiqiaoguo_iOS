//
//  PCSheetPickerView.m
//  PunchCard
//
//  Created by 史志杰 on 2019/6/19.
//  Copyright © 2019年 Albin. All rights reserved.
//

#import "PCSheetPickerView.h"

#define SCREEN_SIZE [UIScreen mainScreen].bounds.size

@interface PCSheetPickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak,nonatomic)UIView *bgView;    //屏幕下方看不到的view
@property (weak,nonatomic)UILabel *titleLabel; //中间显示的标题lab
@property (weak, nonatomic)UIPickerView *pickerView;
@property (weak,nonatomic)UIButton *cancelButton;
@property (weak,nonatomic)UIButton *doneButton;
@property (strong,nonatomic)NSArray *dataArray;   // 用来记录传递过来的数组数据
@property (strong,nonatomic)NSString *headTitle;  //传递过来的标题头字符串
@property (strong,nonatomic)NSString *backString; //回调的字符串
@property (assign,nonatomic)NSInteger indexRow; //回调的字符串位置

@end


@implementation PCSheetPickerView

+(instancetype)PCSheetStringPickerWithTitle:(NSArray *)title andHeadTitle:(NSString *)headTitle Andcall:(pcSheetPickerViewBlock)callBack
{
	PCSheetPickerView *pickerView = [[PCSheetPickerView alloc]initWithFrame:[UIScreen mainScreen].bounds  andTitle:title andHeadTitle:headTitle];
	pickerView.callBack = callBack;
	return pickerView;
}

- (instancetype)initWithFrame:(CGRect)frame andTitle:(NSArray*)title andHeadTitle:(NSString *)headTitle
{
	self = [super initWithFrame:frame];
	if (self) {
		self.dataArray = title;
		_headTitle = headTitle;
		_backString = self.dataArray[0];
		_indexRow = 0;
		[self setupUI];
	}
	return self;
}

- (void)tap
{
	[self dismissPicker];
}
-(void)setupUI
{
	//首先创建一个位于屏幕下方看不到的view
	UIView* bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
	bgView.alpha = 0.0f;
	UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
	[bgView addGestureRecognizer:g];
	[[[[UIApplication sharedApplication] delegate] window] addSubview:bgView];
	self.bgView = bgView;
	
	//  标题
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_SIZE.width/2-75, 7, 150, 20)];
	titleLabel.font = [UIFont systemFontOfSize:18];
	[titleLabel setBackgroundColor:[UIColor clearColor]];
	[titleLabel setTextAlignment:NSTextAlignmentCenter];
	[titleLabel setText:_headTitle];
	[titleLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
	[self addSubview:titleLabel];
	self.titleLabel = titleLabel;
	
	//    //取消按钮
	//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//    cancelButton.frame = CGRectMake(2, 5, KScreenWidth*0.2, 30);
	//    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"取消" attributes:
	//                                      @{ NSForegroundColorAttributeName: [UIColor whiteColor],
	//                                         NSFontAttributeName :           [UIFont systemFontOfSize:14],
	//                                         NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
	//    [cancelButton setAttributedTitle:attrString forState:UIControlStateNormal];
	//    cancelButton.adjustsImageWhenHighlighted = NO;
	//    cancelButton.backgroundColor = [UIColor lightGrayColor];
	//    [cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
	//    cancelButton.layer.cornerRadius = 3;
	//    cancelButton.layer.masksToBounds = YES;
	//取消和确定按钮
	UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
	[cancelButton setTitle:@"取消" forState:UIControlStateNormal];
	[cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
	[cancelButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:cancelButton];
	self.cancelButton = cancelButton;
	
	//    //完成按钮
	//    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	//    doneButton.frame = CGRectMake(KScreenWidth-KScreenWidth*0.2-2, 5, KScreenWidth*0.2, 30);
	//    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:@"完成" attributes:
	//                                       @{ NSForegroundColorAttributeName: [UIColor whiteColor],
	//                                          NSFontAttributeName :           [UIFont systemFontOfSize:14],
	//                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleNone) }];
	//    [doneButton setAttributedTitle:attrString2 forState:UIControlStateNormal];
	//    doneButton.adjustsImageWhenHighlighted = NO;
	//    doneButton.backgroundColor = kNavViewColor;
	//    [doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
	//    doneButton.layer.cornerRadius = 3;
	//    doneButton.layer.masksToBounds = YES;
	//取消和确定按钮
	UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-70, 0, 70, 40)];
	[doneButton setTitle:@"确定" forState:UIControlStateNormal];
//	[doneButton setTitleColor:[UIColor colorFromHexString:@"3D73C5"] forState:UIControlStateNormal];
	[doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	doneButton.titleLabel.font = [UIFont systemFontOfSize:15];
	[doneButton addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:doneButton];
	self.doneButton = doneButton;
	//    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, doneButton.szjBottom+3, WIDTH, 1)];
	//    lineLabel.backgroundColor = [UIColor lightGrayColor];
	//    [self addSubview:lineLabel];
	//月份
//	UILabel *selectLabel = [[UILabel alloc]init];
//	selectLabel.frame = CGRectMake(SCREEN_WIDTH/3, 0, SCREEN_WIDTH/3, 40);
//	selectLabel.text = @"请选择";
//	selectLabel.textAlignment = NSTextAlignmentCenter;
//	selectLabel.textColor = [UIColor grayColor];
//	selectLabel.font = [UIFont systemFontOfSize:15];
//	[self addSubview:selectLabel];
	//分割线
	UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 1)];
	line.backgroundColor = [UIColor lightGrayColor];
	line.alpha = 0.3;
	[self addSubview:line];
	
	//选择器
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(5,32, SCREEN_SIZE.width-10, 230)];
	[pickerView setShowsSelectionIndicator:YES];
	[pickerView setDelegate:self];
	[pickerView setDataSource:self];
	[self addSubview:pickerView];
	self.pickerView = pickerView;
	[self.pickerView selectRow:0 inComponent:0 animated:YES];   //设置默认选中
	self.pickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	//self
	self.backgroundColor = [UIColor whiteColor];
	[self setFrame:CGRectMake(0, SCREEN_SIZE.height-300, SCREEN_SIZE.width , 300)];
	self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
	[[[[UIApplication sharedApplication] delegate] window] addSubview:self];
	[self setFrame: CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250)];
}



- (void)clicked:(UIButton *)sender
{
	if ([sender isEqual:self.cancelButton]) {
		[self dismissPicker];
	}else{
		if (self.callBack) {
			self.callBack(self,_backString,_indexRow);
		}
	}
}


#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
	return 1;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return self.dataArray.count;
}

#pragma mark - 该方法返回的NSString将作为UIPickerView中指定列和列表项的标题文本
//- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    return self.dataArray[row];
//}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	//这个属性可以控制 标题栏。
	//    self.titleLabel.text =self.dataArray[row];
	_backString = self.dataArray[row];
	_indexRow = row;
}

- (UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UILabel* l = [[UILabel alloc] init];
	l.textColor = self.textColor;
	l.textAlignment = NSTextAlignmentCenter;
	l.text = self.dataArray[row];
	return l;
}

- (UIColor *)textColor
{
	if (!_textColor) {
		_textColor = [UIColor blackColor];
	}
	return _textColor;
}

- (void)show
{
	[UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
		
		[[[[UIApplication sharedApplication] delegate] window] addSubview:self];
		self.bgView.alpha = 1.0;
		
		self.frame = CGRectMake(0, SCREEN_SIZE.height-250, SCREEN_SIZE.width, 250);
	} completion:NULL];
}

- (void)dismissPicker
{
	[UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.9f initialSpringVelocity:0.7f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionLayoutSubviews animations:^{
		self.bgView.alpha = 0.0;
		self.frame = CGRectMake(0, SCREEN_SIZE.height,SCREEN_SIZE.width , 250);
		
	} completion:^(BOOL finished) {
		[self.bgView removeFromSuperview];
		[self removeFromSuperview];
		
	}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
