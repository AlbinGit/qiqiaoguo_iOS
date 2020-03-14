//
//  QGUserInfoSettingViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/13.
//
//

#import "QGViewController.h"

@interface QGUserInfoSettingViewController : QGViewController

@property (nonatomic, strong) BLUUser *user;

- (instancetype)initWithUser:(BLUUser *)user;

@end
