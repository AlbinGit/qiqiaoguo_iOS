//
//  QGAttributeBuyCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//
typedef void(^QGAttributeBuyCellBlock)(int num);

#import <UIKit/UIKit.h>

@interface QGAttributeBuyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyNumLbl;
@property(nonatomic,strong)QGAttributeBuyCellBlock buyCellBlock;
@end
