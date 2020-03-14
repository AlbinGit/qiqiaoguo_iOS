//
//  QGMessageListCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/4.
//
//

#import "QGCell.h"

typedef enum : NSUInteger {
    QGMessageListTypeCard = 1,
    QGMessageListTypeOrder,
    QGMessageListTypeActivity,
} QGMessageListType;

@interface QGMessageListCell : QGCell

@property (nonatomic, assign) QGMessageListType messageListType;

- (void)setModel:(id)model;

@end
