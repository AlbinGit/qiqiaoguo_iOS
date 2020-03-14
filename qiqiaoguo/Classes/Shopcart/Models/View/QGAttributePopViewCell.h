//
//  QGAttributePopViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//
typedef void(^GAttributePopViewBlock)(NSString *attribute_id,NSString *attribute_value,NSString *attribute_name,int index);
#import <UIKit/UIKit.h>
#import "QGAttrPriceListModel.h"
#import "QGAttrListModel.h"
@interface QGAttributePopViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *attributeTitle;
@property (weak, nonatomic) IBOutlet UIView *attributeBgView;
@property(nonatomic,strong)QGAttrPriceListModel *priceModel;
@property(nonatomic,strong)SAButton *currentBtn;
@property(nonatomic,strong)SAButton *lastBtn;
@property(nonatomic,copy)GAttributePopViewBlock popViewCellClickBlock;
@property(nonatomic,strong)NSString *valueId;
@property(nonatomic,strong) NSMutableArray *valueIds;
@property(nonatomic,strong) NSMutableArray *valueNames;
@property(nonatomic,assign)int selectBtnTag;

//计算高度
-(CGFloat)getCellHeightByPriceModel:(QGAttrPriceListModel *)priceModel;


@end
