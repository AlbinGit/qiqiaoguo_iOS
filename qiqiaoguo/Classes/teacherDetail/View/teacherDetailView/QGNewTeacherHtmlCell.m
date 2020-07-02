//
//  QGNewTeacherHtmlCell.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import "QGNewTeacherHtmlCell.h"

@implementation QGNewTeacherHtmlCell
{
	CGFloat _webHeight;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		
		[self p_creatUI];
	}
	return self;
}

- (void)p_creatUI
{

	self.label = ({
		
		UILabel * lab = [[UILabel alloc]init];
		lab.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, 1);
		lab.numberOfLines = 0;
		[self.contentView addSubview:lab];
		lab;
	});
//    _webView = [[UIWebView alloc]init];
//	_webView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 1);
//    _webView.opaque = NO;
//    _webView.scrollView.showsHorizontalScrollIndicator = NO;
//    _webView.scalesPageToFit = NO;    //页面大小自适应且不允许用户改动
//    _webView.backgroundColor = [UIColor whiteColor];
//    _webView.delegate = self;
//	
//	[_webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
//    [self.contentView addSubview:_webView];

}
-(void)setUrlString:(NSString *)urlString
{
	_urlString = urlString;
//	[[SAProgressHud sharedInstance]showWaitWithWindow];
//	dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//	dispatch_queue_t mainQueue = dispatch_get_main_queue();
//	dispatch_async(queue, ^{
//
//		NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
//								   NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
//		// htmlString 为需加载的HTML代码
//		NSData *data = [urlString dataUsingEncoding:NSUTF8StringEncoding];
//		NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
//		//回主线程刷新ui
//		dispatch_async(mainQueue, ^{
//			 //给UI控件赋值
//			_label.attributedText = attr;
//            [[SAProgressHud sharedInstance] removeGifLoadingViewFromSuperView];
//		});
//	});

	[self setIntroductionText];
}
- (void)setAttribute:(NSMutableAttributedString *)attribute
{
	_attribute = attribute;
	_label.attributedText = attribute;

}



//- (void)webViewDidStartLoad:(UIWebView *)webView
//{
//
//}
//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//        NSLog(@"-----------------webViewDidFinishLoad");
//    if (webView.isLoading) {
//        return;
//    }
//    CGFloat webViewHeightFromScrollContentSize =[webView.scrollView contentSize].height;
//    CGRect newFrame = webView.frame;
//    newFrame.size.height = webViewHeightFromScrollContentSize;
//    webView.frame = newFrame;
//
//    //下面这两行是去掉不必要的webview效果的(选中,放大镜)
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
//
//    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
//
//	self.frame =  webView.frame;
//}
//
//- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
//
//    NSLog(@"webViewload出错了!");
//}

//- (void)layoutSubviews
//{
//	[super layoutSubviews];
//}
////监听方法
//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    if ([keyPath isEqualToString:@"contentSize"]) {
//        CGSize fitSize = [_webView sizeThatFits:CGSizeZero];
//        self.webView.frame = CGRectMake(0, 0, fitSize.width, fitSize.height);
//        if(self.webViewHeightChanged){
//            self.webViewHeightChanged(self.webView.frame.size.height);
//        }
//    }
//}
//
////这里别忘了在dealloc理移除监听
//- (void)dealloc {
//    NSLog(@"webView ---------dealloc");
//    [self.webView.scrollView removeObserver:self
//                                 forKeyPath:@"contentSize" context:nil];
//}


// cell的高度
-(CGFloat)getCellHeight:(NSString*)htmlStr {
    
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding)
                               };
    NSData *data = [htmlStr dataUsingEncoding:NSUTF8StringEncoding];
    NSAttributedString *attrStr =  [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];

    CGFloat attriHeight = [attrStr boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height;
    
    return attriHeight ;
}
-(void)setIntroductionText
{
	//获得当前cell高度
	CGRect frame = [self frame];
	CGFloat cellHeight = [self getCellHeight:_urlString];
	frame.size.height = cellHeight;
	_label.frame = CGRectMake(15, 0, SCREEN_WIDTH-30, cellHeight);
	self.frame = frame;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
