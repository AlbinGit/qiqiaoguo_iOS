//
//  QGSearchView.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/6/22.
//
//

#import "QGSearchView.h"

@implementation QGSearchView
-(QGSearchView *)loadQGSearchView
{
    QGSearchView *searchView = (QGSearchView *) [[NSBundle mainBundle] loadNibNamed:@"QGSearchView" owner:self options:nil][0];
    searchView.backgroundColor = COLOR(242, 243, 244, 1);
    
    [searchView.searchText setBackgroundColor:COLOR(242, 243, 244, 1)];
    searchView.searchText.textColor= COLOR(183, 184, 185, 1);
    
    searchView.layer.cornerRadius = 3.f;
    searchView.layer.masksToBounds =YES;

    return searchView;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
