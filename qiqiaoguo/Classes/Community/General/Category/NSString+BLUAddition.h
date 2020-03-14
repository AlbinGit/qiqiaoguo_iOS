//
//  NSString+BLUAddition.h
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (BLUEAddition)

- (NSNumber *)stringToNSNumber;
- (BOOL)isEmpty;
- (NSString *)sha256;
- (NSString *)MD5String;

// For test
+ (NSString *)randomLorumIpsum;
+ (NSString *)randomLorumIpsumWithLength:(NSInteger)length;

+ (NSString *)appVersion;
+ (NSString *)build;
+ (NSString *)versionBuild;
+ (NSString *)appName;
+ (NSString *)appBuild;

@end
