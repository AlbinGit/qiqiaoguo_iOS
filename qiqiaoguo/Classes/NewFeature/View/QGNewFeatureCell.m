//
//  QGNewFeatureCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/26.
//
//

#import "QGNewFeatureCell.h"



#import "QGTabBarViewController.h"

@interface QGNewFeatureCell ()
@property (nonatomic, weak) UIButton *startButton;
@property (nonatomic,strong) UIButton *nameButton;
@property (nonatomic,strong) UIButton *signButton;
@property (nonatomic,strong )NSArray *nameArr;
@property (nonatomic,strong )NSArray *signArr;
@end

@implementation QGNewFeatureCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameArr =[NSArray arrayWithObjects:@"成为一件有趣的事",@"让健康快乐陪伴成长",@"妈妈们都在等你", nil];
         _signArr =[NSArray arrayWithObjects:@"让孩子学习",@"亲子活动",@"妈妈专属部落", nil];
    }
    return self;
}
- (UIButton *)startButton
{
    if (_startButton == nil) {
       
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
        [btn sizeToFit];
         btn.center = CGPointMake(self.width * 0.5, self.height * 0.87);
        [btn setTitle:@"进入七巧国"];
        [btn setTitleFont:FONT_CUSTOM(15)];
        [btn setTitleColor:[UIColor colorFromHexString:@"6dc296"] forState:(UIControlStateNormal)];
     
        [btn addTarget:self action:@selector(start) forControlEvents:UIControlEventTouchDown];
        [self addSubview:btn];
        _startButton = btn;
        
    
        
        
    }
    return _startButton;
}

- (UIButton *)nameButton {
    if (_nameButton ==nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        // [btn setBackgroundImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
        [btn sizeToFit];
        btn.center = CGPointMake(self.width * 0.5, self.height * 0.80);
        
        btn.width = MQScreenW;
        btn.x= 0;
  
         [btn setTitleFont:[UIFont systemFontOfSize:18]];
        [btn setTitleColor:[UIColor colorFromHexString:@"5f626c"] forState:(UIControlStateNormal)];
      
        
        [self addSubview:btn];
        _nameButton = btn;
    }
    return  _nameButton;
}
- (UIButton *)signButton {
    if (_signButton ==nil) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      
        [btn sizeToFit];
        btn.center = CGPointMake(self.width * 0.5, self.height * 0.75);
        
        btn.width = MQScreenW;
        btn.x= 0;
        
        [btn setTitleFont:[UIFont systemFontOfSize:17]];
        [btn setTitleColor:COLOR(85, 87, 98, 1) forState:(UIControlStateNormal)];

        
        [self addSubview:btn];
        _signButton = btn;
    }
    return  _signButton;
}

// 点击立即体验按钮调用
- (void)start
{
    // 跳转到主框架界面
    // 切换界面:push,modal,tarBarVC
    // 修改窗口的根控制器
     [[SAProgressHud sharedInstance]showWaitWithWindow];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[QGTabBarViewController alloc] init];
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        _imageView = imageView;
        
        [self.contentView addSubview:imageView];
    }
    
    return _imageView;
}

- (void)setImage:(UIImage *)image
{
    _image = image;

    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, MQScreenW, MQScreenW*11/9);
}
- (void)setIndexPath:(NSIndexPath *)indexPath count:(int)count
{
    

    self.nameButton.hidden = NO;
    self.signButton.hidden = NO;
    [self.nameButton setTitle:_nameArr[indexPath.item]];
     [self.signButton setTitle:_signArr[indexPath.item]];
    if (indexPath.item == count - 1) { // 当前cell是最后一个cell
        self.startButton.hidden = NO;
    }else{ // 如果不是最后一个cell,
        self.startButton.hidden = YES;
    }

}

@end
