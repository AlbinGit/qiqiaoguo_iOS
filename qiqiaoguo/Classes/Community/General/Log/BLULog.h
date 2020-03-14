//
//  BLULog.h
//  Blue
//
//  Created by Bowen on 25/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#ifndef Blue_BLULog_h
#define Blue_BLULog_h

#define BLU_LOG_CONTEXT 1044

#define BLULogError(frmt, ...)    LOG_MAYBE(NO,                bluLogLevel, DDLogFlagError,   BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BLULogWarn(frmt, ...)     LOG_MAYBE(NO, bluLogLevel, DDLogFlagWarning, BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BLULogInfo(frmt, ...)     LOG_MAYBE(NO, bluLogLevel, DDLogFlagInfo,    BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BLULogDebug(frmt, ...)    LOG_MAYBE(NO, bluLogLevel, DDLogFlagDebug,   BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)
#define BLULogVerbose(frmt, ...)  LOG_MAYBE(NO, bluLogLevel, DDLogFlagVerbose, BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

//#define BLUFlagLogInfo(flag, frmt, ...) do { \
//    if (flag == YES) { \
//        LOG_MAYBE(LOG_ASYNC_ENABLED, bluLogLevel, DDLogFlagInfo,    BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); \
//    } \
//} while(0) \
//
//#define BLUFlagLogVerbose(flag, frmt, ...) do { \
//    if (flag == YES) { \
//        LOG_MAYBE(LOG_ASYNC_ENABLED, bluLogLevel, DDLogFlagVerbose, BLU_LOG_CONTEXT, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__); \
//    } \
//} while(0)

#define BLULogFrame(name, view) BLULogDebug(@"%@.%@", name, NSStringFromCGRect(view))

#ifdef BLUDebug
static NSInteger bluLogLevel = DDLogLevelVerbose;
#else
static NSInteger bluLogLevel = DDLogLevelError;
#endif

#endif


