//
//  QGOptimalProductGridLayout.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/11.
//
//

#import <UIKit/UIKit.h>
#import "QGOptimalProductSubjrctListModel.h"
typedef NS_ENUM(NSInteger, QGOptimalProductGridLayoutType) {

     QGOptimalProductGridLayoutOne = 0,//1_1
     QGOptimalProductGridLayoutTwo,//4_2
     QGOptimalProductGridLayoutThree,//2_1
     QGOptimalProductGridLayoutFour,//4_3
     QGOptimalProductGridLayoutFive,//4_1
     QGOptimalProductGridLayoutSix,//3_3
     QGOptimalProductGridLayoutSeven,//3_2
     QGOptimalProductGridLayoutEight,//3_1
     QGOptimalProductGridLayoutNine//2_2
  
};
@interface QGOptimalProductGridLayout : UICollectionViewLayout
/**类型*/
@property (nonatomic, assign) QGOptimalProductGridLayoutType cellType;
@end
