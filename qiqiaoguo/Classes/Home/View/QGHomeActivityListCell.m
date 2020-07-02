//
//  QGHomeActivityListCell.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/18.
//
//

#import "QGHomeActivityListCell.h"
#import "QGSearchResultViewController.h"

@interface QGHomeActivityListCell ()

@property (nonatomic,strong) UIButton *courseBtn;
@property (nonatomic,strong) UIButton *orgBtn ;


@end


@implementation QGHomeActivityListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        CGFloat width = MQScreenW/2-1;
        CGFloat height = width*0.38;
        UIImageView  *im= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  width, height)];
        im.image =  [UIImage imageNamed:@"img_附近课程"];
        [self.contentView addSubview:im];
        im.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction)];
        [im addGestureRecognizer:tapImage];
        UIImageView  *org= [[UIImageView alloc] initWithFrame:CGRectMake(im.maxX+1, 0, width, height)];
        org.userInteractionEnabled = YES;
        org.image =[UIImage imageNamed:@"img_附近老师"];
        [self.contentView addSubview:org];
        UITapGestureRecognizer *tapImage1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction1)];
        [org addGestureRecognizer:tapImage1];
        self.backgroundColor = COLOR(242, 243, 242, 1);
        
    }
    return self;
}

- (void)showImageAction {
    QGSearchResultViewController *vc = [[QGSearchResultViewController alloc] init];
    vc.searchOptionType = QGSearchOptionTypeCourse;
    vc.nearbyAreaID = _nearbyAreaID;
    vc.areaID = _nearbyAreaID;
    vc.longitude = _longitude;
    vc.latitude = _latitude;
    UIViewController *viewController =[SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
    
}

- (void)showImageAction1 {
    QGSearchResultViewController *vc = [[QGSearchResultViewController alloc] init];
    vc.searchOptionType = QGSearchOptionTypeInstitution;
    vc.nearbyAreaID = _nearbyAreaID;
    vc.areaID = _nearbyAreaID;
    vc.longitude = _longitude;
    vc.latitude = _latitude;
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
    
}

@end
