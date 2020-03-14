//
//  NSNotification+BLUAddition.h
//  Blue
//
//  Created by Bowen on 26/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNotification (BLUAddition)

+ (NSString *)notificationName:(NSString *)name forClass:(Class)cls;

@end
