//
//  QGBannerWebViewController.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import "QGBannerWebViewController.h"
#import "QGLoadWebCell.h"
@interface QGBannerWebViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,assign)NSInteger webheight;
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UILabel *nullLab;
@end

@implementation QGBannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseData];
    [self createReturnButton];
    [self createUI];

}
- (void)createUI
{
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,self.navImageView.maxY, SCREEN_WIDTH, SCREEN_HEIGHT-self.navImageView.maxY)];
    _webView.scalesPageToFit=YES;
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1 ];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    _nullLab=[[UILabel alloc]init];
    _nullLab.hidden=YES;
    _nullLab.font=FONT_CUSTOM(15);
    _nullLab.text=@"暂无详情";
    _nullLab.textColor=PL_COLOR_160;
    [self.view addSubview:_nullLab];
    PL_CODE_WEAK(weakSelf);
    [_nullLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakSelf.view);
    }];

}

- (void)setUrl:(NSString *)url
{
    _url = url;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:_url] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:1 ];
    [_webView loadRequest:request];
}


-(void)webViewDidFinishLoad:(UIWebView *)webView{

}


@end
