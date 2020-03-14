//
//  QGLoadWebCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import <UIKit/UIKit.h>

@interface QGLoadWebCell : UITableViewCell<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView *webView;
@property (nonatomic,strong)UILabel *nullLab;
@end
