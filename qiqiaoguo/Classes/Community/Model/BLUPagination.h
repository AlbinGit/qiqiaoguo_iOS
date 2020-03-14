//
//  BLUPage.h
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUObject.h"

UIKIT_EXTERN NSString *BLUPaginationKeyPage;
UIKIT_EXTERN NSString *BLUPaginationKeyPerpage;
UIKIT_EXTERN NSString *BLUPaginationKeyGroup;
UIKIT_EXTERN NSString *BLUPaginationKeyOrder;

UIKIT_EXTERN NSInteger BLUPaginationPerpageMinimum;
UIKIT_EXTERN NSInteger BLUPaginationPerpageDefault;
UIKIT_EXTERN NSInteger BLUPaginationPerpageMax;

UIKIT_EXTERN NSInteger BLUPaginationPageBase;

typedef NS_ENUM(NSInteger, BLUPaginationOrder) {
    BLUPaginationOrderNone = 0,
    BLUPaginationOrderAsc,
    BLUPaginationOrderDesc,
};

@interface BLUPagination : BLUObject

@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign, readonly) NSInteger perpage;
@property (nonatomic, copy, readonly) NSString *group;
@property (nonatomic, assign) BLUPaginationOrder order;

- (instancetype)initWithPerpage:(NSInteger)perpage group:(NSString *)group order:(BLUPaginationOrder)order;

- (void)configMutableDictionary:(NSMutableDictionary *)dict;

@end
