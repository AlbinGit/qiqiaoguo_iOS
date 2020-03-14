//
//  QGActOrderCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import <UIKit/UIKit.h>

@class QGEduOrderCell;
@protocol QGEduOrderCellDelegate<NSObject>
@optional
- (void)orderCellDidClickPlusButton:(QGEduOrderCell*)cell;
- (void)orderCellDidClickMinusButton:(QGEduOrderCell *)cell;

@end


@interface QGEduOrderCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
;
/** 代理属性*/
@property (nonatomic, weak) id<QGEduOrderCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic,copy) NSString *class_price;
/** 购买数 */
@property (nonatomic, assign) int pricecount;

@property (nonatomic,copy) NSString *max_student_number ; //最多学生数
@property (nonatomic,copy) NSString *apply_student_number ;//已报名人数
@property (nonatomic,copy) NSString *avilibale_student_number ; //可报名数
@end
