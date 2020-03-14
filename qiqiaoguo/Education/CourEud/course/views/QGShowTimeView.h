//
//  QGShowTimeView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/20.
//
//

#import <UIKit/UIKit.h>
#import "QGCoursDetailModel.h"
@interface QGShowTimeView : UIView<UITableViewDataSource,UITableViewDelegate>

/**时间安排数据*/
@property (nonatomic,strong)NSDictionary *dataDic;
@property (nonatomic,strong) QGCourseDetSectionListModel *sectionList;

@property (nonatomic,strong)QGCoursDetailModel *itemlist;
@end
