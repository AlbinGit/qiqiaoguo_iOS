//
//  QGActOrderCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import <UIKit/UIKit.h>

@class QGActOrderCell;
@protocol QGActOrderCellDelegate<NSObject>
@optional
- (void)orderCellDidClickPlusButton:(QGActOrderCell*)cell;
- (void)orderCellDidClickMinusButton:(QGActOrderCell *)cell;

@end


@interface QGActOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic,strong) QGActlistTicketListModel *ticketList;
/** 代理属性*/
@property (nonatomic, weak) id<QGActOrderCellDelegate> delegate;

@property(nonatomic ,assign)NSIndexPath* indexminRow;

@end
