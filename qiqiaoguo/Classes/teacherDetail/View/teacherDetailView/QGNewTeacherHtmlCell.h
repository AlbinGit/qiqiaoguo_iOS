//
//  QGNewTeacherHtmlCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^WebViewHeightChangedBlock)(int height);
@interface QGNewTeacherHtmlCell : UITableViewCell<UIWebViewDelegate>

@property (nonatomic,strong) NSString *urlString;
@property (nonatomic,strong) NSMutableAttributedString *attribute;

//@property (nonatomic,strong)WKWebView * webView;
@property (nonatomic,strong)UIWebView * webView;

@property (nonatomic,strong)UILabel * label;

@property (nonatomic, strong) WebViewHeightChangedBlock webViewHeightChanged;

@end

NS_ASSUME_NONNULL_END
