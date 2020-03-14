//
//  NSError+BLUAddition.h
//  Blue
//
//  Created by Bowen on 26/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (BLUAddition)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code description:(NSString *)description reason:(NSString *)reason;

@end
