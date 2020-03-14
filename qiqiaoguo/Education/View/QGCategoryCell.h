//
//  QGCategoryCell.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/14.
//
//

#import <UIKit/UIKit.h>
#import "QGEudCategoryHttpDownload.h"
//商品分类
@interface QGCategoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *categoryTitleLbl;
PropertyStrong(QGCategroyModel, model);
@property (weak, nonatomic) IBOutlet UIImageView *image;


-(void)changeColor;
@end
