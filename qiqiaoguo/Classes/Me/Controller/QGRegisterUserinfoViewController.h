//
//  QGRegisterUserinfoViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/6/29.
//
//

#import "QGViewController.h"

@interface QGRegisterUserinfoViewController : QGViewController

@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *code;

- (instancetype)initWithMobile:(NSString *)mobile code:(NSString *)code;

@end
