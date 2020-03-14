//
//  QGActSignSaveViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/3.
//
//

#import "QGViewController.h"
@class QGEduSignSaveViewController,QGContact;

@protocol QGEduSignSaveViewControllerDelegate <NSObject>

@optional
// 通知代理,接收数据

- (void)addViewController:(QGEduSignSaveViewController *)infoVc didAddContact:(QGContact *)contact;

@end
@interface QGEduSignSaveViewController : QGViewController
@property (nonatomic, strong) QGContact *contact;
@property (nonatomic, weak) id<QGEduSignSaveViewControllerDelegate> delegate;
@property (nonatomic,strong) NSArray *applyFieldList;

@property (nonatomic,strong) NSMutableArray *applyArr;
@property (nonatomic, strong)NSMutableDictionary *applyArrDic;
@end
