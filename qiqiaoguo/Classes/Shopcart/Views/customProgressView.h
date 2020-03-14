//
//  customProgressView.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/12.
//
//

#import <UIKit/UIKit.h>

@interface customProgressView : UIView
@property (nonatomic,assign)float progress;
/**背景颜色*/
@property (nonatomic,strong)UIColor *progressViewBackGroundCorlor;
/**进度条颜色*/
@property (nonatomic,strong)UIColor *progressViewCorlor;
/**进度条画框颜色*/
@property (nonatomic,strong)UIColor *progressViewBorderColor;
/**填充文字*/
@property (nonatomic,strong)NSString *progressViewFillContentLab;
/**填充字体大小*/
@property (nonatomic,strong)UIFont *progressViewFillLabFont;
- (id)initWithFrame:(CGRect)frame withTheProgress:(float)progress;
@end
