//
//  QGRegisterViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/6/28.
//
//

#import "QGViewController.h"

typedef NS_ENUM(NSUInteger, QGDetectionType) {
    QGDetectionTypeRegister,
    QGDetectionTypeBinding,
};

@interface QGRegisterViewController : QGViewController

@property (nonatomic, assign) QGDetectionType type;

@end
