//
//  QGActivityCalendarCell.m
//  qiqiaoguo
//
//  Created by cws on 16/8/23.
//
//

#import "QGActivityCalendarCell.h"
#import "QGActCalendarViewController.h"
#import "QGActivNearViewController.h"

@interface QGActivityCalendarCell ()

@property (nonatomic,strong) UIButton *courseBtn;
@property (nonatomic,strong) UIButton *orgBtn ;


@end

@implementation QGActivityCalendarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        self.backgroundColor = [UIColor clearColor];
        CGFloat width = (MQScreenW -30)/2;
        CGFloat height = MQScreenW *0.18;
        UIImageView  *im= [[UIImageView alloc] initWithFrame:CGRectMake((MQScreenW - 2* width-10)/2, 10,  width, height)];
        im.image =  [UIImage imageNamed:@"activ-near"];
        
        [self.contentView addSubview:im];
        
        
        im.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction)];
        [im addGestureRecognizer:tapImage];
        
        UIImageView  *org= [[UIImageView alloc] initWithFrame:CGRectMake(im.maxX+10, 10, width, height)];
        org.userInteractionEnabled = YES;
        org.image =[UIImage imageNamed:@"activ-calendar"];
        
        [self.contentView addSubview:org];
        UITapGestureRecognizer *tapImage1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImageAction1)];
        [org addGestureRecognizer:tapImage1];
        
    }
    return self;
}

- (void)showImageAction {
    
    QGActivNearViewController *vc = [[QGActivNearViewController alloc] init];
    
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
    
}
- (void)showImageAction1 {
    
    QGActCalendarViewController *vc = [[QGActCalendarViewController alloc] init];
    
    UIViewController *viewController = [SAUtils findViewControllerWithView:self];
    [viewController.navigationController pushViewController:vc animated:YES];
    
}


@end
