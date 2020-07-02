//
//  QGTeacherPassportController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/18.
//

#import "QGTeacherPassportController.h"
#import "HLSegementView.h"
#import "QGRegisterView.h"
#import "QGTeacherMoreInfoController.h"

@interface QGTeacherPassportController ()<HLSegementViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate>
@property (nonatomic,strong)UIScrollView*scrollView;
@property (nonatomic,strong) HLSegementView *segmentView;

@property (nonatomic,strong) UITextField *cardTextfield;//身份证
@property (nonatomic,strong) UIImageView *combineImgView;
@property (nonatomic,strong) UIImageView *frontImgView;
@property (nonatomic,strong) UIImageView *backImgView;//反面

@property (nonatomic,strong) UITextField *passportTextfield;//护照
@property (nonatomic,strong) UIImageView *pass_combineImgView;
@property (nonatomic,strong) UIImageView *pass_frontImgView;
@property (nonatomic,strong) UIImageView *pass_backImgView;//反面

@property (nonatomic,strong) UIImage *combineImg;
@property (nonatomic,strong) UIImage *frontImg;
@property (nonatomic,strong) UIImage *backImg;
@property (nonatomic,strong) UIImage *pass_combineImg;
@property (nonatomic,strong) UIImage *pass_frontImg;
@property (nonatomic,strong) UIImage *pass_backImg;


@property (nonatomic,assign)NSInteger cardInteger;//记录选择第几个照片


@property (nonatomic,strong) UIButton *agreeBtn;

@end
static const  CGFloat kImgWidth = 220;
static const  CGFloat kImgHeight = 148;

@implementation QGTeacherPassportController
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
}
- (void)p_creatNav
{
//	PL_CODE_WEAK(ws);
    [self initBaseData];
	[self createReturnButton];
	[self createNavTitle:@"我要当老师"];
	PL_CODE_WEAK(ws)
	[self.leftBtn addClick:^(SAButton *button) {
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

- (void)p_creatUI
{
	NSArray * titlss = @[@"身份证认证",@"护照认证"];
		
	HLSegementView * segmentView = [[HLSegementView alloc] initWithFrame:CGRectMake(0, Height_TopBar, SCREEN_WIDTH, 40) titles:titlss];
	segmentView.isShowUnderLine = YES;
	segmentView.delegate = self;
	_segmentView = segmentView;
	[self.view addSubview:segmentView];
	
	self.view.backgroundColor = COLOR(242, 243, 244, 1);
	UIScrollView * scrollView = [[UIScrollView alloc]init];
	scrollView.frame = CGRectMake(0,_segmentView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-_segmentView.bottom-60);
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.bounces = NO;
	scrollView.directionalLockEnabled = YES;
	scrollView.backgroundColor =COLOR(242, 243, 244, 1);
//    scrollView.pagingEnabled = YES;
//	scrollView.scrollEnabled = NO;
	scrollView.delegate = self;
	if (@available(iOS 11.0, *)) {
		scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
	scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2,kImgHeight*3+50+30+20+20+20);
	[self.view addSubview:scrollView];
	_scrollView = scrollView;
	
	
	QGRegisterView * regis1 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 50)];
	regis1.backgroundColor = [UIColor whiteColor];
	regis1.titleLabel.frame = CGRectMake(20,0,100,50);
	[_scrollView addSubview:regis1];
	regis1.titleLabel.text = @"身份证号码:";
	regis1.titleLabel.backgroundColor = [UIColor whiteColor];
	_cardTextfield = [[UITextField alloc]initWithFrame:CGRectMake(regis1.titleLabel.right,0, SCREEN_WIDTH-regis1.titleLabel.right-20, 50)];
	_cardTextfield.backgroundColor = [UIColor whiteColor];
	_cardTextfield.placeholder = @"请输入身份证号码";
	if (_cardID.length>0) {
		_cardTextfield.text = _cardID;
	}
	_cardTextfield.delegate = self;
	[regis1 addSubview:_cardTextfield];

	
	CGFloat imgX = (SCREEN_WIDTH-kImgWidth)/2;
	self.combineImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, regis1.bottom+30, kImgWidth, kImgHeight)];
		img1.image = [UIImage imageNamed:@"img_手持身份证照片"];
		img1.userInteractionEnabled = YES;
		img1.contentMode = UIViewContentModeScaleAspectFit;
		[_scrollView addSubview:img1];
		img1;
	});
	if (_combineImgUrl.length>0) {
		[_combineImgView sd_setImageWithURL:[NSURL URLWithString:_combineImgUrl] placeholderImage:[UIImage imageNamed:@"img_手持身份证照片"]];
	}

	
	UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	btn1.frame = _combineImgView.frame;
	btn1.tag = 2000;
	[btn1 addTarget:self action:@selector(cameraBtnClick:)
   forControlEvents:UIControlEventTouchUpInside];
	btn1.backgroundColor = [UIColor clearColor];
	[_scrollView addSubview:btn1];
	
	
	self.frontImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, _combineImgView.bottom+20, kImgWidth, kImgHeight)];
		img1.image = [UIImage imageNamed:@"img_身份证正面"];
		img1.contentMode = UIViewContentModeScaleAspectFit;
		img1.userInteractionEnabled = YES;
		[_scrollView addSubview:img1];
		img1;
	});
	if (_frontImgUrl.length>0) {
		[_frontImgView sd_setImageWithURL:[NSURL URLWithString:_frontImgUrl] placeholderImage:[UIImage imageNamed:@"img_身份证正面"]];
	}

	 UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	 btn2.frame = _frontImgView.frame;
	 btn2.tag = 2001;
	 [btn2 addTarget:self action:@selector(cameraBtnClick:)
	forControlEvents:UIControlEventTouchUpInside];
	 btn2.backgroundColor = [UIColor clearColor];
	 [_scrollView addSubview:btn2];

	
	self.backImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, _frontImgView.bottom+20, kImgWidth, kImgHeight)];
		img1.image = [UIImage imageNamed:@"img_身份证反面"];
		img1.contentMode = UIViewContentModeScaleAspectFit;
		img1.userInteractionEnabled = YES;
		[_scrollView addSubview:img1];
		img1;
	});
	if (_backImgUrl.length>0) {
		[_backImgView sd_setImageWithURL:[NSURL URLWithString:_backImgUrl] placeholderImage:[UIImage imageNamed:@"img_身份证反面"]];
	}

	 UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	 btn3.frame = _backImgView.frame;
	 btn3.tag = 2002;
	 [btn3 addTarget:self action:@selector(cameraBtnClick:)
	forControlEvents:UIControlEventTouchUpInside];
	 btn2.backgroundColor = [UIColor clearColor];
	 [_scrollView addSubview:btn3];
	[self p_passportUI];
	self.agreeBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, SCREEN_HEIGHT-60, SCREEN_WIDTH-30, 40);
		[tabBtn setTitle:@"提交申请" forState:UIControlStateNormal];
		[tabBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		tabBtn.backgroundColor = [UIColor colorFromHexString:@"E62C2A"];
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 20;
		[self.view addSubview:tabBtn];
		tabBtn;
	});

}
- (void)p_passportUI
{
	QGRegisterView * regis1 = [[QGRegisterView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH,0, SCREEN_WIDTH, 50)];
	 regis1.backgroundColor = [UIColor whiteColor];
	 regis1.titleLabel.frame = CGRectMake(20,0,100,50);
	 [_scrollView addSubview:regis1];
	 regis1.titleLabel.text = @"护照号码:";
	 regis1.titleLabel.backgroundColor = [UIColor whiteColor];
	 _passportTextfield = [[UITextField alloc]initWithFrame:CGRectMake(regis1.titleLabel.right,0, SCREEN_WIDTH-regis1.titleLabel.right-20, 50)];
	 _passportTextfield.backgroundColor = [UIColor whiteColor];
	 _passportTextfield.placeholder = @"请输入护照号码";
	 [regis1 addSubview:_passportTextfield];
	if (_passportID.length>0) {
		_passportTextfield.text = _cardID;
	}
	_passportTextfield.delegate = self;

	
	 CGFloat imgX = (SCREEN_WIDTH-kImgWidth)/2+SCREEN_WIDTH;
	 self.pass_combineImgView = ({
		 UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, regis1.bottom+30, kImgWidth, kImgHeight)];
		 img1.image = [UIImage imageNamed:@"img_手持护照信息页照片"];
		 img1.contentMode = UIViewContentModeScaleAspectFit;

		 img1.userInteractionEnabled = YES;
		 [_scrollView addSubview:img1];
		 img1;
	 });
	if (_pass_combineImgUrl.length>0) {
		[_pass_combineImgView sd_setImageWithURL:[NSURL URLWithString:_pass_combineImgUrl] placeholderImage:[UIImage imageNamed:@"img_手持护照信息页照片"]];
	}

	
	 UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
	 btn1.frame = _pass_combineImgView.frame;
	 btn1.tag = 2003;
	 [btn1 addTarget:self action:@selector(cameraBtnClick:)
	forControlEvents:UIControlEventTouchUpInside];
	 btn1.backgroundColor = [UIColor clearColor];
	 [_scrollView addSubview:btn1];
	 
	 
	 self.pass_frontImgView = ({
		 UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, _combineImgView.bottom+20, kImgWidth, kImgHeight)];
		 img1.image = [UIImage imageNamed:@"img_护照信息页"];
		 img1.contentMode = UIViewContentModeScaleAspectFit;
		 img1.userInteractionEnabled = YES;
		 [_scrollView addSubview:img1];
		 img1;
	 });
	if (_pass_frontImgUrl.length>0) {
		[_pass_frontImgView sd_setImageWithURL:[NSURL URLWithString:_pass_frontImgUrl] placeholderImage:[UIImage imageNamed:@"img_护照信息页"]];
	}

	  UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
	  btn2.frame = _pass_frontImgView.frame;
	  btn2.tag = 2004;
	  [btn2 addTarget:self action:@selector(cameraBtnClick:)
	 forControlEvents:UIControlEventTouchUpInside];
	  btn2.backgroundColor = [UIColor clearColor];
	  [_scrollView addSubview:btn2];

	 
	 self.pass_backImgView = ({
		 UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(imgX, _frontImgView.bottom+20, kImgWidth, kImgHeight)];
		 img1.image = [UIImage imageNamed:@"img_护照签证页"];
		 img1.contentMode = UIViewContentModeScaleAspectFit;
		 img1.userInteractionEnabled = YES;
		 [_scrollView addSubview:img1];
		 img1;
	 });
	
	if (_pass_backImgUrl.length>0) {
		[_pass_backImgView sd_setImageWithURL:[NSURL URLWithString:_pass_backImgUrl] placeholderImage:[UIImage imageNamed:@"img_护照签证页"]];
	}

	
	  UIButton * btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
	  btn3.frame = _pass_backImgView.frame;
	  btn3.tag = 2005;
	  [btn3 addTarget:self action:@selector(cameraBtnClick:)
	 forControlEvents:UIControlEventTouchUpInside];
	  btn2.backgroundColor = [UIColor clearColor];
	  [_scrollView addSubview:btn3];
}


- (void)agreeBtnClick:(UIButton *)btn
{
//	QGTeacherMoreInfoController *vc = [[QGTeacherMoreInfoController alloc]init];
//	[self.navigationController pushViewController:vc animated:NO];
	

	[self uploadReginsterData];
}
- (void)cameraBtnClick:(UIButton *)btn
{
	_cardInteger = btn.tag;
	[self cameraBtnClick];
}

#pragma mark tag  didSelectWithIndex
- (void)hl_didSelectWithIndex:(NSInteger)index{
	NLog(@"代理实现的方法%ld",index);
		
    //1. 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.scrollView.contentOffset = CGPointMake(offsetX, 0);

}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ( scrollView.contentOffset.x>5) {
		scrollView.pagingEnabled = YES;
	}
	if ( scrollView.contentOffset.y>5) {
		scrollView.pagingEnabled = NO;
	}

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    //1. 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
	_segmentView.selectIndex = index;
}

- (void)cameraBtnClick
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
		if (_cardInteger ==2000) {
			_combineImgView.image = image;
			_combineImg = image;
		}else if (_cardInteger == 2001)
		{
			_frontImgView.image = image;
		}else if (_cardInteger == 2002)
		{
			_backImgView.image = image;
			_backImg = image;

		}
		else if (_cardInteger == 2003)
		{
			_pass_combineImgView.image = image;
			_pass_combineImg = image;

		}
		else if (_cardInteger == 2004)
		{
			_pass_frontImgView.image = image;
			_pass_frontImg = image;

		}
		else if (_cardInteger == 2005)
		{
			_pass_backImgView.image = image;
			_pass_backImg = image;

		}

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
- (void)uploadReginsterData
{
	[[SAProgressHud sharedInstance]showWaitWithWindow];

	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"teacher_id":@([BLUAppManager sharedManager].currentUser.teacher_id),
		@"name":_name,
		@"email":_email,
		@"sex":@(_sex),
		@"degree":@(_degree),
		@"school":_school,
		@"major":_major,
		@"role_type":@(_role_type),
		@"teach_experience":@([_teach_experience integerValue]),
		@"province":@(_provience),
		@"city":@(_city),
		@"area":@(_area),
		@"card_num":_cardTextfield.text,
		@"passport_num":_passportTextfield.text,
	};
	
	[[QGHttpManager sharedManager] POST:[NSString stringWithFormat:@"%@/Phone/Edu/saveTeacher",QQG_BASE_APIURLString] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		
		NSString *mimeType = @"image/jpeg";

		if (_porImg) {
			NSData *fileData = UIImageJPEGRepresentation(_porImg, BLUApiImageCompressionQuality);
			NSString *name = @"head_img";
			NSString *filename = @"image0.jpg";
			[formData appendPartWithFileData:fileData name:name fileName:filename mimeType:mimeType];
		}
		
		if (_combineImg) {
			NSData *fileData2 = UIImageJPEGRepresentation(_combineImg, BLUApiImageCompressionQuality);
			NSString *name2 = @"card_one_img";
			NSString *filename2 = @"image0.jpg";
			[formData appendPartWithFileData:fileData2 name:name2 fileName:filename2 mimeType:mimeType];
		}

		if (_frontImg) {
			NSData *fileData3 = UIImageJPEGRepresentation(_frontImg, BLUApiImageCompressionQuality);
			NSString *name3 = @"card_two_img";
			NSString *filename3 = @"image0.jpg";
			[formData appendPartWithFileData:fileData3 name:name3 fileName:filename3 mimeType:mimeType];
		}
		
		if (_backImg) {
			NSData *fileData4 = UIImageJPEGRepresentation(_backImg, BLUApiImageCompressionQuality);
			NSString *name4 = @"card_three_img";
			NSString *filename4 = @"image0.jpg";
			[formData appendPartWithFileData:fileData4 name:name4 fileName:filename4 mimeType:mimeType];
		}
		
		if (_pass_combineImg) {
			NSData *fileData5 = UIImageJPEGRepresentation(_pass_combineImg, BLUApiImageCompressionQuality);
			NSString *name5 = @"passport_one_img";
			NSString *filename5 = @"image0.jpg";
			[formData appendPartWithFileData:fileData5 name:name5 fileName:filename5 mimeType:mimeType];
		}

		if (_pass_frontImg) {
			NSData *fileData6 = UIImageJPEGRepresentation(_pass_frontImg, BLUApiImageCompressionQuality);
			NSString *name6 = @"passport_two_img";
			NSString *filename6 = @"image0.jpg";
			[formData appendPartWithFileData:fileData6 name:name6 fileName:filename6 mimeType:mimeType];
		}

		if (_pass_backImg) {
			NSData *fileData7 = UIImageJPEGRepresentation(_pass_backImg, BLUApiImageCompressionQuality);
			NSString *name7 = @"passport_three_img";
			NSString *filename7 = @"image0.jpg";
			[formData appendPartWithFileData:fileData7 name:name7 fileName:filename7 mimeType:mimeType];
		}
		
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
		[self showTopIndicatorWithSuccessMessage:@"申请发送成功"];
		[[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
		
		QGTeacherMoreInfoController *vc = [[QGTeacherMoreInfoController alloc]init];
		[self.navigationController pushViewController:vc animated:NO];

		[SAUserDefaults saveValue:@"1" forKey:USERINFONEEDUPDATE];

		NLog(@"%@",responseObject);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@",error);
		[self showTopIndicatorWithSuccessMessage:@"申请失败"];
		[[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

	}];
}
// 3.编写协议方法
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 回收键盘
    [textField resignFirstResponder];
    return YES;
}
@end
