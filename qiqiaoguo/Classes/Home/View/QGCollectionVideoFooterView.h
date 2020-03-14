//
//  QGCollectionVideoFooterView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/7.
//
//


@class QGCollectionVideoFooterView;

@protocol QGCollectionVideoFooterViewDelegate <NSObject>

@required
- (void)collectionVideoFooterViewMoreBtnClicked:(id)sender;

@end
#import <UIKit/UIKit.h>
@interface QGCollectionVideoFooterView : UICollectionReusableView
@property (nonatomic,strong) UIButton *btn;
@property (nonatomic, assign, getter = isOpen) BOOL open;
@property (nonatomic,strong) id<QGCollectionVideoFooterViewDelegate> delegate;
- (void)moreBtnClicked:(id)sender;
@end
