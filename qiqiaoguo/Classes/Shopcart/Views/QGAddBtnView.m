//
//  QGAddBtnView .m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import "QGAddBtnView.h"


@interface QGAddBtnView()



@end

@implementation QGAddBtnView

+ (instancetype)addBtnView
{
    // loadNibNamed 会将名为AppInfoView中定义的所有视图全部加载出来，并且按照XIB中定义的顺序，返回一个视图的数组
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"QGAddBtnView" owner:nil options:nil];
    return [array firstObject];
}





@end
