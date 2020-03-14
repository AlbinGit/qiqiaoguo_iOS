//
//  BLUWebViewController.m
//  Blue
//
//  Created by Bowen on 10/9/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUWebViewController.h"

@interface BLUWebViewController ()

@property (nonatomic, strong) NSURL *pageURL;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation BLUWebViewController

- (instancetype)initWithPageURL:(NSURL *)pageURL {
    if (self = [super init]) {
        _pageURL = pageURL;
    }
    self.hidesBottomBarWhenPushed = YES;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView = [UIWebView new];
    [self.view addSubview:_webView];
    [self addTiledLayoutConstrantForView:_webView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.pageURL) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.pageURL]];
    }
}

- (void)didReceiveMemoryWarning {
    if ([self isViewLoaded] && self.view.window == nil) {
        self.webView = nil;
        self.pageURL = nil;
        self.view = nil;
    }
    [super didReceiveMemoryWarning];
}

@end
