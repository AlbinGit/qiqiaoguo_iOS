//
//  QGGoodLogisticsViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/28.
//
//

#import "QGViewController.h"
#import "QGTableView.h"
#import "BLULogistics.h"
#import "QGGoodLogisticsInfoView.h"
#import "QGGoodLogisticsHeaderView.h"

@interface QGGoodLogisticsViewController : QGViewController

@property (nonatomic, strong) QGTableView *tableView;
@property (nonatomic, strong) QGGoodLogisticsHeaderview *headerView;
@property (nonatomic, strong) QGGoodLogisticsInfoView *infoView;

@property (nonatomic, strong) NSNumber *orderID;
@property (nonatomic, strong) BLULogistics *logistics;

- (instancetype)initWithOrderID:(NSNumber *)orderID;

@end
