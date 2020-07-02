//
//  QGTeacherEnterPrivacyController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import "QGTeacherEnterPrivacyController.h"
#import <WebKit/WebKit.h>
#import "QGTeacherRegisterController.h"
@interface QGTeacherEnterPrivacyController ()
@property (nonatomic,strong) UIButton *agreeBtn;

@end

@implementation QGTeacherEnterPrivacyController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	self.title = @"老师入驻协议";
	[self p_creatUI];
	[self lastSecond];
	self.view.backgroundColor = [UIColor whiteColor];
}

-(void)p_creatUI
{
		NSString *path = nil;
		path = [[NSBundle mainBundle] pathForResource:@"讲师端服务协议20200619-讲师版V1.0(2)(1)" ofType:@"docx"];

	   NSURL *url = [NSURL fileURLWithPath:path];

	   NSURLRequest *request = [NSURLRequest requestWithURL:url];
	   
	   WKWebView *webV = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60-Height_TopBar)];
	   
	   [self.view addSubview:webV];
	   [webV loadRequest:request];
	
	self.agreeBtn = ({
		UIButton * tabBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		tabBtn.frame = CGRectMake(15, webV.bottom, SCREEN_WIDTH-30, 40);
		[tabBtn setTitle:@"我已阅读并同意(15)" forState:UIControlStateNormal];
		[tabBtn addTarget:self action:@selector(agreeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
		[tabBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		tabBtn.backgroundColor = [UIColor redColor];
		tabBtn.layer.masksToBounds = YES;
		tabBtn.layer.cornerRadius = 20;
		[self.view addSubview:tabBtn];
		tabBtn;
	});

}

- (void)agreeBtnClick:(UIButton *)btn
{
	QGTeacherRegisterController *vc = [[QGTeacherRegisterController alloc]init];
	[self.navigationController pushViewController:vc animated:YES];
}
- (void)lastSecond
{
    __block int timeout=15; //倒计时时间
	  dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
		dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
		dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
		dispatch_source_set_event_handler(_timer, ^{
			if(timeout<=0){ //倒计时结束，关闭
				dispatch_source_cancel(_timer);
				dispatch_async(dispatch_get_main_queue(), ^{
					//设置界面的按钮显示 根据自己需求设置
					[_agreeBtn setTitle:@"我已阅读并同意" forState:UIControlStateNormal];
					_agreeBtn.backgroundColor = [UIColor colorFromHexString:@"E62C2A"];
					_agreeBtn.userInteractionEnabled = YES;
				});
			}else{
				int seconds = timeout % 15;
				NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
				dispatch_async(dispatch_get_main_queue(), ^{
					//设置界面的按钮显示 根据自己需求设置
					//NSLog(@"____%@",strTime);
					[UIView beginAnimations:nil context:nil];
					[UIView setAnimationDuration:1];
					[_agreeBtn setTitle:[NSString stringWithFormat:@"我已阅读并同意(%@)",strTime] forState:UIControlStateNormal];
//					[_agreeBtn setTitleColor:[UIColor colorFromHexString:@"F45754"] forState:UIControlStateNormal];
					_agreeBtn.backgroundColor = [UIColor colorFromHexString:@"F45754"];

					[UIView commitAnimations];
					_agreeBtn.userInteractionEnabled = NO;
				});
				timeout--;
			}
		});
		dispatch_resume(_timer);
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
