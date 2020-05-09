//
//  QGClassPoplView.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/8.
//

#import <UIKit/UIKit.h>
@class QGClassListModel;
NS_ASSUME_NONNULL_BEGIN
typedef void(^SelectClassBlock)(QGClassListModel *model,NSIndexPath * indexPath);
typedef void(^SelectClassLocalBlock)(NSString *localName);

@interface QGClassPoplView : UIView

@property (nonatomic,copy) SelectClassBlock selectBlock;
@property (nonatomic,strong) UIButton *localButton;
//@property (nonatomic,strong) NSIndexPath *myIndexPath;
- (void)cityBtnFrameWithTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
