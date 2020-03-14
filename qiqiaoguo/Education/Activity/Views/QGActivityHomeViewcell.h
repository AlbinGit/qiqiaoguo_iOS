//
//  QGActivityHomeViewcellTableViewCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/5.
//
//

#import <UIKit/UIKit.h>
#import "QGActlistHomeModel.h"
@interface QGActivityHomeViewcell : UITableViewCell
@property (strong,nonatomic) UIImageView *imageview;
@property (strong, nonatomic)  UIImageView *headimage;

@property (strong, nonatomic)  UIButton *actadress;
@property (strong, nonatomic)  UIButton *dateTime;
@property (strong, nonatomic)  UIButton *userrang;
@property (strong, nonatomic)  UILabel *actname;
@property (strong, nonatomic)  UIButton *signtips;
@property (strong, nonatomic)  UIButton *price;

@property (nonatomic,strong) QGActlistHomeModel*actModel;

@end
