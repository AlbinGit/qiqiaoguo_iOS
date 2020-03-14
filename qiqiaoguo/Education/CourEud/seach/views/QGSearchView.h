//
//  QGSearchView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/22.
//
//
typedef void (^QGSearchViewBlock)(void);
#import <UIKit/UIKit.h>

@interface QGSearchView : UIView
@property (weak, nonatomic) IBOutlet UITextField *searchText;
-(QGSearchView *)loadQGSearchView;
@property(nonatomic,strong)QGSearchViewBlock searchBlock;
@end
