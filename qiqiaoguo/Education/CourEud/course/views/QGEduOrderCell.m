//
//  QGActOrderCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGEduOrderCell.h"


@interface QGEduOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *plusButton;

@property (weak, nonatomic) IBOutlet UIButton *minusButton;



@property (weak, nonatomic) IBOutlet UIButton *name;
@end

@implementation QGEduOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
   //

    
}
/**
 *  加号点击
 */
- (IBAction)plusButtonClick {
 
    _pricecount ++ ;
   [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];
    self.countLabel.text = [NSString stringWithFormat:@"%d",_pricecount];
    
 

    self.minusButton.enabled = YES;
    if (_pricecount   ==_avilibale_student_number.integerValue) {
        [_plusButton setImage:[UIImage resizedImage:@"increase-no-use"]];
        self.plusButton.enabled = NO;
        
    }else {
        [_plusButton setImage:[UIImage resizedImage:@"increase-use"]];
       self.plusButton.enabled = YES;
    }
    if ([self.delegate respondsToSelector:@selector(orderCellDidClickPlusButton:)]) {
        [self.delegate orderCellDidClickPlusButton:self];
    }
}
/**
 *  减号点击
 */
- (IBAction)minusButtonClick {

    
     _pricecount -- ;
     self.plusButton.enabled = YES;
    [_plusButton setImage:[UIImage resizedImage:@"increase-use"]];
    self.countLabel.text = [NSString stringWithFormat:@"%d",_pricecount];
    if (_pricecount >0) {
         [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];
         self.countLabel.text = [NSString stringWithFormat:@"%d",_pricecount];
            self.minusButton.enabled =YES;
    }else {
       [self.minusButton setImage:[UIImage resizedImage:@"Reduction-no-use"]];
 
        self.minusButton.enabled = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(orderCellDidClickMinusButton:)]) {
        
        [self.delegate orderCellDidClickMinusButton:self];
    }
}
//- (void)setTicketList:(QGActlistTicketListModel *)ticketList {
//    _ticketList = ticketList;
//
// 
//   // _price.text = [NSString stringWithFormat:@"￥%@",ticketList.price];
// 
//        _ticketList.pricecount = 1;
//         _ticketList.quantity = @"1";
//    [_plusButton setImage:[UIImage resizedImage:@"increase-use"]];
//    [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];
//    
//   
//    self.countLabel.text = [NSString stringWithFormat:@"%d",_ticketList.pricecount];
//    self.minusButton.enabled = (ticketList.pricecount > 0);
//    
//}

- (void)setClass_price:(NSString *)class_price {
    _class_price = class_price;
   _pricecount = 1;
    _price.text = [NSString stringWithFormat:@"￥%@",_class_price];
    [_plusButton setImage:[UIImage resizedImage:@"increase-use"]];
    [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];

    
    
}




@end
