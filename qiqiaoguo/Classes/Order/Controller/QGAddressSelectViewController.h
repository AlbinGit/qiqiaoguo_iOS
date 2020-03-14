//
//  QGAddressSelectViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/27.
//
//

#import "QGViewController.h"
#import "QGAddressModel.h"
@class QGAddressSelectViewController;

@protocol QGAddressSelectViewControllerDelegate <NSObject>

- (void)addressSelectorVCCancelUpdateDistrictIDs:(QGAddressSelectViewController *)vc;

- (void)addressSelectorVC:(QGAddressSelectViewController *)vc
     didUpdateDistrictIDs:(NSArray *)districtIDs;

- (void)addressSelectorVCFinishUpdateDistrictIDs:(QGAddressSelectViewController *)vc;

@end

@interface QGAddressSelectViewController : QGViewController

@property (nonatomic, weak) id <QGAddressSelectViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableDictionary *currentPickerState;
@property (nonatomic, strong) QGAddressModel *address;

@end
