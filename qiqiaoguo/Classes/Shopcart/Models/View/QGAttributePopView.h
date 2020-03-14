//
//  QGAttributePopView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//


#import <UIKit/UIKit.h>
#import "QGAttrPriceListModel.h"
#import "QGSingleItemPriceListModel.h"
#import "QGSingleItemModel.h"

typedef NS_ENUM(NSUInteger, QGPopviewType) {
    QGPopviewTypeDefault = 0,
    QGPopviewTypeJoinShopCar,
    QGPopviewTypeBuyNow,
    QGPopviewTypeSecondKilling,
    QGPopviewTypeSecondKillDefault,
};



typedef void(^GAttributePopViewHiddenBlock)(NSString *attributeStr , NSString *price ,NSString *num ,NSString *goods_id,NSMutableDictionary *selectBtnDic,QGSingleItemPriceListModel *priceListModel,int buyNum,NSMutableArray *_attribute_idArray,NSMutableArray *_attr_value_idArray,QGPopviewType type);

//商品分类选择popview
@interface QGAttributePopView : UIView

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *attrPriceListArray;///影响价格的属性值

@property (nonatomic,strong)NSMutableArray *priceListsArray;////价格列表
@property(nonatomic,strong)GAttributePopViewHiddenBlock hiddenBlock;//隐藏
@property(nonatomic,strong)GAttributePopViewHiddenBlock addBuyCartBlock;//添加到购物车
@property(nonatomic,strong)GAttributePopViewHiddenBlock buyNowBlock;//立即购买
@property (nonatomic,copy) NSString *imageList;
@property (nonatomic,copy) NSString *str;
@property (nonatomic,assign)QGPopviewType type;

- (id)initWithFrame:(CGRect)frame andAttrPriceListArray:(NSMutableArray *)attrPriceListArray Type:(QGPopviewType)type;
//显示上一次选中的数据
-(void)setLastSelectDataWithPirceModel:(QGSingleItemPriceListModel *)priceListModel andSelectBtnDic:(NSDictionary *)selectBtnDic andStandardText:(NSString *)text andBuyNum:(int )buyNum and:(NSMutableArray *)attribute_idArray and:(NSMutableArray *)attribute_valueArray;
@end
