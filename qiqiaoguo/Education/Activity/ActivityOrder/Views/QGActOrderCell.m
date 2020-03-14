//
//  QGActOrderCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGActOrderCell.h"


@interface QGActOrderCell ()
@property (weak, nonatomic) IBOutlet UIButton *plusButton;
@property (nonatomic,strong) UILabel *priceCount;
@property (weak, nonatomic) IBOutlet UIButton *minusButton;


@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UIButton *name;
@end

@implementation QGActOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
   //
    
}

/**
 *  加号点击
 */
- (IBAction)plusButtonClick {
 
    _ticketList.pricecount ++ ;
   [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];
    self.countLabel.text = [NSString stringWithFormat:@"%d",_ticketList.pricecount];
      self.minusButton.enabled = YES;
    if (_ticketList.pricecount   ==_ticketList.limitquantity ) {
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
    _ticketList.pricecount -- ;
     self.plusButton.enabled = YES;
    [_plusButton setImage:[UIImage resizedImage:@"increase-use"]];
    self.countLabel.text = [NSString stringWithFormat:@"%d",_ticketList.pricecount];
    if (_ticketList.pricecount >0) {
         [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];
         self.countLabel.text = [NSString stringWithFormat:@"%d",_ticketList.pricecount];
            self.minusButton.enabled =YES;
    }else {
      [self.minusButton setImage:[UIImage resizedImage:@"Reduction-no-use"]];

        self.minusButton.enabled = NO;
    }
    
    if ([self.delegate respondsToSelector:@selector(orderCellDidClickMinusButton:)]) {
        
        [self.delegate orderCellDidClickMinusButton:self];
    }
}
- (void)setTicketList:(QGActlistTicketListModel *)ticketList {
    _ticketList = ticketList;
    [_name setTitle:[NSString stringWithFormat:@"%@/人",ticketList.name]];
 
    _price.text = [NSString stringWithFormat:@"￥%@",ticketList.price];
     self.countLabel.text = [NSString stringWithFormat:@"%d",_ticketList.pricecount];

    if (ticketList.pricecount ==0) {
          [self.minusButton setImage:[UIImage resizedImage:@"Reduction-no-use"]];
        self.minusButton.enabled = NO;
    }else {
        
        [self.minusButton setImage:[UIImage resizedImage:@"Reduction-use"]];
        self.minusButton.enabled =YES;
    }
    if (_ticketList.pricecount   ==_ticketList.limitquantity ) {
        [_plusButton setImage:[UIImage resizedImage:@"increase-no-use"]];
        self.plusButton.enabled = NO;
        
    }else {
        [_plusButton setImage:[UIImage resizedImage:@"increase-use"]];
        self.plusButton.enabled = YES;
    }
}
@end
