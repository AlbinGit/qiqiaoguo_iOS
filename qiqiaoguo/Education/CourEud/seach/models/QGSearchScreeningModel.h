//
//  QGSearchScreeningModel.h
//  qiqiaoguo
//
//  Created by cws on 16/9/8.
//
//

#import "QGModel.h"

@interface QGSearchScreeningModel : QGModel

@property (nonatomic, copy) NSArray *courseCateList;
@property (nonatomic, copy) NSArray *orgCateList;
@property (nonatomic, copy) NSArray *areaList;
@property (nonatomic, copy) NSArray *sortList;

@end

@interface QGScreeningModel : QGModel

@property (nonatomic, copy)NSString *name;
@property (nonatomic, assign) NSInteger courseID;
@property (nonatomic, copy)NSArray *subListArray;

@end
