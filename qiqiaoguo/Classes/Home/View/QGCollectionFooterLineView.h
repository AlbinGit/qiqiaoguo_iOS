//
//  QGCollectionHeaderLineView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/13.
//
//

#import <UIKit/UIKit.h>
@class QGCollectionFooterLineView;

@protocol QGCollectionFooterLineViewDelegate <NSObject>

@required
- (void)collectionVideoFooterViewMoreBtnClicked:(id)sender;

@end
@interface QGCollectionFooterLineView : UICollectionReusableView
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic, assign, getter = isOpen) BOOL open;
@property (nonatomic,strong) id<QGCollectionFooterLineViewDelegate> delegate;
- (void)moreBtnClicked:(id)sender;
@end



