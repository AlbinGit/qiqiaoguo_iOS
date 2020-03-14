//
//  QGSerachViewController.h
//  qiqiaoguo
//
//  Created by cws on 16/7/7.
//
//

#import "QGViewController.h"
#import "QGSearchNavView.h"


@interface QGSerachViewController : QGViewController

@property (nonatomic, assign) QGSearchOptionType searchOptionType;
@property (nonatomic, copy) NSString *keyword;

@end
