//
//  QGActSignSaveViewController.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/8/3.
//
//

#import "QGViewController.h"
@class QGActSignSaveViewController,QGContact;

@protocol QGActSignSaveViewControllerDelegate <NSObject>

@optional
// 通知代理,接收数据
// 什么时候通知代理,点击添加按钮的时候通知代理
- (void)addViewController:(QGActSignSaveViewController *)infoVc didAddContact:(NSMutableDictionary *)contact;

@end
@interface QGActSignSaveViewController : QGViewController
@property (nonatomic, strong) QGContact *contact;
@property (nonatomic, weak) id<QGActSignSaveViewControllerDelegate> delegate;
@property (nonatomic,strong) NSArray *applyFieldList;
@property (nonatomic,strong) NSMutableArray *applyArr;
@property (nonatomic, strong)NSMutableDictionary *applyArrDic;
@end
