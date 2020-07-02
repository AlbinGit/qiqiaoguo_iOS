//
//  QGNewCommentViewController.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/29.
//

#import "QGNewCommentViewController.h"
#import "QGStarView.h"

@interface QGNewCommentViewController ()

@property (nonatomic,strong)QGStarView * starView;

@end

@implementation QGNewCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.	
	[self p_creatNav];
	
}

- (void)p_creatNav
{
    [self initBaseData];
	[self createReturnButton];
	[self createNavTitle:@"发布评论"];
}






@end
