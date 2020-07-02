//
//  QGTeacherMoreInfoController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/19.
//

#import "QGTeacherMoreInfoController.h"
#import "QGRegisterView.h"
#import "MOFSPickerManager.h"
#import "QGTeacherWaitController.h"
#import "SKTagView.h"
@interface QGTeacherMoreInfoController ()<UITextViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong)UIScrollView*scrollView;
@property (nonatomic,strong) UIImageView *portraitImgView;
//@property (nonatomic,strong) UIImage *headImg;//头像
@property (nonatomic,strong) UITextField *nameTextfiled;
@property (nonatomic,strong) UITextField *tagTextfiled;
@property (strong, nonatomic) SKTagView *tagView;

@property (nonatomic,strong) UITextField *signTextfiled;
@property (nonatomic,strong) UITextView *singleTextView;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) UILabel *textLab;

@property (nonatomic,strong) UITextView *shareTextView;
@property (nonatomic, strong) UILabel *countLab2;
@property (nonatomic, strong) UILabel *textLab2;

@property (nonatomic,strong) UIImageView *ognizeImgView;
@property (nonatomic,strong) UIImage *porImg;

@property (nonatomic,strong) UILabel *datelabel;


@property (nonatomic,strong) UIButton *agreeBtn;
@property (nonatomic,strong) UIButton *laterBtn;

@end

@implementation QGTeacherMoreInfoController

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
	[self p_loadTeacherMoreInfo];

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

-(void)p_creatUI
{
	self.view.backgroundColor = [UIColor whiteColor];
	UIScrollView * scrollView = [[UIScrollView alloc]init];
	scrollView.backgroundColor = [UIColor whiteColor];
	scrollView.frame = CGRectMake(0,Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar-40-62-20);
	scrollView.showsVerticalScrollIndicator = NO;
	scrollView.bounces = NO;
	if (@available(iOS 11.0, *)) {
		scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
	} else {
	}
	scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 175+13*50);
	[self.view addSubview:scrollView];
	_scrollView = scrollView;
	
	self.agreeBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, SCREEN_HEIGHT-40-62, SCREEN_WIDTH-30, 40);
		[tabBtn setTitle:@"完成" forState:UIControlStateNormal];
		[tabBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		tabBtn.backgroundColor = [UIColor colorFromHexString:@"E62C2A"];
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 20;
		[self.view addSubview:tabBtn];
		tabBtn;
	});
	
	self.laterBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, _agreeBtn.bottom+5, SCREEN_WIDTH-30, 40);
		[tabBtn setTitle:@"不了，以后再完善" forState:UIControlStateNormal];
		[tabBtn setTitleColor:[UIColor colorFromHexString:@"333333"] forState:UIControlStateNormal];
		tabBtn.titleLabel.font = FONT_CUSTOM(16);
		[tabBtn addTarget:self action:@selector(laterClick:) forControlEvents:UIControlEventTouchUpInside];
		tabBtn.backgroundColor = [UIColor clearColor];
		[self.view addSubview:tabBtn];
		tabBtn;
	});
	[_scrollView addSubview:[self getTabheadView]];
	[self addScrollviewChildView];
}
- (UIView *)getTabheadView
{
	CGFloat headViewHeight = 175;
	UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, headViewHeight)];
	view.backgroundColor = [UIColor whiteColor];
	self.portraitImgView = ({
			UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-60)/2,20, 60, 60)];
			img1.image = [UIImage imageNamed:@"提示_提交成功"];
			img1.userInteractionEnabled = YES;
			[view addSubview:img1];
			img1;
		});

	UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-240)/2,_portraitImgView.bottom+10,240,80)];
	label.font = FONT_SYSTEM(16);
	label.text = @"提交成功，请耐心等待审核。您还可以完善以下内容哦！";
	label.numberOfLines = 2;
	label.textColor = [UIColor colorFromHexString:@"666666"];
	label.textAlignment = NSTextAlignmentCenter;
	[label sizeToFit];
	label.backgroundColor = [UIColor whiteColor];
	[view addSubview:label];
	
	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, headViewHeight-8, SCREEN_WIDTH, 8)];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	[view addSubview:lineView];
	
	return view;
}
- (void)addScrollviewChildView
{
	QGRegisterView * regis1 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, 175, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:regis1];
	regis1.titleLabel.text = @"昵称";
	_nameTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis1.titleLabel.right,0, SCREEN_WIDTH-regis1.titleLabel.right-20, 50)];
	_nameTextfiled.backgroundColor = [UIColor whiteColor];
	_nameTextfiled.placeholder = @"例如：甜甜老师";
	[regis1 addSubview:_nameTextfiled];
	
	CGFloat addressWidth = (SCREEN_WIDTH-regis1.titleLabel.right-20);

	QGRegisterView * regis2 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, regis1.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:regis2];
	regis2.titleLabel.text = @"生日";
	
	UILabel * datelabel = [[UILabel alloc]initWithFrame: CGRectMake(regis2.titleLabel.right, 0, addressWidth, 50)];
	datelabel.font = FONT_SYSTEM(16);
	datelabel.text = @"年~ 月~ 日~";
	datelabel.textColor = [UIColor blackColor];
	datelabel.textAlignment = NSTextAlignmentLeft;
	[regis2 addSubview:datelabel];
	_datelabel = datelabel;
	[regis2 addSubview:datelabel];
	
	UIButton * dateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[dateBtn addTarget:self action:@selector(dateClick:) forControlEvents:UIControlEventTouchUpInside];
	dateBtn.frame = datelabel.frame;
	[regis2 addSubview:dateBtn];
	
	QGRegisterView * regis3 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, regis2.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:regis3];
	regis3.titleLabel.text = @"标签";
	_tagTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis3.titleLabel.right,0, SCREEN_WIDTH-regis3.titleLabel.right-20, 50)];
	_tagTextfiled.backgroundColor = [UIColor whiteColor];
	_tagTextfiled.placeholder = @"输入标签~";
	[regis3 addSubview:_tagTextfiled];
	
//	self.tagView = ({
//		   SKTagView *view = [SKTagView new];
//		   view.backgroundColor = [UIColor redColor];
//		   view.padding = UIEdgeInsetsMake(10, 15, 10, 15);
//		   view.interitemSpacing = 15;
//		   view.lineSpacing = 10;
//		   __weak SKTagView *weakView = view;
//		   view.didTapTagAtIndex = ^(NSUInteger index){
//			   [weakView removeTagAtIndex:index];
//		   };
//		view.frame = CGRectMake(0, _tagTextfiled.bottom, SCREEN_WIDTH, 50);
//		   view;
//	   });
//	   [regis3 addSubview:self.tagView];
//
//    //Add Tags
//    [@[@"Python", @"Javascript", @"Python", @"Swift",@"发哈市导航返回付货款骄傲健身房",@"和代发费和就开会好客家话",@"合肥市考核"] enumerateObjectsUsingBlock: ^(NSString *text, NSUInteger idx, BOOL *stop) {
//        SKTag *tag = [SKTag tagWithText: text];
//        tag.textColor = [UIColor blackColor];
//        tag.fontSize = 15;
//        //tag.font = [UIFont fontWithName:@"Courier" size:15];
//        //tag.enable = NO;
//        tag.padding = UIEdgeInsetsMake(5, 5, 5, 5);
//        tag.bgColor = [UIColor colorFromHexString:@"F2F2F2"];
//        tag.cornerRadius = 3;
//        [self.tagView addTag:tag];
//    }];

//	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//		CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
//		NLog(@"------%f------",tagHeight);
//		regis3.frame = CGRectMake(0, regis2.bottom, SCREEN_WIDTH, 50+tagHeight);
//		self.tagView.frame = CGRectMake(0, regis2.bottom, SCREEN_WIDTH, tagHeight);
//	});

	
	QGRegisterView * regis4 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, regis3.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:regis4];
	regis4.titleLabel.text = @"签名";
	_signTextfiled = [[UITextField alloc]initWithFrame:CGRectMake(regis4.titleLabel.right,0, SCREEN_WIDTH-regis4.titleLabel.right-20, 50)];
	_signTextfiled.backgroundColor = [UIColor whiteColor];
	_signTextfiled.placeholder = @"输入您的个性签名";
	[regis4 addSubview:_signTextfiled];
	
	QGRegisterView * regis5 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, regis4.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:regis5];
	regis5.titleLabel.text = @"个人介绍";
	
	UITextView *textV = [[UITextView alloc] init];
	[_scrollView addSubview:textV];
	textV.scrollEnabled = YES;
	textV.editable = YES;
	textV.selectable = YES;
	textV.delegate = self;
	textV.tag = -1;
	textV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
	textV.frame = CGRectMake(20, regis5.bottom, SCREEN_WIDTH-40, 100);
	_singleTextView = textV;
	
	UILabel * textLabel = [[UILabel alloc] init];
    textLabel.text = @"请输入个人介绍";
	textLabel.frame = CGRectMake(20, regis5.bottom, SCREEN_WIDTH-40, 25);
	textLabel.textColor = [UIColor colorFromHexString:@"B7B7B7"];
    textLabel.numberOfLines = 0;
    textLabel.enabled = NO; //label必须设置为不可用
	textLabel.textAlignment = NSTextAlignmentLeft;
    textLabel.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:textLabel];
	_textLab = textLabel;

	self.countLab = ({
		UILabel * textLabel = [[UILabel alloc] init];
		textLabel.text = @"0/150";
		textLabel.frame = CGRectMake(20, _singleTextView.bottom, SCREEN_WIDTH-40, 25);
		textLabel.textColor = [UIColor colorFromHexString:@"B7B7B7"];
		textLabel.textAlignment = NSTextAlignmentRight;
		textLabel.backgroundColor = [UIColor clearColor];
		[_scrollView addSubview:textLabel];
		textLabel;
	});
	UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, _countLab.bottom, SCREEN_WIDTH, 2)];
	lineView.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	[_scrollView addSubview:lineView];
	
	
	QGRegisterView * regis6 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, lineView.bottom, SCREEN_WIDTH, 50)];
	[_scrollView addSubview:regis6];
	regis6.titleLabel.text = @"成果分享";
	
	self.shareTextView = ({
		UITextView *textV = [[UITextView alloc] init];
		[_scrollView addSubview:textV];
		textV.scrollEnabled = YES;
		textV.editable = YES;
		textV.selectable = YES;
		textV.delegate = self;
		textV.tag = -2;
		textV.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		textV.frame = CGRectMake(20, regis6.bottom, SCREEN_WIDTH-40, 100);
		textV;
	});
	
	self.textLab2 = ({
		UILabel * textLabel = [[UILabel alloc] init];
		textLabel.text = @"快把你的成果分享给其他人吧~";
		textLabel.frame = CGRectMake(20, regis6.bottom, SCREEN_WIDTH-40, 25);
		textLabel.textColor = [UIColor colorFromHexString:@"B7B7B7"];
		textLabel.numberOfLines = 0;
		textLabel.enabled = NO; //label必须设置为不可用
		textLabel.textAlignment = NSTextAlignmentLeft;
		textLabel.backgroundColor = [UIColor clearColor];
		[_scrollView addSubview:textLabel];
		textLabel;
	});
	

	self.countLab2 = ({
		UILabel * textLabel = [[UILabel alloc] init];
		textLabel.text = @"0/150";
		textLabel.frame = CGRectMake(20, _shareTextView.bottom, SCREEN_WIDTH-40, 25);
		textLabel.textColor = [UIColor colorFromHexString:@"B7B7B7"];
		textLabel.textAlignment = NSTextAlignmentRight;
		textLabel.backgroundColor = [UIColor clearColor];
		[_scrollView addSubview:textLabel];
		textLabel;
	});
	UIView * lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, _countLab2.bottom, SCREEN_WIDTH, 2)];
	lineView2.backgroundColor = [UIColor colorFromHexString:@"F8F8F8"];
	[_scrollView addSubview:lineView2];
	
	QGRegisterView * regis7 = [[QGRegisterView alloc]initWithFrame:CGRectMake(0, lineView2.bottom, 100, 50)];
	[_scrollView addSubview:regis7];
	regis7.titleLabel.text = @"教学资质";
	
	self.ognizeImgView = ({
		UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(regis7.right, lineView2.bottom+20, 120, 80)];
		img1.image = [UIImage imageNamed:@"img_添加教学资质"];
		img1.userInteractionEnabled = YES;
		[_scrollView addSubview:img1];
		img1;
	});
	
	UIButton * addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[addBtn addTarget:self action:@selector(addClick:) forControlEvents:UIControlEventTouchUpInside];
	addBtn.frame = _ognizeImgView.frame;
	[_scrollView addSubview:addBtn];
		
}
#pragma mark 刷新页面
//- (void)reloadCurrentView
//{
//}
- (void)dateClick:(UIButton *)btn
{
	NSDateFormatter *df = [NSDateFormatter new];
	df.dateFormat = @"yyyy-MM-dd";
	PL_CODE_WEAK(ws);
	[[MOFSPickerManager shareManger] showDatePickerWithTag:1 commitBlock:^(NSDate *date) {
		ws.datelabel.text = [df stringFromDate:date];
	} cancelBlock:^{
		ws.datelabel.text = @"年~ 月~ 日~";
	}];
}
- (void)agreeBtnClick:(UIButton *)btn
{
	[self uploadReginsterData];
}
- (void)laterClick:(UIButton *)btn
{
//	[self.navigationController popToRootViewControllerAnimated:NO];
	
	QGTeacherWaitController *vc = [[QGTeacherWaitController alloc]init];
	[self.navigationController pushViewController:vc animated:NO];

}
- (void)addClick:(UIButton *)btn
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

#pragma mark - <UITextViewDelegate>

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
	if (textView.tag == -1) {
		_singleTextView = textView;
		NSString *content = _singleTextView.text;

		if (textView.text.length == 0) {
			_textLab.text = @"请输入个人介绍";
		}else{
			_textLab.text = @"";
		}

		if (content.length > 150) {
			_countLab.text = @"150/150";
		} else {
			_countLab.text = [NSString stringWithFormat:@"%ld/150", (unsigned long)content.length];
		}
	}else
	{
		_shareTextView = textView;
		NSString *content = _shareTextView.text;

		if (textView.text.length == 0) {
			_textLab2.text = @"快把你的成果分享给其他人吧~";
		}else{
			_textLab2.text = @"";
		}

		if (content.length > 150) {
			_countLab2.text = @"150/150";
		} else {
			_countLab2.text = [NSString stringWithFormat:@"%ld/150", (unsigned long)content.length];
		}

	}
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 150 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    return YES;
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
		_ognizeImgView.image = image;
		_porImg = image;
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
		@"nickname":_nameTextfiled.text,
		@"birthday":_datelabel.text,
		@"tags":_tagTextfiled.text,
		@"signature":_signTextfiled.text,
		@"intro":_singleTextView.text,
		@"share":_shareTextView.text,
	};
	
	[[QGHttpManager sharedManager] POST:[NSString stringWithFormat:@"%@/Phone/Edu/updateTeacherExtendInfo",QQG_BASE_APIURLString] parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
		NSString *mimeType = @"image/jpeg";
		if (_porImg) {
			NSData *fileData = UIImageJPEGRepresentation(_porImg, BLUApiImageCompressionQuality);
			NSString *name = @"certificate_img";
			NSString *filename = @"image0.jpg";
			[formData appendPartWithFileData:fileData name:name fileName:filename mimeType:mimeType];
		}
	} success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
		[self showTopIndicatorWithSuccessMessage:@"发送成功~"];
		[[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
		QGTeacherWaitController *vc = [[QGTeacherWaitController alloc]init];
		[self.navigationController pushViewController:vc animated:NO];
		NLog(@"%@",responseObject);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		NSLog(@"%@",error);
		[self showTopIndicatorWithSuccessMessage:@"发送失败~"];
		[[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];

	}];
}

#pragma mark 获取老师注册信息
- (void)p_loadTeacherMoreInfo
{
	NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
	NSDictionary * param = @{
		@"platform_id":[SAUserDefaults getValueWithKey:USERDEFAULTS_Platform_id],
		@"client_type":@"ios",
		@"verion":[infoDictionary objectForKey:@"CFBundleShortVersionString"],
		@"teacher_id":@([BLUAppManager sharedManager].currentUser.teacher_id),
	};
	
	[QGHttpManager get:[NSString stringWithFormat:@"%@/Phone/Edu/getTeacherExtendInfo",QQG_BASE_APIURLString] params:param success:^(id responseObj) {
		NSMutableDictionary * muDic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)responseObj];
		NSData * data = [NSJSONSerialization dataWithJSONObject:muDic options:NSJSONWritingPrettyPrinted error:nil];
		NSString * strda = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
		NSLog(@"%@",strda);
		NSDictionary * teacherDic = responseObj[@"extra"];
		
		if (teacherDic[@"nickname"]) {
			_nameTextfiled.text = teacherDic[@"nickname"];
		}
		if (teacherDic[@"birthday"]) {
			_datelabel.text = teacherDic[@"birthday"];
		}
		if (teacherDic[@"signature"]) {
			_signTextfiled.text = teacherDic[@"signature"];
		}
		if (teacherDic[@"intro"]) {
			_singleTextView.text = teacherDic[@"intro"];
			_countLab.text = [NSString stringWithFormat:@"%ld/150", (unsigned long)_singleTextView.text.length];
			_textLab.text = @"";
		}
		if (teacherDic[@"share"]) {
			_shareTextView.text = teacherDic[@"share"];
			_countLab2.text = [NSString stringWithFormat:@"%ld/150", (unsigned long)_shareTextView.text.length];
			_textLab2.text = @"";

		}

		if (teacherDic[@"certificate_img"]) {
			[_ognizeImgView sd_setImageWithURL:[NSURL URLWithString:teacherDic[@"certificate_img"]] placeholderImage:[UIImage imageNamed:@"img_添加教学资质"]];
		}
		NSString * tagStr = [NSString stringWithFormat:@"%@",teacherDic[@"tags"]];
		if (tagStr.length>0) {
			_tagTextfiled.text = tagStr;
		}

		
		
		
		} failure:^(NSError *error) {
			NSLog(@"%@",error);
		}];
}










- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
