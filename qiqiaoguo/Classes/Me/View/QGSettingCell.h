//
//  QGSettingCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/12.
//
//

#import "QGCell.h"

@interface QGSettingCell : QGCell

@property (nonatomic, assign) BOOL showSolidLine;
@property (nonatomic, assign) BOOL showCache;
@property (nonatomic, strong) NSString *text;

@end
