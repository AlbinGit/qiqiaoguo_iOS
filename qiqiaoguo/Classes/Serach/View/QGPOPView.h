//
//  QGPOPView.h
//  qiqiaoguo
//
//  Created by cws on 16/7/7.
//
//

#import <UIKit/UIKit.h>


#define kTriangleHeight 8.0
#define kTriangleWidth 10.0
#define kPopOverLayerCornerRadius 5.0


@class QGPOPView;
@protocol QGPOPViewDelegate <NSObject>

@optional
- (void)popViewDidClickButton:(UIButton *)button;
@end

@interface QGPOPView : UIView

@property (nonatomic, weak) id<QGPOPViewDelegate> delegate;

- (void)showFrom:(UIView *)from;

@end
