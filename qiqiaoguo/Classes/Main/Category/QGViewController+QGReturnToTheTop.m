//
//  QGViewController+QGReturnToTheTop.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/23.
//
//

#import "QGViewController+QGReturnToTheTop.h"


@implementation QGViewController (QGReturnToTheTop)

static const void *QGReturnToTheTopKey = &QGReturnToTheTopKey;
static const void *QGReturnToTheTopBlockKey = &QGReturnToTheTopBlockKey;



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY >MQScreenH) {
        
        self.returnTopButton.hidden = NO;
    }else {
        
        if (offsetY < MQScreenW) {
            
            self.returnTopButton.hidden = YES;
        }
        
    }
}

- (void)addReturnToTheTopButtonFrame:(CGRect)buttonCGRect WithBackgroundImage:(UIImage *)image CallBackblock:(void(^)())Callblock
{
    self.returnTopButton = [[UIButton alloc] initWithFrame:buttonCGRect];
    [self.returnTopButton addTarget:self action:@selector(returnToTheTop) forControlEvents:UIControlEventTouchUpInside];
    [self.returnTopButton setBackgroundImage:image forState:UIControlStateNormal];
    self.returnToTheTopBlock = Callblock;
    self.returnTopButton.hidden = YES;
    [self.view addSubview:self.returnTopButton];
}

- (void)returnToTheTop
{
    if (self.returnToTheTopBlock) {
        self.returnToTheTopBlock();
    }
}

#pragma mark - get和set方法
- (UIButton *)returnTopButton
{
    return objc_getAssociatedObject(self, QGReturnToTheTopKey);
}

- (void)setReturnTopButton:(UIButton *)returnTopButton
{
    objc_setAssociatedObject(self, QGReturnToTheTopKey, returnTopButton, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (QGReturnToTheTopBlock)returnToTheTopBlock
{
    return objc_getAssociatedObject(self, QGReturnToTheTopBlockKey);
}

- (void)setReturnToTheTopBlock:(QGReturnToTheTopBlock)returnToTheTopBlock
{
    objc_setAssociatedObject(self, QGReturnToTheTopBlockKey, returnToTheTopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}


@end
