//
//  QGOrderAddressViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/26.
//
//

#import "QGViewController.h"
#import "QGAddressModel.h"

@class QGOrderAddressViewController;

@protocol QGLogisticsEditViewControllerDelegate <NSObject>

- (void)logisticsEditViewController:(QGOrderAddressViewController *)vc
               updateAddressSuccess:(QGAddressModel *)address;

- (void)logisticsEditViewController:(QGOrderAddressViewController *)vc
                updateAddressFailed:(NSError *)error;

@end

@interface QGOrderAddressViewController : QGViewController

@property (nonatomic, strong)QGAddressModel *address;
@property (nonatomic, strong) NSMutableArray *oldDistrictIDs;
@property (weak, nonatomic) id <QGLogisticsEditViewControllerDelegate> delegate;

@end
