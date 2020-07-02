//
//  TTTClassManager.h
//  3TClassDemo
//
//  Created by 贻成  王 on 2019/1/12.
//  Copyright © 2019 贻成  王. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol TTTClassManagerDelegate <NSObject>

@required

/**
 Enter the room successfully callback.
 */
- (void)ttt_enterRoomSuccessCallBack;

/**
 Entry room failure callback.

 @param errorInfo   Failure reason.
 */
- (void)ttt_enterRoomFailureCallback:(NSString *)errorInfo;

/**
 Exit the room successfully callback.
 */
- (void)ttt_exitRoomSuccessCallBack;

@optional

/**
 Open room sharing callback.

 @param shareInfo   Share content.
 */
- (void)ttt_shareCallBack:(NSDictionary *)shareInfo;

@end

/**
 The entrance to the classroom is the core class.
 */
@interface TTTClassManager : NSObject

@property (weak, nonatomic) id <TTTClassManagerDelegate> delegate;

/// singleton
+ (TTTClassManager *)sharedInstance;

/**
 Enter the live room.
 
 @param roomId     Live room id.
 @param userId     User id.
 @param safeKey    Institutional authentication security key.
 @param timeStamp  Timestamp of the current call interface within 20 minutes.
 @param baseUrl    Base address, can be empty, if it is empty, the internal will set a set of interface requests by default.
 */
- (void)ttt_enterLiveRoomWithRoomId:(NSString *)roomId
                             userId:(NSString *)userId
                            safeKey:(NSString *)safeKey
                          timeStamp:(NSString *)timeStamp
                            baseUrl:(NSString * _Nullable)baseUrl
                       loadingImage:(UIImage * __nonnull)loadingImage;

@end

NS_ASSUME_NONNULL_END
