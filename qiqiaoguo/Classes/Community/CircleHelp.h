//
//  CircleHelp.h
//  LongForTianjie
//
//  Created by cws on 16/4/9.
//  Copyright © 2016年 platomix. All rights reserved.
//

#ifndef CircleHelp_h
#define CircleHelp_h


#endif /* CircleHelp_h */

#define IOS_VERSION_8_BELOW (([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0)? (YES):(NO))
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import <Colours/Colours.h>
#import	<CocoaLumberjack/CocoaLumberjack.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <Mantle/Mantle.h>
#import <libextobjc/extobjc.h>
#import <MagicalRecord/MagicalRecord.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <WebASDKImageManager/WebASDKImageManager.h>
#import <IQKeyboardManager/IQKeyboardManager.h>


#import "BLUThemeManager.h"
#import "BLUThemeMacro.h"
#import "UIView+BLUAddition.h"
#import "UIView+BLUHierarchy.h"
#import "UIColor+BLUAddition.h"
#import "NSError+BLUAddition.h"
#import "NSString+BLUAddition.h"
#import "BLUViewController+Alert.h"
#import "UIButton+BLUAddition.h"
#import "BLUUser.h"
#import "BLULog.h"
#import "BLUImageRes.h"
#import "BLUTableView.h"
#import "BLURefreshFooter.h"
#import "BLURefreshHeader.h"
#import "UIImage+BLUAddition.h"
#import "UIButton+BLUTheme.h"
#import "BLUSolidLine.h"
#import "BLUAppManager.h"
#import "NSAttributedString+BLUAddition.h"
#import "UILabel+BLUTheme.h"
#import "BLUViewController+Fetch.h"
#import "UIImageView+WebCache.h"
#import "BLUAvatarButton.h"
#import "UIImage+User.h"
#import "BLUGenderButton.h"
#import "BLUShareObjectHeader.h"
#import "BLUTextFieldContainer.h"
#import "BLUNavigationController.h"
#import "BLUGridView.h"
#import "BLUUserSimpleCell.h"
#import "BLUTableView.h"
#import "UITableView+BLUAddition.h"
#import "UIAlertAction+BLUAddition.h"
#import "BLUAvatarEditView.h"
#import "BLUMainTitleButton.h"
#import "UILabel+BLUAddition.h"
#import "BLUPostCommonAuthorNode.h"
#import "BLUApiManager.h"
#import "BLUApiManager+Tag.h"


#define BLUAssert(...) NSAssert(__VA_ARGS__)
#define BLUCAssert(...) NSCAssert(__VA_ARGS__)
#define BLUParameterAssert(param) NSParameterAssert(param)

#define BLUAssertIndexInCollection(Index, Collection)  NSAssert(Index >= 0 && Index < Collection.count, \
@"Index超过了Collection的边界\n"\
@"Index ==> %@\n"\
@"Collection ==> %@\n", @(Index), Collection)

#define BLUAssertObjectIsKindOfClass(Object, Class) NSAssert([Object isKindOfClass:Class],\
@"Object不是指定的Class.\n"\
@"Object ==> %@\n"@"Class ==> %@\n", Object, Class);



//G－C－D
#define dispatch_async_default_global_queue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define dispatch_async_main_queue(block) dispatch_async(dispatch_get_main_queue(),block)

//获取屏幕 宽度、高度
#define MAIN_SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define MAIN_SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define BLUParameterAssert(param) NSParameterAssert(param)