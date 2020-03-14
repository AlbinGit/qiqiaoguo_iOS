//
//  QGSecKillTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import <UIKit/UIKit.h>

#import "customProgressView.h"

@interface QGSecKillTableViewCell : UITableViewCell
@property (nonatomic,strong)SAImageView *coverImageView;
/**商品名字*/
@property (nonatomic,strong)UILabel *product_name;
/**秒杀价格*/
@property (nonatomic,strong)SALabel *seckilling_price;
/**秒杀商品原销售价*/
@property (nonatomic,strong)SALabel *saleprice;
/**马上抢btn*/
@property (nonatomic,strong)SAButton *Immediately_grabBtn;
/**抢购百分比=sold/product_number*/
@property (nonatomic,strong)SALabel *percent;
/**进度条*/
@property (nonatomic,strong)customProgressView *progressView;
/**已售秒杀商品*/
@property (nonatomic,strong)SALabel *sold;

//非属性字符
@property (nonatomic,strong) QGSeckillListItemModel *listModel;

@end
