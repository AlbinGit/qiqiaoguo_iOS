//
//  QGAttributePopView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//
// 获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
/*
 边框
 */
#define kBorder(T,V) \
V.layer.borderColor = T.CGColor; \
V.layer.borderWidth = 1
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
#import "Masonry.h"
#import "QGAttributePopView.h"
#import "UIView+ModifyFrame.h"
#import "UIView+PLLayout.h"
#import "QGAttributePopViewCell.h"
#import "QGAttributeBuyCell.h"
#import "QGSingleItemPriceListModel.h"
#import "QGStoreAttrListModel.h"
#import "QGViewController.h"

@interface QGAttributePopView ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UIView *mainView;
@property(nonatomic,strong)UIImageView *goodPic;//商品图片
@property(nonatomic,strong)UILabel *priceLbl;//价格
@property(nonatomic,strong)UILabel *repertoryLbl;//库存
@property(nonatomic,strong)UILabel * standard;//规格 型号
@property(nonatomic,assign)int buyNum;//购买数量
@property(nonatomic,strong)UILabel *buyNumLbl;
@property(nonatomic,strong)NSMutableArray *attribute_idArray;
@property(nonatomic,strong)NSMutableArray *attr_value_idArray;//对应id
@property(nonatomic,strong)NSMutableArray *attribute_valueArray;
@property(nonatomic,strong)NSString *currentPrice;
PropertyString(currentGoodId);
@property(nonatomic,strong)UIView *maskView;
@property(nonatomic,strong)NSMutableDictionary *selectBtnDic;//记录选择按钮位置的字典
@property(nonatomic,strong)QGSingleItemPriceListModel *CurretnPriceListModel;
@property (nonatomic,strong)  UIView *bottomView;

@property (nonatomic ,strong)SAButton *ReductionButton;
@property (nonatomic ,strong)SAButton *AddButton;
@end

@implementation QGAttributePopView

- (id)initWithFrame:(CGRect)frame andAttrPriceListArray:(NSMutableArray *)attrPriceListArray Type:(QGPopviewType)type
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _attrPriceListArray = attrPriceListArray;
        _type = type;
        [self initData];
        [self p_createView];
        
        //添加那种view
    }
    return self;
}
-(void)initData
{
    _buyNum = 1;
    _attribute_idArray = [NSMutableArray array];
    _attribute_valueArray = [NSMutableArray array];
    _selectBtnDic = [NSMutableDictionary dictionary];
    //加虚拟数据 用户后面替换
    for (QGAttrPriceListModel *model in _attrPriceListArray)
    {
        QGStoreAttributeValueModel *dic = model.attribute_value[0];
        [_attribute_idArray addObject:dic.id];
        [_attribute_valueArray addObject:dic.value];
    }

}
- (void)p_createView
{
    
    
    CGFloat TableViewHeight = [self calculateTableViewHeight];
    
    
    // 遮盖层
   _maskView = [[UIView alloc]initWithFrame:self.bounds];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = 0.5;
    [self addSubview:_maskView];
    //主view
    _mainView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 112+TableViewHeight+50)];
    _mainView.backgroundColor = [UIColor clearColor];
    [self addSubview:_mainView];
    //创建头view
    [self creatHeardview];
    
    //_tableView
    _tableView  = [[UITableView alloc]initWithFrame:CGRectMake(0, 112, SCREEN_WIDTH, TableViewHeight)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc]init];
    [_mainView addSubview:_tableView];
    
    //底部视图
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, _mainView.frame.size.height - 50, SCREEN_WIDTH , 50)];
  
    [_mainView addSubview:bottomView];
    
    UIView *vi =  [[UIView alloc] initWithFrame:CGRectMake(0, 10, MQScreenW, 35)];
     _tableView.tableFooterView = vi;
    
    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.5)];
    sepLine.backgroundColor = RGB(200, 200, 200);
    [vi addSubview:sepLine];
    UILabel *la =[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 35)];
    la.textColor = [UIColor blackColor];
    la.text =@"购买数量";

    la.font = [UIFont systemFontOfSize:16];
    [vi addSubview:la];
    //数量选择
    UIImageView *specificationView = [[UIImageView alloc]initWithFrame:CGRectMake(MQScreenW-83-10, 10, 83, 35)];
    
    //[bottomView addSubview:specificationView];
    specificationView.userInteractionEnabled = YES;
    [vi addSubview:specificationView];

    
    //数量
    _buyNumLbl  = [[UILabel alloc]init];
    _buyNumLbl.text = @"1";
    _buyNumLbl.textAlignment = NSTextAlignmentCenter;
    _buyNumLbl.font = FONT_SYSTEM(14);
    [specificationView addSubview:_buyNumLbl];
    [_buyNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(specificationView).offset(25);
        make.top.equalTo(specificationView).offset(7);
        make.size.mas_equalTo(CGSizeMake(35, 22));
    }];
    
    PL_CODE_WEAK(weakSelf);
    //+
    // UIButton *addBtn = [[UIButton alloc]init];

    SAButton *addBtn=[SAButton buttonWithType:UIButtonTypeCustom];
    [addBtn setImage:[UIImage imageNamed:@"increase-use"] forState:UIControlStateNormal];
    [addBtn setImage:[UIImage imageNamed:@"increase-no-use"] forState:UIControlStateDisabled];
    
    [specificationView addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(specificationView).offset(83-22);
        make.top.equalTo(specificationView).offset(7);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [addBtn addClick:^(SAButton *button) {
        [weakSelf addNumClick];
    }];
    
    _AddButton = addBtn;
    //-
    // UIButton *subtractBtn = [[UIButton alloc]init];
    SAButton *subtractBtn=[SAButton buttonWithType:UIButtonTypeCustom];
    [subtractBtn setImage:[UIImage imageNamed:@"Reduction-use"] forState:UIControlStateNormal];
    [subtractBtn setImage:[UIImage imageNamed:@"Reduction-no-use"] forState:UIControlStateDisabled];
    [specificationView addSubview:subtractBtn];
    _ReductionButton = subtractBtn;
    _ReductionButton.enabled = NO;
    
    [subtractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(specificationView).offset(1);
        make.top.equalTo(specificationView).offset(7);
        make.size.mas_equalTo(CGSizeMake(22, 22));
    }];
    [subtractBtn addClick:^(SAButton *button) {
        [weakSelf minusNumClick];
    }];

    
    
    if (self.type == QGPopviewTypeDefault) {
        
        SAButton * buyNowBtn=[SAButton buttonWithType:UIButtonTypeCustom];
        [buyNowBtn setTitle:@"立即购买"forState:UIControlStateNormal];
        buyNowBtn.frame = CGRectMake(MQScreenW/2,0, MQScreenW/2, 50);
        [buyNowBtn setTitleFont:[UIFont systemFontOfSize:15]];
        buyNowBtn.backgroundColor = COLOR(250, 29, 72, 1);
        
        buyNowBtn.titleLabel.font=FONT_CUSTOM(15);
        buyNowBtn.tag = 1;
        [buyNowBtn addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:buyNowBtn];
        
        SAButton * JoinCarBtn=[SAButton buttonWithType:UIButtonTypeCustom];
        [JoinCarBtn setTitle:@"加入购物车"forState:UIControlStateNormal];
        JoinCarBtn.frame = CGRectMake(0,0, MQScreenW/2, 50);
        JoinCarBtn.tag = 2;
        [JoinCarBtn setTitleFont:[UIFont systemFontOfSize:15]];
        JoinCarBtn.backgroundColor = [UIColor colorFromHexString:@"ffb400"];
        
        JoinCarBtn.titleLabel.font=FONT_CUSTOM(15);
        [JoinCarBtn addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:JoinCarBtn];
        
        
    }else if (self.type == QGPopviewTypeSecondKillDefault){
        SAButton * buyCarBtn=[SAButton buttonWithType:UIButtonTypeCustom];
        [buyCarBtn setTitle:@"立即购买"forState:UIControlStateNormal];
        buyCarBtn.frame = CGRectMake(0,0, MQScreenW, 50);
        [buyCarBtn setTitleFont:[UIFont systemFontOfSize:15]];
        buyCarBtn.backgroundColor = COLOR(250, 29, 72, 1);
        
        buyCarBtn.titleLabel.font=FONT_CUSTOM(15);
        [buyCarBtn addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:buyCarBtn];

    }else{
        SAButton * buyCarBtn=[SAButton buttonWithType:UIButtonTypeCustom];
        [buyCarBtn setTitle:@"确定"forState:UIControlStateNormal];
        buyCarBtn.frame = CGRectMake(0,0, MQScreenW, 50);
        [buyCarBtn setTitleFont:[UIFont systemFontOfSize:15]];
        buyCarBtn.backgroundColor = COLOR(250, 29, 72, 1);
        
        buyCarBtn.titleLabel.font=FONT_CUSTOM(15);
        [buyCarBtn addTarget:self action:@selector(returnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:buyCarBtn];
    }
    
   

    _bottomView = bottomView;

    //显示
    [self showView];
}

- (CGFloat)calculateTableViewHeight{
    
    CGFloat tableFootHeight = 35;
    
    CGFloat CellHeight = 0;
    for (QGAttrPriceListModel *model in _attrPriceListArray) {
       CellHeight +=[[QGAttributePopViewCell alloc] getCellHeightByPriceModel:model];
    }
    
    CGFloat height = tableFootHeight + CellHeight + 35;
    
    return height;
}


#pragma mark 创建_tableView的heardview
-(void)creatHeardview
{
    UIView *heardview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 112)];
    heardview.backgroundColor = [UIColor clearColor];
    
    //图图片外的背景view
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 112 - 20)];
    bgView.backgroundColor = [UIColor whiteColor];
    [heardview addSubview:bgView];

    
    UIView *view = [UIView new];
    view.frame = CGRectMake(13, 0, 102, 102);
    view.backgroundColor = APPBackgroundColor;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius= 8;
    view.borderWidth = QGOnePixelLineHeight * 2;
    view.borderColor = QGCellbottomLineColor;
    [heardview addSubview:view];
    //图片
    _goodPic = [[UIImageView alloc]initWithFrame:CGRectMake(23, 10, 82, 82)];
    _goodPic.image = [UIImage imageNamed:@"loading"];
    [heardview addSubview:_goodPic];

    
    
    //线
    UIView *sep = [[UIView alloc]initWithFrame:CGRectMake(0, 112-QGOnePixelLineHeight, SCREEN_WIDTH, QGOnePixelLineHeight)];
    sep.backgroundColor = QGCellbottomLineColor;
    [heardview addSubview:sep];
    //价格
    _priceLbl = [[UILabel alloc]initWithFrame:CGRectMake(_goodPic.maxX + 12 + 13, 8, SCREEN_WIDTH - (_goodPic.maxY + 12), 30)];
    _priceLbl.font = [UIFont systemFontOfSize:16];
    _priceLbl.textColor = QGMainRedColor;
    _priceLbl.text = @"¥0.00";
    [bgView addSubview:_priceLbl];
    
    //库存
    _repertoryLbl = [[UILabel alloc]initWithFrame:CGRectMake(_priceLbl.minX, _priceLbl.maxY - 5, SCREEN_WIDTH - (_goodPic.maxY + _priceLbl.minX), 25)];
    //    _repertoryLbl.font = [UIFont systemFontOfSize:14];
    _repertoryLbl.font=FONT_CUSTOM(14);
    _repertoryLbl.textColor = RGB(30, 30, 30);
    _repertoryLbl.text = @"库存:0";
    [bgView addSubview:_repertoryLbl];
    
    //规格 型号
    _standard = [[UILabel alloc]initWithFrame:CGRectMake(_repertoryLbl.minX, _repertoryLbl.maxY - 5, SCREEN_WIDTH - _goodPic.maxY - 15, 38)];
    //    _standard.font = [UIFont systemFontOfSize:14];
    _standard.font=FONT_CUSTOM(14);
    _standard.textColor = RGB(30, 30, 30);
    _standard.numberOfLines = 2;
    _standard.text = @"请选择 规格 型号";
    [bgView addSubview:_standard];
    
    //删除按钮
    UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 30, _priceLbl.maxY, 20, 20)];
    [deleteBtn setBackgroundImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:deleteBtn];
    //分割线
//    UIView *sepLine = [[UIView alloc]initWithFrame:CGRectMake(13, 111, SCREEN_WIDTH, 0.5)];
//    sepLine.backgroundColor = RGB(200, 200, 200);
//    [heardview addSubview:sepLine];

    [_mainView addSubview:heardview];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _attrPriceListArray.count;
}
- (void)setImageList:(NSString *)imageList {
    
    _imageList = imageList;
     [_goodPic sd_setImageWithURL:[NSURL URLWithString:_imageList] placeholderImage:nil];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PL_CELL_NIB_CREATE(QGAttributePopViewCell);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    if (_selectBtnDic != nil)
    {
        cell.selectBtnTag = [[_selectBtnDic objectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]] intValue];
    }
    

    
   cell.priceModel = _attrPriceListArray[indexPath.row];

   

    cell.tag = indexPath.row;
    
    cell.popViewCellClickBlock = ^(NSString *attribute_id , NSString * attribute_value ,NSString * attribute_name, int index)
    {
        [_attribute_idArray replaceObjectAtIndex:indexPath.row withObject:attribute_id];//替换对应位置的id
        [_attribute_valueArray replaceObjectAtIndex:indexPath.row withObject:attribute_value];
        //改变请选择的提示语
        NSString *standardName = @"请选择";
        for (QGAttrPriceListModel *model in _attrPriceListArray)
        {
            if (![model.attribute_name isEqualToString:attribute_name]) {
                standardName = [NSString stringWithFormat:@"%@ %@",standardName,model.attribute_name];
            }
        }
        _standard.text = standardName;
        //保存选中按钮的位置
        [_selectBtnDic setValue:[NSString stringWithFormat:@"%d",index] forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
        [self setAttribute_idAndAttribute_Name];
        
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _attrPriceListArray.count)
    {
        return 60;
    }
 
    return  [[QGAttributePopViewCell alloc] getCellHeightByPriceModel:_attrPriceListArray[indexPath.row]];
}

#pragma mark 确认按钮点击
-(void)returnButtonClick:(UIButton *)button
{
    QGPopviewType popType = self.type;
    
    if (self.type == QGPopviewTypeSecondKilling || self.type == QGPopviewTypeSecondKillDefault) {
        
        if (_buyNumLbl.text.intValue > self.str.integerValue) {
            QGViewController *vc = (QGViewController *)[SAUtils findViewControllerWithView:self];
            [vc showTopIndicatorWithWarningMessage:[NSString stringWithFormat:@"当前秒杀商品最多购买%@件",self.str]];
            return;
        }
    }else if (self.type == QGPopviewTypeDefault){
        
        popType = button.tag == 2 ? QGPopviewTypeJoinShopCar : QGPopviewTypeBuyNow;
        if (popType == QGPopviewTypeBuyNow) {
            
            QGViewController *vc = (QGViewController *)[SAUtils findViewControllerWithView:self];
            if([vc loginIfNeeded]){
                return;
            }
            
        }
    }
    
    if (_addBuyCartBlock)
    {
        [self hiddenView];
        //为了避免有些数据  如果_CurretnPriceListModel 为空 传第一个默认的数据
        if (_CurretnPriceListModel == nil)
        {
            //设置初始值
            _CurretnPriceListModel =_priceListsArray[0];
        }
         _addBuyCartBlock(_standard.text,_priceLbl.text,[NSString stringWithFormat:@"%d",[_buyNumLbl.text integerValue]],_currentGoodId,_selectBtnDic,_CurretnPriceListModel,_buyNum,_attr_value_idArray,_attribute_idArray,popType);
    }
}



#pragma mark 显示上一次选中的数据
//显示上一次选中的数据
-(void)setLastSelectDataWithPirceModel:(QGSingleItemPriceListModel *)priceListModel andSelectBtnDic:(NSDictionary *)selectBtnDic andStandardText:(NSString *)text andBuyNum:(int )buyNum and:(NSMutableArray *)attribute_idArray and:(NSMutableArray *)attribute_valueArray
{
    //显示
    _priceLbl.text = [NSString stringWithFormat:@"¥%@",priceListModel.sales_price];
    _repertoryLbl.text = [NSString stringWithFormat:@"库存:%@",priceListModel.stock];
    _standard.text = text;
    _buyNum = buyNum;
    _currentGoodId = priceListModel.id;
    _currentPrice = priceListModel.sales_price;
    _selectBtnDic = [NSMutableDictionary dictionaryWithDictionary:selectBtnDic];
    [_attribute_idArray removeAllObjects];
    _attribute_idArray = attribute_idArray;
    
    [_attribute_valueArray removeAllObjects];
    _attribute_valueArray = attribute_valueArray;
}
#pragma mark 删除按钮
-(void)deleteBtnClick
{
    [self hiddenView];
}

#pragma mark 加减数量

- (void)minusNumClick
{
    int num = [_buyNumLbl.text intValue];
    if (num > 1)
    {
        num--;
        if (num < 2) {
            _ReductionButton.enabled = NO;
            _AddButton.enabled = YES;
        }
        _buyNumLbl.text = [NSString stringWithFormat:@"%d",num];
    }
    else if (num == 1)
    {
        [[SAProgressHud sharedInstance] showSuccessWithWindow:@"亲,不能在减了额!"];
        
    }
    _buyNum = _buyNumLbl.text.integerValue;
}
- (void)addNumClick
{
    int num = [_buyNumLbl.text intValue];
    if (num < 99)
    {
        num++;
        if (num > 1) {
            _ReductionButton.enabled = YES;
        }
        _buyNumLbl.text = [NSString stringWithFormat:@"%d",num];
       
    }
     _buyNum = _buyNumLbl.text.integerValue;
}

-(void)setAttrPriceListArray:(NSMutableArray *)attrPriceListArray
{
    
    NSString *standardName = @"请选择";
    for (QGAttrPriceListModel *model in attrPriceListArray)
    {
        int i =0;
        standardName = [NSString stringWithFormat:@"%@ %@",standardName,model.attribute_name];
        
        [_selectBtnDic setValue:[NSString stringWithFormat:@"%d",0] forKey:[NSString stringWithFormat:@"%d",i]];
        i++;
    }
//    _standard.text = standardName;
    
}
-(void)setPriceListsArray:(NSMutableArray *)priceListsArray
{
    //设置初始值
    QGSingleItemPriceListModel *firstModel  = priceListsArray[0];
    _priceLbl.text = [NSString stringWithFormat:@"¥%@",firstModel.sales_price];
    _repertoryLbl.text = [NSString stringWithFormat:@"库存:%@",firstModel.stock];
    
    _attr_value_idArray = [NSMutableArray array];
    for (QGSingleItemPriceListModel *priceListModel in priceListsArray)
    {
        
        [_attr_value_idArray addObject:priceListModel.attr_value_id];
    }
    _priceListsArray = priceListsArray;

    
    [self setAttribute_idAndAttribute_Name];
    
}

#pragma mark 通过attribute_id的组合去查找价格
-(void)setAttribute_idAndAttribute_Name
{
    //规则:从小到大组合id
    NSComparator cmptr = ^(id obj1, id obj2)//排序
    {
        if ([obj1 integerValue] > [obj2 integerValue])
        {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *ids = [_attribute_idArray sortedArrayUsingComparator:cmptr];
    NSString *findId = @"0";
    //从小到大组合id
    for (int i = 0; i<ids.count; i++)
    {
        if (i == 0)
        {
            findId = ids[0];
        }
        else
        {
            findId = [NSString stringWithFormat:@"%@_%@",findId,ids[i]];
        }
    }
    NSLog(@"findId==%@",findId);
    //查找对应的价格和库存
    for (int i = 0; i < _attr_value_idArray.count; i++)
    {
        if ([findId isEqualToString:_attr_value_idArray[i]])
        {
            _CurretnPriceListModel = _priceListsArray[i];
            _priceLbl.text = [NSString stringWithFormat:@"¥%@",_CurretnPriceListModel.sales_price];
            _repertoryLbl.text = [NSString stringWithFormat:@"库存:%@",_CurretnPriceListModel.stock];
            NSString *name = @"";
            for (int i = 0; i < _attribute_valueArray.count; i++)
            {
                if (i == 0)
                {
                    name = _attribute_valueArray[i];
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@ %@",name,_attribute_valueArray[i]];
                }
            }
            _standard.text = [NSString stringWithFormat:@"已选:%@",name];
            _currentGoodId = _CurretnPriceListModel.id;
            _currentPrice = _CurretnPriceListModel.sales_price;
        }
    }
    
    //查完置空
   findId = @"";
}
- (void)showView
{
    CGFloat TableViewHeight = [self calculateTableViewHeight];
    CGFloat height = 112+TableViewHeight+50;
    
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.frame=CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
        NLog(@"%@",NSStringFromCGRect(_mainView.frame));
    }];
    
}

- (void)hiddenView
{
    [UIView animateWithDuration:0.3 animations:^{
        _mainView.frame=CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - 100);
        if (_hiddenBlock)
        {
            //为了避免有些数据  如果_CurretnPriceListModel 为空 传第一个默认的数据
            if (_CurretnPriceListModel == nil)
            {
                //设置初始值
                _CurretnPriceListModel =_priceListsArray[0];
            }
                     _hiddenBlock(_standard.text,_priceLbl.text,[NSString stringWithFormat:@"%d",_buyNum],_currentGoodId,_selectBtnDic,_CurretnPriceListModel,_buyNum,_attribute_idArray,_attribute_valueArray,_type);
        }
    }completion:^(BOOL finished)
    {
       [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = [touch view];
    if (view == _maskView)
    {
      [self hiddenView];
    }
}

@end
