//
//  QGAdiceCell.h
//  qiqiaoguo
//
//  Created by cws on 16/6/13.
//
//

#import <UIKit/UIKit.h>
#import "QGCell.h"

typedef NS_ENUM(NSInteger, QGUserAdiceType) {
    QGUserAdiceTypePost = 100,  // 我的发布
    QGUserAdiceTypeActivity,      // 我的参与
    QGUserAdiceTypeCollection,      // 我的收藏
//    
//    QGUserAdiceTypeCollection,
//    QGUserAdiceTypeFollow,
//    QGUserAdiceTypeActivity,
//    QGUserAdiceTypeAddress,
//    QGUserAdiceTypeComment = 300,  // 意见反馈
//    QGUserAdiceTypeTel
};
@interface QGAdiceCell : QGCell

@property (nonatomic, assign) QGUserAdiceType AdviceType;
@property (nonatomic, assign) BOOL showSeparatorLine;
@property (nonatomic, strong) UIImageView *promptImageView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIImageView *indicatorImageView;
@property (nonatomic, strong) UIView *solidLine;

@end
