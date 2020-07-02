//
//  QGFileWebController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import "QGFileWebController.h"

@interface QGFileWebController ()

@end

@implementation QGFileWebController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	[self p_creatNav];
	UIWebView *localWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, Height_TopBar, SCREEN_WIDTH, SCREEN_HEIGHT-Height_TopBar)];
	localWebView.scalesPageToFit = YES;
	localWebView.userInteractionEnabled = YES;
	localWebView.contentMode = UIViewContentModeScaleAspectFit;
	[self.view addSubview:localWebView];
	NSURL *url = [NSURL URLWithString:_filePDFUrl];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	[localWebView loadRequest:request];
}
- (void)p_creatNav
{
//	PL_CODE_WEAK(ws);
    [self initBaseData];
	[self createReturnButton];
	[self createNavTitle:@"课件"];
}
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    [[self navigationController] setNavigationBarHidden:YES animated:NO];
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
