#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "QGSocialService.h"
#import "BLUShareObject.h"

@class BLUShareManager;

@protocol BLUShareManagerDelegate <NSObject>

- (void)shareManage:(BLUShareManager *)shareManage
     didShareObject:(id <BLUShareObject>)object
        withMessage:(NSString *)message;

- (void)shareManager:(BLUShareManager *)shareManage
didShareObjectFailed:(id <BLUShareObject>)object
               WithError:(NSError *)error;

@end
