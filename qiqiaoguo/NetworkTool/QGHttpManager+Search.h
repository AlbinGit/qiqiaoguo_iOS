//
//  QGHttpManager+Search.h
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGHttpManager.h"
#import "QGSearchNavView.h"

@interface QGHttpManager (Search)

+ (void)getSearchHotTagWithSearchOptionType:(QGSearchOptionType)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

//+ (void)getSearchResultsWithSearchOptionType:(QGSearchOptionType)type keyword:(NSString *)keyword page:(NSInteger)page Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

+ (void)getScreeningDataWithSearchOptionType:(QGSearchOptionType)type Success:(QGResponseSuccess)success failure:(QGResponseFail)failure;

@end
