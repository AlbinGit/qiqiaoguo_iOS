//
//  QGSlideClassficationView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//
typedef void(^QGSlideClassficationViewBlock)(NSInteger currentIndex ,NSInteger currentTag);
#import <UIKit/UIKit.h>

@interface QGSlideClassficationView : UIView
/**记录上次选中值*/
@property (nonatomic,assign)NSInteger lastIndex;
/**字体普通状况的颜色*/
@property (nonatomic,strong)UIColor *nomoalColor;
/**字体选中颜色*/
@property (nonatomic,strong)UIColor *selectColor;
/**
 *  初始化数据
 *
 *  @param frame
 *  @param currentIndex 当前选中的索引
 *  @param titles       显示的标题数组
 *  @param isShow       是否显示下面的红线
 *
 *  @return
 */
- (id)initWithFrame:(CGRect)frame withCurrentSelectIndex:(NSInteger)currentIndex  andTitles:(NSArray *)titles;
/**
 *  获取当前选中的索引的block回调
 *
 *  @param block 
 */
- (void)getCurrentSelectIndex:(QGSlideClassficationViewBlock)block;
@end
