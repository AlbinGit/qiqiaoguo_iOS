//
//  MQAddBtnView.h
//  qiqiaoguo
//
//  Created by 谢明强 on 16/6/1.
//  Copyright © 2016年 MQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MQAddBtnView;

@protocol MQAddBtnViewDelegate <NSObject>
@optional
- (void)AddBtnMenu:(MQAddBtnView *)menu didSelectedButtonToIndex:(NSUInteger)toIndex;
@end

@interface MQAddBtnView : UIView
@property (nonatomic, weak) id<MQAddBtnViewDelegate> delegate;
@end
