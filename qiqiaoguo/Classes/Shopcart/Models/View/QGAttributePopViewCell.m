//
//  QGAttributePopViewCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import "QGAttributePopViewCell.h"
#import "QGAttributeValueModel.h"
#import "SAUtils.h"
@implementation QGAttributePopViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(void)setPriceModel:(QGAttrPriceListModel *)priceModel
{
    _priceModel = priceModel;
    _attributeTitle.text = priceModel.attribute_name;
    _currentBtn.tag = 0;
    _lastBtn.tag = 1;
    [self creatBtns:priceModel];
}

#pragma mark 创建按钮
-(void)creatBtns:(NSObject *)model;
{
    //计算高度
    _valueNames = [NSMutableArray array];
    _valueIds = [NSMutableArray array];
    CGFloat totalWidth = 0;
    CGFloat totalHeight = 0;
    CGFloat bgViewHeight = 0;//背景view的高度
    
    QGAttrPriceListModel *priceModel = (QGAttrPriceListModel *)model;
    if ([priceModel.attribute_value isKindOfClass:[NSArray class]])
    {
        for (int i = 0; i < priceModel.attribute_value.count ; i ++)
        {
            //拿到里面的属性名字
            NSDictionary *dic = priceModel.attribute_value[i];
            QGAttributeValueModel *valueModel = [QGAttributeValueModel mj_objectWithKeyValues:dic];
            [_valueNames addObject:valueModel.value];
            [_valueIds addObject:valueModel.id];
            //计算高度
            CGSize size = [SAUtils getCGSzieWithText:valueModel.value width:SCREEN_WIDTH - 30 height:999 font:[UIFont systemFontOfSize:13]];
            //创建按钮
            SAButton *battributeBtn = [SAButton createBtnWithRect:CGRectMake(totalWidth ,totalHeight , size.width + 10, size.height + 10) andWithImg:nil andWithTag:i + 100 andWithBg:nil andWithTitle:valueModel.value andWithColor:RGB(30, 30, 30)] ;
            [battributeBtn addTarget:self action:@selector(battributeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            battributeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            battributeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
            [battributeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            battributeBtn.layer.masksToBounds= YES;
            battributeBtn.layer.cornerRadius= 5;
            [battributeBtn setImage:nil  forState:UIControlStateNormal];
            
            kBorder([UIColor lightGrayColor], battributeBtn);
            [_attributeBgView addSubview:battributeBtn];
            
            //谁知默认的选择
            if (battributeBtn.tag-100 == _selectBtnTag)
            {
                battributeBtn.selected = YES;
                battributeBtn.layer.borderColor = [UIColor clearColor].CGColor;
                battributeBtn.backgroundColor = QGMainRedColor;
                [battributeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
                
                _currentBtn = battributeBtn;
                _lastBtn = battributeBtn;
                
            }
            //间距
            totalWidth += 25;
            totalWidth +=size.width;
            
            //如果当前宽度 加上下一个的宽度大于SCREEN_WIDTH - 30 换行
            if ((i + 1) < priceModel.attribute_value.count)
            {
                NSDictionary *nextDic = priceModel.attribute_value[i+1];
                QGAttributeValueModel *nextValueModel = [QGAttributeValueModel mj_objectWithKeyValues:nextDic];
                CGSize nextSize = [SAUtils getCGSzieWithText:nextValueModel.value width:SCREEN_WIDTH - 30 height:999 font:[UIFont systemFontOfSize:13]];
                if (totalWidth + nextSize.width > SCREEN_WIDTH - 30)
                {
                    totalHeight += ((totalWidth / SCREEN_WIDTH - 30) * (size.height + 10 )+ 5);
                    //清除宽度 从0开始
                    totalWidth = 0;
                    bgViewHeight += 35;
                }
            }
            
            //如果大于SCREEN_WIDTH - 30 换行
            if (totalWidth > SCREEN_WIDTH - 30)
            {
                totalHeight += ((totalWidth / SCREEN_WIDTH - 30) * (size.height + 10 ));
                bgViewHeight += ((totalWidth / SCREEN_WIDTH - 30) * (size.height + 10 )+ 5);
                //清除宽度 从0开始
                totalWidth = 0;
            }else //只有一行的高度
            {
                bgViewHeight = 30;
            }
        }
        CGRect frame = _attributeBgView.frame ;
        frame.size.height = bgViewHeight;
        _attributeBgView.frame = frame;
    }
    
}

-(void)battributeBtnClick:(SAButton *)battributeBtn
{
    
    _valueId = _valueIds[battributeBtn.tag - 100];
    _currentBtn = battributeBtn;
    _currentBtn.selected = YES;
    _currentBtn.layer.borderColor = [UIColor clearColor].CGColor;
    _currentBtn.backgroundColor =[UIColor redColor];
    [_currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _lastBtn.selected = NO;
    _lastBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _lastBtn.backgroundColor = [UIColor whiteColor];
    
    if (_currentBtn.tag == _lastBtn.tag)
    {
        _currentBtn.selected = YES;
        
        _currentBtn.backgroundColor =[UIColor redColor];
       [_currentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _currentBtn.layer.borderColor = [UIColor clearColor].CGColor;
    }
    else
    { _lastBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _lastBtn.backgroundColor = [UIColor whiteColor];
     [_lastBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    //如果本次和上次不一样 在传值出去
    if (_currentBtn.tag != _lastBtn.tag)
    {
        if (_popViewCellClickBlock)
        {
            _popViewCellClickBlock(_valueIds[battributeBtn.tag - 100],_valueNames[battributeBtn.tag - 100],_priceModel.attribute_name,battributeBtn.tag );
        }
        
    }
    
    _lastBtn = battributeBtn;
}

//计算高度
-(CGFloat)getCellHeightByPriceModel:(QGAttrPriceListModel *)priceModel
{
    //    //计算高度
    NSLog( @"ssssssssssss %@",priceModel.attribute_value)  ;
    CGFloat totalWidth = 0;
    CGFloat totalHeight = 0;
    CGFloat bgViewHeight = 0;//背景view的高度
    if ([priceModel.attribute_value isKindOfClass:[NSArray class]])
    {
        for (int i = 0; i < priceModel.attribute_value.count ; i ++)
        {
            //拿到里面的属性名字
            NSDictionary *dic = priceModel.attribute_value[i];
            QGAttributeValueModel *valueModel = [QGAttributeValueModel mj_objectWithKeyValues:dic];
            
            //计算高度
            CGSize size = [SAUtils getCGSzieWithText:valueModel.value width:SCREEN_WIDTH - 30 height:999 font:[UIFont systemFontOfSize:13]];
            
            //间距
            totalWidth += 25;
            totalWidth +=size.width;
            
            //如果当前宽度 加上下一个的宽度大于SCREEN_WIDTH - 30 换行
            if ((i + 1) < priceModel.attribute_value.count)
            {
                NSDictionary *nextDic = priceModel.attribute_value[i+1];
                QGAttributeValueModel *nextValueModel = [QGAttributeValueModel mj_objectWithKeyValues:nextDic];
                CGSize nextSize = [SAUtils getCGSzieWithText:nextValueModel.value width:SCREEN_WIDTH - 30 height:999 font:[UIFont systemFontOfSize:13]];
                if (totalWidth + nextSize.width > SCREEN_WIDTH - 30)
                {
                    totalHeight += ((totalWidth / SCREEN_WIDTH - 30) * (size.height + 10 )+ 5);
                    //清除宽度 从0开始
                    totalWidth = 0;
                    bgViewHeight += 35;
                }
            }
            //如果大于SCREEN_WIDTH - 30 换行
            if (totalWidth > SCREEN_WIDTH - 30)
            {
                totalHeight += ((totalWidth / SCREEN_WIDTH - 30) * (size.height + 10 ));
                bgViewHeight += ((totalWidth / SCREEN_WIDTH - 30) * (size.height + 10 )+ 5);
                //清除宽度 从0开始
                totalWidth = 0;
            }else //只有一行的高度
            {
                bgViewHeight = 30;
            }
        }
        return bgViewHeight + 50;
    }
    else
    {
        return 0;
    }
}
@end
