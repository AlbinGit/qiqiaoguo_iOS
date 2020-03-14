//
//  QGActOrderListCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import <UIKit/UIKit.h>
#import "QGTextView.h"
@interface QGActOrderListCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *sign;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (nonatomic,strong)QGActlistShopInfoModel *shopInfo;
@property (nonatomic,strong) QGTextView *textNote;
@property (nonatomic,copy)NSString *titleName;
@property (nonatomic,copy)NSString *coverPicPop;
@property (nonatomic,strong)QGActlistDetailModel*item;
@property (nonatomic,copy) NSString *type;
@end
