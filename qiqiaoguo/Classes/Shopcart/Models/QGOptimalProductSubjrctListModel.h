//
//  QGOptimalProductSubjrctListModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import <Foundation/Foundation.h>

@interface QGOptimalProductSubjrctListModel : NSObject


@property (nonatomic,copy)NSString *id;

@property (nonatomic,copy)NSString *platform_id;

@property (nonatomic,copy) NSArray *cardList;


@property (nonatomic,copy)NSString *title;//标题

@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *sign;//样式


@end


@interface QGSubjrctCardListModel : NSObject
@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *activity_id;
@property (nonatomic,copy) NSString *type;//标题
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *sign;//样式
@property (nonatomic,copy) NSString*url;
@end