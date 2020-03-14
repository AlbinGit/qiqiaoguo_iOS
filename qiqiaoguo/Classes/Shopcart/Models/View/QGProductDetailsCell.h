//
//  QGProductDetailsCell.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/7/17.
//
//

#import <UIKit/UIKit.h>

@interface QGProductDetailsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *storeBtnClick;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (weak, nonatomic) IBOutlet UIButton *orgBtn;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sugn;
@end
