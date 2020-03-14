//
//  BLUPage.m
//  Blue
//
//  Created by Bowen on 20/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUPagination.h"

NSString *BLUPaginationKeyPage     = @"page";
NSString *BLUPaginationKeyPerpage  = @"per_page";
NSString *BLUPaginationKeyGroup    = @"group";
NSString *BLUPaginationKeyOrder    = @"order";

static NSString * const BLUPaginationOrderKeyAsc = @"asc";
static NSString * const BLUPaginationOrderKeyDesc = @"desc";

NSInteger BLUPaginationPerpageMinimum = 1;
NSInteger BLUPaginationPerpageDefault = 20;
NSInteger BLUPaginationPerpageMax     = 10000;

NSInteger BLUPaginationPageBase = 1;

@implementation BLUPagination

- (instancetype)initWithPerpage:(NSInteger)perpage group:(NSString *)group order:(BLUPaginationOrder)order {
    NSParameterAssert(perpage >= BLUPaginationPerpageMinimum && perpage <= BLUPaginationPerpageMax);
    if (self = [super init]) {
        _perpage = BLUPaginationPerpageDefault;
        
        if (group) {
            NSParameterAssert([group isKindOfClass:[NSString class]]);
            _group = group;
        }
        
        _perpage = perpage;
        _order = order;
        _page = BLUPaginationPageBase;
    }
    return self;
}

- (void)configMutableDictionary:(NSMutableDictionary *)dict {
    NSParameterAssert([dict isKindOfClass:[NSMutableDictionary class]]);
    if (_group) {
        dict[BLUPaginationKeyGroup] = _group;
    }

    switch (_order) {
        case BLUPaginationOrderAsc: {
            dict[BLUPaginationKeyOrder] = BLUPaginationOrderKeyAsc;
        } break;
        case BLUPaginationOrderDesc: {
            dict[BLUPaginationKeyOrder] = BLUPaginationOrderKeyDesc;
        } break;
        case BLUPaginationOrderNone:
        default: {
        } break;
    }
    
    dict[BLUPaginationKeyPage] = @(_page);
    dict[BLUPaginationKeyPerpage] = @(_perpage);
}

@end
