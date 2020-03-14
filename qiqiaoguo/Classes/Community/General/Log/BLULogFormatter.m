//
//  BLULogFormatter.m
//  Blue
//
//  Created by Bowen on 25/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLULogFormatter.h"

@implementation BLULogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel = nil;
    switch (logMessage->_flag) {
        case DDLogFlagError    : logLevel = @"E"; break;
        case DDLogFlagWarning  : logLevel = @"W"; break;
        case DDLogFlagInfo     : logLevel = @"I"; break;
        case DDLogFlagDebug    : logLevel = @"D"; break;
        default                : logLevel = @"V"; break;
    }
    return [NSString stringWithFormat:@"%@ %@ > %@ %@ %@ | %@", logLevel, logMessage->_timestamp, logMessage->_fileName, logMessage->_function, @(logMessage->_line), logMessage->_message];
}

@end
