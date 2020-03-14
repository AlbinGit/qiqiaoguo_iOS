//
//  QGSearchResultViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/24.
//
//

#import <UIKit/UIKit.h>
#import "QGViewController.h"
#import "QGSearchResultNavView.h"

typedef NS_ENUM(NSInteger, QGSearchResultType) {
    /**搜索机构*/
    QGSearchResultOrg = 0,
    /**搜索课程*/
    QGSearchResultCourse,
    /**搜索老师*/
    QGSearchResultTeacher
    
};
@interface QGSearchResultViewController : QGViewController
/**类型*/
//@property (nonatomic, assign) QGSearchResultType searchType;

@property (nonatomic, assign) QGSearchOptionType searchOptionType;

@property (nonatomic, assign) QGSearchOptionType oldOptionType;
/**菜单标题数组*/
@property (nonatomic, strong) NSArray * btnArray;
/**关键字*/
@property (nonatomic, copy) NSString * keyWord;
/**分类id*/
@property (nonatomic, copy) NSString * catogoryId;

@property (nonatomic, copy) NSString * brand_id;
@property (nonatomic, assign) NSInteger nearbyAreaID;

@property (nonatomic, assign) NSInteger areaID;
@property (nonatomic, assign) NSInteger sortID;
@property (nonatomic, assign) NSInteger CateID;
@property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,assign) CGFloat latitude;

- (void)shouldUpdateData;
@end
