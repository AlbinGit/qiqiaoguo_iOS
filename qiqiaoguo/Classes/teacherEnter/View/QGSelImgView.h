//
//  QGSelImgView.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/17.
//

#import <UIKit/UIKit.h>

typedef void(^SelBlock)(BOOL isSel);
NS_ASSUME_NONNULL_BEGIN

@interface QGSelImgView : UIView
@property (nonatomic,strong) UIImageView *selImgView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UIButton *selButton;
@property (nonatomic,strong) SelBlock selBlock;

- (void)chageSelect:(BOOL)isSel;
@end

NS_ASSUME_NONNULL_END
