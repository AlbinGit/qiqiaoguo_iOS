//
//  QGChatCell.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/20.
//

#import <UIKit/UIKit.h>
@class QGChatModel;
NS_ASSUME_NONNULL_BEGIN

@interface QGChatCell : UITableViewCell
@property (nonatomic,strong) QGChatModel *model;

@end

NS_ASSUME_NONNULL_END
