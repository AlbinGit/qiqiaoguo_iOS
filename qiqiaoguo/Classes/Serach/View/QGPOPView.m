//
//  QGPOPView.m
//  qiqiaoguo
//
//  Created by cws on 16/7/7.
//
//

#import "QGPOPView.h"

@interface PopOverContainerView : UIView

@property (nonatomic, strong) CAShapeLayer *popLayer;
@property (nonatomic, assign) CGFloat  apexOftriangelX;
@property (nonatomic, strong) UIColor *layerColor;


@end

@implementation PopOverContainerView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"frame" options:0 context:NULL];
        
    }
    
    return self;
}
- (CAShapeLayer *)popLayer
{
    if (nil == _popLayer) {
        _popLayer = [[CAShapeLayer alloc]init];
        [self.layer addSublayer:_popLayer];
    }
    
    return _popLayer;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"frame"]) {
        CGRect newFrame = CGRectNull;
        if([object valueForKeyPath:keyPath] != [NSNull null]) {
            newFrame = [[object valueForKeyPath:keyPath] CGRectValue];
            [self setLayerFrame:newFrame];
            
        }
    }
}


- (void)setLayerFrame:(CGRect)frame
{
    float apexOfTriangelX;
    if (_apexOftriangelX == 0) {
        apexOfTriangelX = frame.size.width - 60;
    }else
    {
        apexOfTriangelX = _apexOftriangelX;
    }
    
    // triangel must between left corner and right corner
    if (apexOfTriangelX > frame.size.width - kPopOverLayerCornerRadius) {
        apexOfTriangelX = frame.size.width - kPopOverLayerCornerRadius - 0.5 * kTriangleWidth;
    }else if (apexOfTriangelX < kPopOverLayerCornerRadius) {
        apexOfTriangelX = kPopOverLayerCornerRadius + 0.5 * kTriangleWidth;
    }
    
    
    CGPoint point0 = CGPointMake(apexOfTriangelX, 0);
    CGPoint point1 = CGPointMake(apexOfTriangelX - 0.5 * kTriangleWidth, kTriangleHeight);
    CGPoint point2 = CGPointMake(kPopOverLayerCornerRadius, kTriangleHeight);
    CGPoint point2_center = CGPointMake(kPopOverLayerCornerRadius, kTriangleHeight + kPopOverLayerCornerRadius);
    
    CGPoint point3 = CGPointMake(0, frame.size.height - kPopOverLayerCornerRadius);
    CGPoint point3_center = CGPointMake(kPopOverLayerCornerRadius, frame.size.height - kPopOverLayerCornerRadius);
    
    CGPoint point4 = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, frame.size.height);
    CGPoint point4_center = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, frame.size.height - kPopOverLayerCornerRadius);
    
    CGPoint point5 = CGPointMake(frame.size.width, kTriangleHeight + kPopOverLayerCornerRadius);
    CGPoint point5_center = CGPointMake(frame.size.width - kPopOverLayerCornerRadius, kTriangleHeight + kPopOverLayerCornerRadius);
    
    CGPoint point6 = CGPointMake(apexOfTriangelX + 0.5 * kTriangleWidth, kTriangleHeight);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point0];
    [path addLineToPoint:point1];
    [path addLineToPoint:point2];
    [path addArcWithCenter:point2_center radius:kPopOverLayerCornerRadius startAngle:3*M_PI_2 endAngle:M_PI clockwise:NO];
    
    [path addLineToPoint:point3];
    [path addArcWithCenter:point3_center radius:kPopOverLayerCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point4];
    [path addArcWithCenter:point4_center radius:kPopOverLayerCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
    
    [path addLineToPoint:point5];
    [path addArcWithCenter:point5_center radius:kPopOverLayerCornerRadius startAngle:0 endAngle:3*M_PI_2 clockwise:NO];
    
    [path addLineToPoint:point6];
    [path closePath];
  
    self.popLayer.path = path.CGPath;
    self.popLayer.fillColor = _layerColor? _layerColor.CGColor : [UIColor whiteColor].CGColor;
   
}

- (void)setApexOftriangelX:(CGFloat)apexOftriangelX
{
    _apexOftriangelX = apexOftriangelX;
    [self setLayerFrame:self.frame];
    
}

- (void)setLayerColor:(UIColor *)layerColor
{
    _layerColor = layerColor;
    [self setLayerFrame:self.frame];
}


- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"frame"];
}
@end


//------------------------------

@interface QGPOPView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) PopOverContainerView *containerView; // black backgroud container

@end


@implementation QGPOPView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self configcontent];
        
        
    }
    return self;
}


- (void)configcontent{
    
    UIView *contentView = [UIView new];
    UIButton *courseButton = [self configButtonTitle:@"课程" image:@"search-course"];
//    UIButton *institutionsButton = [self configButtonTitle:@"机构" image:@"search-institutions"];
//    UIButton *goodsButton = [self configButtonTitle:@"商品" image:@"search-goods"];
    UIButton *institutionsButton = [self configButtonTitle:@"老师" image:@"search-institutions"];

    UIView * ButtonBottomLine = [UIView new];
    ButtonBottomLine.backgroundColor = QGCellbottomLineColor;
    
    UIView * ButtonBottomLine2 = [UIView new];
    ButtonBottomLine2.backgroundColor = QGCellbottomLineColor;
    
    [contentView addSubview:courseButton];
    [contentView addSubview:ButtonBottomLine];
    [contentView addSubview:institutionsButton];
  //  [contentView addSubview:ButtonBottomLine2];
   // [contentView addSubview:goodsButton];
    
    courseButton.tag = 0;
    institutionsButton.tag = 1;
    //goodsButton.tag = 2;
    
    [courseButton sizeToFit];
    [institutionsButton sizeToFit];
 //   [goodsButton sizeToFit];
    
    courseButton.frame = CGRectMake(0, 0, courseButton.width, courseButton.height);
    ButtonBottomLine.frame = CGRectMake(0, courseButton.bottom, courseButton.width, QGOnePixelLineHeight);
    institutionsButton.frame = CGRectMake(0, ButtonBottomLine.bottom, institutionsButton.width, institutionsButton.height);
//    ButtonBottomLine2.frame = CGRectMake(0, institutionsButton.bottom, courseButton.width, QGOnePixelLineHeight);
    //goodsButton.frame = CGRectMake(0, ButtonBottomLine2.bottom, goodsButton.width, goodsButton.height);
    
    contentView.frame = CGRectMake(0, 0, courseButton.width, institutionsButton.bottom);
    
    CGRect contentFrame = contentView.frame;
    
    contentFrame.origin.y = kTriangleHeight + 5;
    contentView.frame = contentFrame;
    
    
    CGRect  temp = self.containerView.frame;
    temp.size.width = CGRectGetMaxX(contentFrame); // left and right space are 2.0
    temp.size.height = CGRectGetMaxY(contentFrame);
    
    self.containerView.frame = temp;
    
    [self.containerView addSubview:contentView];
    
}

- (UIButton *)configButtonTitle:(NSString *)title image:(NSString *)imageName{
    
    UIButton *button = [UIButton new];
    button.titleFont = [UIFont systemFontOfSize:14.0];
//    button.title = title;
	[button setTitle:title forState:UIControlStateNormal];
    button.titleColor = QGMainContentColor;
    button.image = [UIImage imageNamed:imageName];
    button.contentEdgeInsets = UIEdgeInsetsMake(15, 30, 15, 35);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4);
    
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)buttonClick:(UIButton *)button{
    
    [self dismiss];
    
    if ([self.delegate respondsToSelector:@selector(popViewDidClickButton:)]) {
        [self.delegate popViewDidClickButton:button];
    }
    
}

- (PopOverContainerView *)containerView
{
    if (nil == _containerView) {
        _containerView = [[PopOverContainerView alloc]init];
        _containerView.clipsToBounds = YES;
        [self addSubview:_containerView];
    }
    
    return _containerView;
}


- (void)showFrom:(UIView *)from
{
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self];
    
    self.frame = window.bounds;
    
    CGRect newFrame = [from convertRect:from.bounds toView:window];
    CGRect containerViewFrame = self.containerView.frame;
    containerViewFrame.origin.y =  CGRectGetMaxY(newFrame) + 5;
    
    self.containerView.frame = containerViewFrame;
    CGRect frame = self.containerView.frame;
    frame.origin.x = CGRectGetMinX(newFrame);
    self.containerView.frame = frame;
    self.containerView.apexOftriangelX = CGRectGetWidth(from.frame)/2;
    self.containerView.frame = CGRectMake(self.containerView.frame.origin.x,self.containerView.frame.origin.y, 0, 0);
    self.containerView.frame = frame;
    CGPoint center = self.containerView.center;
    
    self.containerView.center = CGPointMake(self.containerView.frame.origin.x + 20,self.containerView.frame.origin.y);
    self.containerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.transform = CGAffineTransformMakeScale(1, 1);
        self.containerView.center = center;
    }completion:^(BOOL finished) {
    }];

}

- (void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        self.containerView.center = CGPointMake(self.containerView.frame.origin.x + 20,self.containerView.frame.origin.y);
        self.containerView.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismiss];
}


@end
