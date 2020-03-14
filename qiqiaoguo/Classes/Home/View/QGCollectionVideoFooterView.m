//
//  QGCollectionVideoFooterView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/7.
//
//

#import "QGCollectionVideoFooterView.h"

@implementation QGCollectionVideoFooterView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
     [self footerView];
    }
    return self;
}
- (void)footerView {
    UIView *view=[[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    view.frame=CGRectMake(0, 0, SCREEN_WIDTH, 44);
    UIView *lineView = [UIView new];
    lineView.frame = CGRectMake(10, 0, MQScreenW-20, QGOnePixelLineHeight);
    lineView.backgroundColor =  QGlineBackgroundColor;
    [view addSubview:lineView];
    //更多
    UIButton* moreBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, MQScreenW, 44)];
    [moreBtn setTitleFont:FONT_CUSTOM(15)];
    [moreBtn setTitleColor:[UIColor colorFromHexString:@"999999"]];
  [moreBtn setImage:[UIImage imageNamed:@"drown-icon"] forState:(UIControlStateNormal)];
  //  [moreBtn setImage:[UIImage imageNamed:@"cell_right_arrow"] forState:UIControlStateSelected];
    [moreBtn setTitle:@"展开更多" forState:UIControlStateNormal];
// [moreBtn setTitle:@"查看更多" forState:UIControlStateSelected];
    [moreBtn.titleLabel sizeToFit];
    [moreBtn.imageView sizeToFit];
    [moreBtn setTitleEdgeInsets:UIEdgeInsetsMake(0,-15 , 0, 0)];
    [moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (moreBtn.titleLabel.width+5)*2, 0, 5)];
    [view addSubview:moreBtn];
    [moreBtn addTarget:self action:@selector(moreBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.btn = moreBtn;
    [self addSubview:view];
}


- (void)moreBtnClicked:(UIButton *)sender {
      self.open = !self.isOpen;
    if ([self.delegate respondsToSelector:@selector(collectionVideoFooterViewMoreBtnClicked:)]) {
        [self.delegate collectionVideoFooterViewMoreBtnClicked:self];
    }
}

@end
