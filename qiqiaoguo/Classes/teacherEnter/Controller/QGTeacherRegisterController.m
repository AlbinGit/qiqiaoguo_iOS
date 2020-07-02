//
//  QGTeacherRegisterController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import "QGTeacherRegisterController.h"
#import "QGTeacherReginsterCell.h"
#import "QGSelImgView.h"
//#import "MOFSPickerManager.h"
#import "PCSheetPickerView.h"
#import "provienceModel.h"
#import "QGRegisterView.h"
#import "QGTeacherPassportController.h"
@interface QGTeacherRegisterController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate>
@property (nonatomic,strong)SASRefreshTableView*tableView;
@property (nonatomic,strong)UIScrollView*scrollView;

@property (nonatomic,strong) UIImageView *portraitImgView;
@property (nonatomic,strong) UIImage *headImg;//头像

@property (nonatomic,strong) UITextField *nameTextfiled;
@property (nonatomic,strong) UITextField *emailTextfiled;
@property (nonatomic,assign) NSInteger  sexInteger;
@property (nonatomic,assign) NSInteger  degree;//学历
@property (nonatomic,assign) NSInteger  role_type;//身份
@property (nonatomic,assign) BOOL  is_role1;

@property (nonatomic,strong) UITextField *addressTextfiled;
@property (nonatomic,strong) UILabel *addressLabel;

@property (nonatomic,strong) UITextField *schoolTextfiled;
@property (nonatomic,strong) UITextField *degreeTextfiled;
@property (nonatomic,strong) UITextField *ageTextfiled;

@property (nonatomic,strong) UILabel *provinceLabel;
@property (nonatomic,strong) UILabel *cityLabel;
@property (nonatomic,strong) UILabel *areaLabel;
@property (nonatomic,assign) BOOL  is_finishArea;
@property (nonatomic,assign) NSInteger provience;//省
@property (nonatomic,assign) NSInteger city;//市
@property (nonatomic,assign) NSInteger area;//区
@property (nonatomic,strong) NSMutableArray * provinceArray;
@property (nonatomic,strong) NSMutableArray * cityArray;
@property (nonatomic,strong) NSMutableArray * areaArray;


@property (nonatomic,strong) UIButton *agreeBtn;

@end

@implementation QGTeacherRegisterController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self p_creatNav];
	[self p_creatUI];
	[self getProvinceData];
}
- (void)p_creatNav
{
//	PL_CODE_WEAK(ws);
    [self initBaseData];
	[self createReturnButton];
	[self createNavTitle:@"我要当老师"];
    PL_CODE_WEAK(ws)
    [self.leftBtn addClick:^(SAButton *button) {
//         [ws.navigationController popViewControllerAnimated:YES];
		[ws backWarnView];
    }];
}
- (void)backWarnView
{
	PL_CODE_WEAK(ws);
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"友情提示" message:@"退出后您新编辑的资料将丢失,是否退出？" preferredStyle:UIAlertControllerStyleAlert];
	
	UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[ws.navigationController popViewControllerAnimated:YES];
	}];
	[alert addAction:action2];
		
	UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:cancleAction];
	[self presentViewController:alert animated:YES completion:^{
	}];
}
- (void)initBaseData
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.hidden = YES;
    [self createNavImageView];
	
	_role_type = 1;
	_sexInteger  = 0;
	_degree = 3;
	_is_role1 = YES;
	_is_finishArea = NO;
//	_is_role2 = NO;
//	_is_role3 = NO;

}

-(void)p_creatUI
{
	self.view.backgroundColor = [UIColor whiteColor];
//	[self add_viewUI];
	UIScrollView * scrollView = [[UIScrollView alloc]init];
	scrollView.backgroundColor = [UIColor whiteColor];
	scrollView.frame = CGRectMake(0,Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar-60);
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.bounces = NO;
	if (@available(iOS 11.0, *)) {
		scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
	scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 175+11*50);
	[self.view addSubview:scrollView];
	_scrollView = scrollView;
	
	self.agreeBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, SCREEN_HEIGHT-60, SCREEN_WIDTH-30, 40);
		[tabBtn setTitle:@"下一步" forState:UIControlStateNormal];
		[tabBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		tabBtn.backgroundColor = [UIColor colorFromHexString:@"E62C2A"];
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 20;
		[self.view addSubview:tabBtn];
		tabBtn;
	});
	
	[_scrollView addSubview:[self getTabheadView]];
	[self addScrollviewChildView];
}

- (void)addScrollviewChildView
{
	UIView * bg1 = [[UIView alloc]initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:bg1];
	QGRegisterView * regis1 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	[bg1 addSubview:regis1];
	regis1.titleLabel.text = @"姓名";
	_nameTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis1.titleLabel.right,0, SCREEN_WIDTH-regis1.titleLabel.right-20, 50)];
	_nameTextfiled.backgroundColor = [UIColor whiteColor];
	_nameTextfiled.placeholder = @"请填写身份证上的姓名";
	if (_teacherDic[@"name"]) {
		_nameTextfiled.text =_teacherDic[@"name"];
	}
	_nameTextfiled.delegate = self;
	[regis1 addSubview:_nameTextfiled];
	

	UIView * bg2 = [[UIView alloc]initWithFrame:CGRectMake(0, bg1.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:bg2];
	QGRegisterView * regis2 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	[bg2 addSubview:regis2];
	regis2.titleLabel.text = @"邮箱";
	_emailTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis2.titleLabel.right,0, SCREEN_WIDTH-regis2.titleLabel.right-20, 50)];
	_emailTextfiled.backgroundColor = [UIColor whiteColor];
	_emailTextfiled.placeholder = @"请输入邮箱";
	[regis2 addSubview:_emailTextfiled];
	_emailTextfiled.delegate = self;

	if (_teacherDic[@"email"]) {
		_emailTextfiled.text =_teacherDic[@"email"];
	}

	
	UIView * bg3 = [[UIView alloc]initWithFrame:CGRectMake(0, bg2.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:bg3];
	QGRegisterView * regis3 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	[bg3 addSubview:regis3];
	regis3.titleLabel.text = @"性别";
	QGSelImgView * sel1 = [[QGSelImgView alloc]initWithFrame:CGRectMake(regis3.titleLabel.right, 0, 80, 50)];
	sel1.label.text = @"男";
//	[sel1 chageSelect:YES];
	PL_CODE_WEAK(ws);
	_sexInteger = 0;
	__weak typeof (*&sel1)weakSelImg = sel1;
	[regis3 addSubview:sel1];
	
	QGSelImgView * sel2 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel1.right, 0, 80, 50)];
	sel2.label.text = @"女";
	__weak typeof (*&sel1)weakSelImg2 = sel2;
	[regis3 addSubview:sel2];
	
	if ([_teacherDic[@"sex"] intValue] == 0) {
		self.sexInteger = 0;//男
		[sel1 chageSelect:YES];
	}else if ([_teacherDic[@"sex"] intValue] == 1)
	{
		self.sexInteger = 1;//女
		[sel2 chageSelect:YES];
	}else
	{
		
	}

	sel1.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weakSelImg chageSelect:!isSel];
			[weakSelImg2 chageSelect:NO];
			ws.sexInteger = 0;//男
		}
	};
	sel2.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weakSelImg2 chageSelect:!isSel];
			[weakSelImg chageSelect:NO];
			ws.sexInteger = 1;
		}
	};
	
	
	UIView * bg4 = [[UIView alloc]initWithFrame:CGRectMake(0, bg3.bottom, SCREEN_WIDTH, 100)];
	[_scrollView addSubview:bg4];
	QGRegisterView * regis4 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
	[bg4 addSubview:regis4];

	regis4.titleLabel.text = @"学历";
	QGSelImgView * degree_sel1 = [[QGSelImgView alloc]initWithFrame:CGRectMake(regis4.titleLabel.right, 0, 80, 50)];
//	[degree_sel1 chageSelect:YES];
	degree_sel1.label.text = @"大专";
	__weak typeof (*&degree_sel1)weakSel1 = degree_sel1;
	[regis4 addSubview:degree_sel1];
	
	
	QGSelImgView * degree_sel2 = [[QGSelImgView alloc]initWithFrame:CGRectMake(degree_sel1.right, 0, 80, 50)];
	__weak typeof (*&degree_sel2)weakSel2 = degree_sel2;
	degree_sel2.label.text = @"本科";
	[regis4 addSubview:degree_sel2];

	QGSelImgView * degree_sel3 = [[QGSelImgView alloc]initWithFrame:CGRectMake(degree_sel2.right, 0, 80, 50)];
	__weak typeof (*&degree_sel3)weakSel3 = degree_sel3;
	degree_sel3.label.text = @"硕士";
	[regis4 addSubview:degree_sel3];
			
	QGSelImgView * degree_sel4 = [[QGSelImgView alloc]initWithFrame:CGRectMake(regis4.titleLabel.right,sel1.bottom, 80, 50)];
	__weak typeof (*&degree_sel4)weakSel4 = degree_sel4;
	degree_sel4.label.text = @"博士";
	[regis4 addSubview:degree_sel4];
	
	if ([_teacherDic[@"degree"] intValue] == 3) {
		self.degree = 3;
		[degree_sel1 chageSelect:YES];
	}else if ([_teacherDic[@"degree"] intValue] == 4)
	{
		self.degree = 4;
		[degree_sel2 chageSelect:YES];
	}else if ([_teacherDic[@"degree"] intValue] == 5)
	{
		self.degree = 5;
		[degree_sel3 chageSelect:YES];
	}
	else if ([_teacherDic[@"degree"] intValue] == 6)
	{
		self.degree = 6;
		[degree_sel4 chageSelect:YES];
	}
	else
	{
		
	}

	
	degree_sel1.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weakSel1 chageSelect:!isSel];
			[weakSel2 chageSelect:NO];
			[weakSel3 chageSelect:NO];
			[weakSel4 chageSelect:NO];
			ws.degree = 3;//大专
		}
	};
	degree_sel2.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weakSel2 chageSelect:!isSel];
			[weakSel1 chageSelect:NO];
			[weakSel3 chageSelect:NO];
			[weakSel4 chageSelect:NO];
			ws.sexInteger = 4;//本科
		}
	};
	degree_sel3.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weakSel3 chageSelect:!isSel];
			[weakSel1 chageSelect:NO];
			[weakSel2 chageSelect:NO];
			[weakSel4 chageSelect:NO];
			ws.sexInteger = 5;//硕士
		}
	};
	degree_sel4.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weakSel4 chageSelect:!isSel];
			[weakSel1 chageSelect:NO];
			[weakSel2 chageSelect:NO];
			[weakSel3 chageSelect:NO];
			ws.sexInteger = 6;//博士
		}
	};
	
	UIView * bg5 = [[UIView alloc]initWithFrame:CGRectMake(0, bg4.bottom, SCREEN_WIDTH, 100)];
	[_scrollView addSubview:bg5];
	QGRegisterView * regis5 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
	[bg5 addSubview:regis5];
	regis5.titleLabel.text = @"地址";

	CGFloat addressWidth = (SCREEN_WIDTH-regis5.titleLabel.right-20)/3;
	
	UILabel * proviencelabel = [[UILabel alloc]initWithFrame: CGRectMake(regis5.titleLabel.right, 0, addressWidth, 50)];
	proviencelabel.font = FONT_SYSTEM(16);
	proviencelabel.text = @"省/洲 ↓";
	proviencelabel.textColor = [UIColor blackColor];
	proviencelabel.textAlignment = NSTextAlignmentLeft;
	[regis5 addSubview:proviencelabel];
	_provinceLabel = proviencelabel;
	
	UIButton * provienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[provienceBtn addTarget:self action:@selector(areaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	provienceBtn.tag = 1000;
	provienceBtn.frame = CGRectMake(regis5.titleLabel.right, 0, addressWidth, 50);
	[regis5 addSubview:provienceBtn];
	
	UILabel * citylabel = [[UILabel alloc]initWithFrame: CGRectMake(provienceBtn.right, 0, addressWidth, 50)];
	citylabel.font = FONT_SYSTEM(16);
	citylabel.text = @"市 ↓";
	citylabel.textColor = [UIColor blackColor];
	citylabel.textAlignment = NSTextAlignmentLeft;
	[regis5 addSubview:citylabel];
	_cityLabel = citylabel;
	
	UIButton * cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	cityBtn.frame = CGRectMake(provienceBtn.right, 0, addressWidth, 50);
	[cityBtn addTarget:self action:@selector(areaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	cityBtn.tag = 1001;
	[cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[regis5 addSubview:cityBtn];
	
	
	UILabel * arealabel = [[UILabel alloc]initWithFrame: CGRectMake(cityBtn.right, 0, addressWidth, 50)];
	arealabel.font = FONT_SYSTEM(16);
	arealabel.text = @"区 ↓";
	arealabel.textColor = [UIColor blackColor];
	arealabel.textAlignment = NSTextAlignmentLeft;
	[regis5 addSubview:arealabel];
	_areaLabel = arealabel;
	
	if (_teacherDic[@"province_name"]) {
		_provinceLabel.text = _teacherDic[@"province_name"];
		_provience = [_teacherDic[@"province"] intValue];
		
		_cityLabel.text = _teacherDic[@"city_name"];
		_city = [_teacherDic[@"city"] intValue];

		_areaLabel.text = _teacherDic[@"area_name"];
		_area = [_teacherDic[@"area"] intValue];
		_is_finishArea = YES;
	}
	
	UIButton * areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	areaBtn.frame = CGRectMake(cityBtn.right, 0, addressWidth, 50);
	[areaBtn addTarget:self action:@selector(areaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
	areaBtn.tag = 1002;

	[areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[regis5 addSubview:areaBtn];

	_addressTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis5.titleLabel.right,provienceBtn.bottom, SCREEN_WIDTH-regis5.titleLabel.right-20, 50)];
	_addressTextfiled.backgroundColor = [UIColor whiteColor];
	_addressTextfiled.placeholder = @"请输入详细地址";
	[regis5 addSubview:_addressTextfiled];
	_addressTextfiled.delegate = self;

	if (_teacherDic[@"address"]) {
		_addressTextfiled.text = _teacherDic[@"address"];
	}
	
	
	
	UIView * bg6 = [[UIView alloc]initWithFrame:CGRectMake(0, bg5.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:bg6];
	QGRegisterView * regis6 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	[bg6 addSubview:regis6];
	regis6.titleLabel.text = @"毕业院校";
	_schoolTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis6.titleLabel.right,0, SCREEN_WIDTH-regis6.titleLabel.right-20, 50)];
	_schoolTextfiled.backgroundColor = [UIColor whiteColor];
	_schoolTextfiled.placeholder = @"请填写毕业院校";
	[regis6 addSubview:_schoolTextfiled];
	_schoolTextfiled.delegate = self;

	if (_teacherDic[@"school"]) {
		_schoolTextfiled.text = _teacherDic[@"school"];
	}

	
	
	
	UIView * bg7 = [[UIView alloc]initWithFrame:CGRectMake(0, bg6.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:bg7];
	QGRegisterView * regis7 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	[bg7 addSubview:regis7];
	regis7.titleLabel.text = @"专业";
	_degreeTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis7.titleLabel.right,0, SCREEN_WIDTH-regis7.titleLabel.right-20, 50)];
	_degreeTextfiled.backgroundColor = [UIColor whiteColor];
	_degreeTextfiled.placeholder = @"请填写专业";
	[regis7 addSubview:_degreeTextfiled];
	if (_teacherDic[@"major"]) {
		_degreeTextfiled.text = _teacherDic[@"major"];
	}
	_degreeTextfiled.delegate = self;

	
	
	UIView * bg8 = [[UIView alloc]initWithFrame:CGRectMake(0, bg7.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:bg8];
	QGRegisterView * regis8 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
	[bg8 addSubview:regis8];
	regis8.titleLabel.text = @"教龄";
	_ageTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis8.titleLabel.right,0, SCREEN_WIDTH-regis8.titleLabel.right-20, 50)];
	_ageTextfiled.backgroundColor = [UIColor whiteColor];
	_ageTextfiled.placeholder = @"请填写教龄";
	[regis8 addSubview:_ageTextfiled];
	_ageTextfiled.delegate = self;

	if (_teacherDic[@"teach_experience"]) {
		_ageTextfiled.text = _teacherDic[@"teach_experience"];
	}

	
	
	UIView * bg9 = [[UIView alloc]initWithFrame:CGRectMake(0, bg8.bottom, SCREEN_WIDTH, 100)];
	[_scrollView addSubview:bg9];
	QGRegisterView * regis9 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 100)];
	[bg9 addSubview:regis9];
	regis9.titleLabel.text = @"身份";
	QGSelImgView * role_sel1 = [[QGSelImgView alloc]initWithFrame:CGRectMake(regis9.titleLabel.right, 0, 80, 50)];
	role_sel1.label.text = @"老师";
//	[role_sel1 chageSelect:self.is_role1];
	__weak typeof (&*role_sel1)weak9 = role_sel1;
	[regis9 addSubview:role_sel1];
	
	QGSelImgView * role_sel2 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel1.right, 0, 80, 50)];
	role_sel2.label.text = @"在校生";
	__weak typeof (&*role_sel2)weak10 = role_sel2;
	[regis9 addSubview:role_sel2];

	QGSelImgView * role_sel3 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel2.right, 0, 80, 50)];
	__weak typeof (&*role_sel3)weak11 = role_sel3;
	role_sel3.label.text = @"其他";
	[regis9 addSubview:role_sel3];

	
	if ([_teacherDic[@"role_type"] intValue]==1) {
		
		[role_sel1 chageSelect:YES];
		self.role_type = 1;//老师

	}
	else if ([_teacherDic[@"role_type"] intValue]==2)
	{
		[role_sel2 chageSelect:YES];
		self.role_type = 2;

	}
	else if ([_teacherDic[@"role_type"] intValue]==3)
	{
		[role_sel3 chageSelect:YES];
		self.role_type = 3;

	}else
	{
		
	}

	role_sel1.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weak9 chageSelect:!isSel];
			[weak10 chageSelect:NO];
			[weak11 chageSelect:NO];
			ws.role_type = 1;//老师
		}
	};
	role_sel2.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weak10 chageSelect:!isSel];
			[weak11 chageSelect:NO];
			[weak9 chageSelect:NO];
			ws.role_type = 2;//在校生
		}
	};
	role_sel3.selBlock = ^(BOOL isSel) {
		if (!isSel) {
			[weak11 chageSelect:!isSel];
			[weak10 chageSelect:NO];
			[weak9 chageSelect:NO];
			ws.role_type = 3;//其他
		}
	};
	
}
- (void)areaButtonClick:(UIButton *)btn
{
	PL_CODE_WEAK(ws);
	if (btn.tag == 1000) {
		NSLog(@"省");
		NSMutableArray * arr = [NSMutableArray array];
		for (provienceModel *model in _provinceArray) {
			   [arr addObject:model.name];
		   }
		   PCSheetPickerView * facePicker = [PCSheetPickerView PCSheetStringPickerWithTitle:arr andHeadTitle:@"请选择" Andcall:^(PCSheetPickerView * _Nonnull pickerView, NSString * _Nonnull choiceString, NSInteger indexRow) {
			   NLog(@"%@--%ld",choiceString,indexRow);
			   provienceModel *currentModel = ws.provinceArray[indexRow];
			   
			   ws.provience = [currentModel.myID integerValue];
			   [ws getCityDataWithProvince_id:currentModel.myID];
			   ws.provinceLabel.text = choiceString;
			   ws.cityLabel.text = @"市 ↓";
			   ws.areaLabel.text = @"区 ↓";
			   [pickerView dismissPicker];
		   }];
		   [facePicker show];
	}
	else if (btn.tag == 1001)
	{
		NSLog(@"市");
		NSMutableArray * arr = [NSMutableArray array];
		for (provienceModel *model in _cityArray) {
			   [arr addObject:model.name];
		   }
		   PCSheetPickerView * facePicker = [PCSheetPickerView PCSheetStringPickerWithTitle:arr andHeadTitle:@"请选择" Andcall:^(PCSheetPickerView * _Nonnull pickerView, NSString * _Nonnull choiceString, NSInteger indexRow) {
			   NLog(@"%@--%ld",choiceString,indexRow);
			   provienceModel *currentModel = ws.cityArray[indexRow];
			   ws.city = [currentModel.myID integerValue];

			   [ws getAreaDataWithCity_id:currentModel.myID];
			   ws.cityLabel.text = choiceString;
			   ws.areaLabel.text = @"区 ↓";
			   [pickerView dismissPicker];
		   }];
		   [facePicker show];

	}else
	{
		NSLog(@"区");
		NSMutableArray * arr = [NSMutableArray array];
		for (provienceModel *model in _areaArray) {
			   [arr addObject:model.name];
		   }
		   PCSheetPickerView * facePicker = [PCSheetPickerView PCSheetStringPickerWithTitle:arr andHeadTitle:@"请选择" Andcall:^(PCSheetPickerView * _Nonnull pickerView, NSString * _Nonnull choiceString, NSInteger indexRow) {
			   NLog(@"%@--%ld",choiceString,indexRow);
			   provienceModel *currentModel = ws.areaArray[indexRow];
			   ws.area = [currentModel.myID integerValue];

			   ws.areaLabel.text = choiceString;
			   ws.is_finishArea = YES;
			   [pickerView dismissPicker];
		   }];
		   [facePicker show];
	}
}
- (void)agreeBtnClick:(UIButton *)btn
{
	if (_nameTextfiled.text.length==0) {
		[self showTopIndicatorWithWarningMessage:@"请输入姓名"];

	}else if (_emailTextfiled.text.length==0)
	{
		[self showTopIndicatorWithWarningMessage:@"请输入邮箱"];
	}
	else if (_is_finishArea==NO)
	{
		[self showTopIndicatorWithWarningMessage:@"请选择地址"];

	}else
	{
		QGTeacherPassportController * vc = [[QGTeacherPassportController alloc]init];
		vc.porImg = _headImg;
		vc.name = _nameTextfiled.text;
		vc.email = _emailTextfiled.text;
		vc.sex = _sexInteger;
		vc.degree = _degree;
		vc.provience = _provience;
		vc.city = _city;
		vc.area = _area;
		vc.detailAdress = _addressTextfiled.text;
		vc.school = _schoolTextfiled.text;
		vc.major = _degreeTextfiled.text;
		vc.teach_experience = _ageTextfiled.text;
		vc.role_type = _role_type;
		
		//修改信息
		vc.cardID = _teacherDic[@"card_num"];
		vc.passportID = _teacherDic[@"passport_num"];
		vc.combineImgUrl = _teacherDic[@"card_one_img"];
		vc.frontImgUrl = _teacherDic[@"card_two_img"];
		vc.backImgUrl = _teacherDic[@"card_three_img"];
		vc.pass_combineImgUrl = _teacherDic[@"passport_one_img"];
		vc.pass_frontImgUrl = _teacherDic[@"passport_two_img"];
		vc.pass_backImgUrl = _teacherDic[@"passport_three_img"];

		[self.navigationController pushViewController:vc animated:NO];
	}
//	QGTeacherPassportController * vc = [[QGTeacherPassportController alloc]init];
//	vc.porImg = _portraitImgView.image;
//	vc.name = _nameTextfiled.text;
//	vc.email = _emailTextfiled.text;
//	vc.sex = _sexInteger;
//	vc.degree = _degree;
//	vc.provience = _provience;
//	vc.city = _city;
//	vc.area = _area;
//	vc.detailAdress = _addressTextfiled.text;
//	vc.school = _schoolTextfiled.text;
//	vc.major = _degreeTextfiled.text;
//	vc.teach_experience = _ageTextfiled.text;
//	vc.role_type = _role_type;
//	[self.navigationController pushViewController:vc animated:NO];
}

- (UIView *)getTabheadView
{
	CGFloat headViewHeight = 175;
	UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, headViewHeight)];
	view.backgroundColor = [UIColor whiteColor];
	self.portraitImgView = ({
			UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-115)/2, (headViewHeight-115)/2, 115, 115)];
			img1.image = [UIImage imageNamed:@"上传头像"];
			img1.userInteractionEnabled = YES;
			[view addSubview:img1];
			img1;
		});
	if (_teacherDic[@"head_img"]) {
		[_portraitImgView sd_setImageWithURL:[NSURL URLWithString:_teacherDic[@"head_img"]] placeholderImage:[UIImage imageNamed:@"上传头像"]];
	}
	UIButton * tapBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	tapBtn.backgroundColor = [UIColor clearColor];
	[tapBtn addTarget:self action:@selector(tapBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	tapBtn.frame = _portraitImgView.frame;
	[_scrollView addSubview:tapBtn];

	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headViewHeight-8, SCREEN_WIDTH, 8)];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	[view addSubview:lineView];
	
	return view;
}
- (void)tapBtnClick:(UIButton *)btn
{
	PL_CODE_WEAK(ws);
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	
	UIAlertAction *action = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[ws addCamera];
	}];
	[alert addAction:action];

	UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
		[ws addPhoto];
	}];
	
	[alert addAction:action2];
		
	UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
	[alert addAction:cancleAction];
	
	[self presentViewController:alert animated:YES completion:^{
		
	}];
}

#pragma mark 相机
//触发事件：拍照
- (void)addCamera
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //摄像头
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum:相机胶卷
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else { //否则打开照片库
//        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持相机功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];

    }
    [self presentViewController:picker animated:YES completion:nil];
}
//触发事件：相册
- (void)addPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES; //可编辑
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    } else { //否则打开照片库
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"当前设备不支持相机功能" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
    }
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - UIImagePickerControllerDelegate

 //拍摄完成后要执行的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        //得到照片
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //图片存入相册
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        }
		_portraitImgView.image = image;
		_headImg = image;
    } else if ([mediaType isEqualToString:@"public.movie"]) {
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
		NSLog(@"media 写入成功,video路径:%@",videoURL);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//进入拍摄页面点击取消按钮
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)getProvinceData
{
	_provinceArray = [NSMutableArray array];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Home/getProvince",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		_provinceArray = [provienceModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];
		
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
}
- (void)getCityDataWithProvince_id:(NSString *)province_id
{
	_cityArray = [NSMutableArray array];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"province_id":province_id,
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Home/getCity",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		_cityArray = [provienceModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];

		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
}
- (void)getAreaDataWithCity_id:(NSString *)city_id
{	_areaArray = [NSMutableArray array];
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"city_id":city_id,
	};
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Home/getArea",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		_areaArray = [provienceModel mj_objectArrayWithKeyValuesArray:responseObj[@"extra"][@"items"]];

		} failure:^(NSError *error) {
			NSLog(@"%@",error);
			[_tableView endRrefresh];
		}];
}


// 3.编写协议方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回收键盘
    [textField resignFirstResponder];
    return YES;
}
//-(void)add_viewUI {
//    if (_tableView==nil) {
//        _tableView =[[SASRefreshTableView alloc]  initWithFrame:CGRectMake(0,Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar-60) style:UITableViewStyleGrouped];
//        _tableView.delegate=self;
//        _tableView.dataSource=self;
//        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundColor =COLOR(242, 243, 244, 1);
//		_tableView.tableFooterView.hidden = YES;
//		_tableView.tableHeaderView = [self getTabheadView];
//    }
//    [self.view addSubview:_tableView];
//    if (@available(iOS 11.0, *)) {
//        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//}

//#pragma mark - TableViewDataSource
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 9;
//}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc] init];
//}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
////	QGNewTeacherLessonModel * model = _dataArray[indexPath.section];
//	if (indexPath.row == 0) {
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell0") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"姓名";
//		_nameTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right,0, SCREEN_WIDTH-cell.titleLabel.right-20, 50)];
//		_nameTextfiled.backgroundColor = [UIColor whiteColor];
//		_nameTextfiled.placeholder = @"请填写身份证上的姓名";
//
//		[cell.contentView addSubview:_nameTextfiled];
//		return cell;
//	}
//	else if (indexPath.row == 1)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell1") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"邮箱";
//		_emailTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right,0, SCREEN_WIDTH-cell.titleLabel.right-20, 50)];
//		_emailTextfiled.backgroundColor = [UIColor whiteColor];
//		_emailTextfiled.placeholder = @"请输入邮箱";
//		[cell.contentView addSubview:_emailTextfiled];
//		return cell;
//	}
//	else if (indexPath.row == 2)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell2") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"性别";
//
//		QGSelImgView * sel1 = [[QGSelImgView alloc]initWithFrame:CGRectMake(cell.titleLabel.right, 0, 80, 50)];
//		sel1.label.text = @"男";
//		[sel1 chageSelect:YES];
//		PL_CODE_WEAK(ws);
//		_sexInteger = 0;
//		__weak typeof (*&sel1)weakSelImg = sel1;
//		[cell.contentView addSubview:sel1];
//
//		QGSelImgView * sel2 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel1.right, 0, 80, 50)];
//		sel2.label.text = @"女";
//		__weak typeof (*&sel1)weakSelImg2 = sel2;
//		[cell.contentView addSubview:sel2];
//
//		sel1.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSelImg chageSelect:!isSel];
//				[weakSelImg2 chageSelect:NO];
//				ws.sexInteger = 0;//男
//			}
//		};
//		sel2.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSelImg2 chageSelect:!isSel];
//				[weakSelImg chageSelect:NO];
//				ws.sexInteger = 1;
//			}
//		};
//
//		return cell;
//	}
//	else if (indexPath.row == 3)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell3") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"学历";
//		PL_CODE_WEAK(ws);
//
//		QGSelImgView * sel1 = [[QGSelImgView alloc]initWithFrame:CGRectMake(cell.titleLabel.right, 0, 80, 50)];
//		[sel1 chageSelect:YES];
//		sel1.label.text = @"大专";
//		__weak typeof (*&sel1)weakSel1 = sel1;
//		[cell.contentView addSubview:sel1];
//
//
//		QGSelImgView * sel2 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel1.right, 0, 80, 50)];
//		__weak typeof (*&sel2)weakSel2 = sel2;
//		sel2.label.text = @"本科";
//		[cell.contentView addSubview:sel2];
//
//		QGSelImgView * sel3 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel2.right, 0, 80, 50)];
//		__weak typeof (*&sel3)weakSel3 = sel3;
//		sel3.label.text = @"硕士";
//		[cell.contentView addSubview:sel3];
//
//		QGSelImgView * sel4 = [[QGSelImgView alloc]initWithFrame:CGRectMake(cell.titleLabel.right,sel1.bottom, 80, 50)];
//		__weak typeof (*&sel4)weakSel4 = sel4;
//		sel4.label.text = @"博士";
//		[cell.contentView addSubview:sel4];
//
//		sel1.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSel1 chageSelect:!isSel];
//				[weakSel2 chageSelect:NO];
//				[weakSel3 chageSelect:NO];
//				[weakSel4 chageSelect:NO];
//				ws.degree = 3;//大专
//			}
//		};
//		sel2.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSel2 chageSelect:!isSel];
//				[weakSel1 chageSelect:NO];
//				[weakSel3 chageSelect:NO];
//				[weakSel4 chageSelect:NO];
//				ws.sexInteger = 4;//本科
//			}
//		};
//		sel3.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSel3 chageSelect:!isSel];
//				[weakSel1 chageSelect:NO];
//				[weakSel2 chageSelect:NO];
//				[weakSel4 chageSelect:NO];
//				ws.sexInteger = 5;//硕士
//			}
//		};
//		sel4.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSel4 chageSelect:!isSel];
//				[weakSel1 chageSelect:NO];
//				[weakSel2 chageSelect:NO];
//				[weakSel3 chageSelect:NO];
//				ws.sexInteger = 6;//博士
//			}
//		};
//		return cell;
//	}
//
//	else if (indexPath.row == 4)//地址
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell4") ;
//
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"地址";
//
//		CGFloat addressWidth = (SCREEN_WIDTH-cell.titleLabel.right-20)/3;
//
//		UIButton * provienceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		provienceBtn.frame = CGRectMake(cell.titleLabel.right, 0, addressWidth, 50);
//		[provienceBtn setTitle:@"省/洲" forState:UIControlStateNormal];
//		[provienceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//		provienceBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//		[cell.contentView addSubview:provienceBtn];
//
//		UIButton * cityBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		cityBtn.frame = CGRectMake(provienceBtn.right, 0, addressWidth, 50);
//		[cityBtn setTitle:@"市" forState:UIControlStateNormal];
//		[cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//		cityBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//		[cell.contentView addSubview:cityBtn];
//
//		UIButton * areaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//		areaBtn.frame = CGRectMake(cityBtn.right, 0, addressWidth, 50);
//		[areaBtn setTitle:@"区" forState:UIControlStateNormal];
//		[areaBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//		areaBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
//		[cell.contentView addSubview:areaBtn];
//
//
//
//
//
//
//
//		_emailTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right,provienceBtn.bottom, SCREEN_WIDTH-cell.titleLabel.right-20, 50)];
//		_emailTextfiled.backgroundColor = [UIColor whiteColor];
//		_emailTextfiled.placeholder = @"请输入详细地址";
//		[cell.contentView addSubview:_emailTextfiled];
//
////		[tapBtn addClick:^(UIButton *button) {
////			[MOFSPickerManager shareManger].addressPicker.usedXML = true;
////			[[MOFSPickerManager shareManger] showMOFSAddressPickerWithTitle:@"选择地址" cancelTitle:@"取消" commitTitle:@"确定" commitBlock:^(NSString * _Nullable address, NSString * _Nullable zipcode) {
////				weakLab.text = address;
////			} cancelBlock:^{
////
////			}];
////
////		}];
//		return cell;
//
//	}
//	else if (indexPath.row == 5)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell5") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"毕业院校";
//		_schoolTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right,0, SCREEN_WIDTH-cell.titleLabel.right-20, 50)];
//		_schoolTextfiled.backgroundColor = [UIColor whiteColor];
//		_schoolTextfiled.placeholder = @"请填写毕业院校";
//		[cell.contentView addSubview:_schoolTextfiled];
//		return cell;
//	}
//	else if (indexPath.row == 6)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell6") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"专业";
//		_degreeTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right,0, SCREEN_WIDTH-cell.titleLabel.right-20, 50)];
//		_degreeTextfiled.backgroundColor = [UIColor whiteColor];
//		_degreeTextfiled.placeholder = @"请填写专业";
//		[cell.contentView addSubview:_degreeTextfiled];
//		return cell;
//	}
//	else if (indexPath.row == 7)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell7") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"教龄";
//		_ageTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(cell.titleLabel.right,0, SCREEN_WIDTH-cell.titleLabel.right-20, 50)];
//		_ageTextfiled.backgroundColor = [UIColor whiteColor];
//		_ageTextfiled.placeholder = @"请填写教龄";
//		[cell.contentView addSubview:_ageTextfiled];
//		return cell;
//	}
//	else if (indexPath.row == 8)
//	{
//		PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell8") ;
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.titleLabel.text = @"身份";
//
//		QGSelImgView * sel1 = [[QGSelImgView alloc]initWithFrame:CGRectMake(cell.titleLabel.right, 0, 80, 50)];
//		sel1.label.text = @"老师";
//		[sel1 chageSelect:self.is_role1];
//		PL_CODE_WEAK(ws);
//		__weak typeof (&*sel1)weakSel1 = sel1;
//		[cell.contentView addSubview:sel1];
//
//		QGSelImgView * sel2 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel1.right, 0, 80, 50)];
//		sel2.label.text = @"在校生";
//		__weak typeof (&*sel1)weakSel2 = sel2;
//		[sel1 chageSelect:self.is_role2];
//		[cell.contentView addSubview:sel2];
//
//		QGSelImgView * sel3 = [[QGSelImgView alloc]initWithFrame:CGRectMake(sel2.right, 0, 80, 50)];
//		__weak typeof (&*sel3)weakSel3 = sel3;
//		[sel1 chageSelect:self.is_role3];
//		sel3.label.text = @"其他";
//		[cell.contentView addSubview:sel3];
//
//		sel1.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//
//				[weakSel1 chageSelect:!isSel];
//				[weakSel2 chageSelect:NO];
//				[weakSel3 chageSelect:NO];
//				ws.role_type = 1;//老师
//				ws.is_role1 = YES;
//				ws.is_role2 = NO;
//				ws.is_role3 = NO;
//
//			}
//		};
//		sel2.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSel2 chageSelect:!isSel];
//				[weakSel1 chageSelect:NO];
//				[weakSel3 chageSelect:NO];
//				ws.role_type = 2;//在校生
//				ws.is_role1 = NO;
//				ws.is_role2 = YES;
//				ws.is_role3 = NO;
//
//
//			}
//		};
//		sel3.selBlock = ^(BOOL isSel) {
//			if (!isSel) {
//				[weakSel3 chageSelect:!isSel];
//				[weakSel1 chageSelect:NO];
//				[weakSel2 chageSelect:NO];
//				ws.role_type = 3;//其他
//				ws.is_role1 = NO;
//				ws.is_role2 = NO;
//				ws.is_role3 = YES;
//
//			}
//		};
//
//		return cell;
//	}
//
//
//	PL_CELL_CREATEMETHOD(QGTeacherReginsterCell,@"QGTeacherReginsterCell") ;
//	cell.selectionStyle = UITableViewCellSelectionStyleNone;
//	return cell;
//}
//
//
//
//#pragma make - TableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//	if (indexPath.row == 3) {
//		return 100;
//	}
//	if (indexPath.row == 4) {
//		return 100;
//	}
//	return 50;
//}
//
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.00000000001;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//}


@end
