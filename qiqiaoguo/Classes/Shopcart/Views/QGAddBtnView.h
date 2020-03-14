//
//  QGAddBtnView .m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import <UIKit/UIKit.h>


@interface QGAddBtnView : UIButton

@property (weak, nonatomic) IBOutlet UIButton *btn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
+ (instancetype)addBtnView;
@end
