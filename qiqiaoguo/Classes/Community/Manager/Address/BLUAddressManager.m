//
//  BLUAddressManager.m
//  Blue
//
//  Created by Bowen on 26/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUAddressManager.h"
#import "FMDB.h"
//#import "FMDatabase.h"
//#import "FMResultSet.h"
//#import "FMDatabaseAdditions.h"
//#import "FMDatabaseQueue.h"
//#import "FMDatabasePool.h"

@interface BLUAddressManager ()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation BLUAddressManager

+ (instancetype)sharedManager {
    static BLUAddressManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [BLUAddressManager new];
    });

    return manager;
}

- (FMDatabase *)db {
    if (_db == nil) {
        NSBundle *mainBundle = [NSBundle mainBundle];
        NSString *path = [mainBundle pathForResource:@"district" ofType:@"sqlite"];
        _db = [FMDatabase databaseWithPath:path];
        [_db open];
    }
    return _db;
}

+ (NSString *)districtIDColumn {
    return @"district_id";
}

+ (NSString *)parentIDColumn {
    return @"parent_id";
}

+ (NSString *)nameColumn {
    return @"name";
}

+ (NSString *)tableName {
    return @"district";
}

- (NSString *)districtWithDistrictID:(NSNumber *)districtID {
    NSString *q =
    [NSString stringWithFormat:@"SELECT %@ FROM %@ WHERE %@ = %@;",
     [BLUAddressManager nameColumn],
     [BLUAddressManager tableName],
     [BLUAddressManager districtIDColumn],
     districtID];
    FMResultSet *s = [self.db executeQuery:q];
    NSMutableArray *results = [NSMutableArray new];
    while ([s next]) {
        NSString *name = [s stringForColumn:[BLUAddressManager nameColumn]];
        [results addObject:name];
    }
    return results.firstObject;
}

- (NSArray *)districtsWithParrentID:(NSNumber *)parrentID {
    NSString *q =
    [NSString stringWithFormat:@"SELECT %@, %@ FROM %@ WHERE %@ = %@;",
     [BLUAddressManager districtIDColumn],
     [BLUAddressManager nameColumn],
     [BLUAddressManager tableName],
     [BLUAddressManager parentIDColumn],
     parrentID];
    FMResultSet *s = [self.db executeQuery:q];
    NSMutableArray *results = [NSMutableArray new];
    NSError *error = nil;
    while ([s nextWithError:&error]) {
        int districtID = [s intForColumn:[BLUAddressManager districtIDColumn]];
        NSString *name = [s stringForColumn:[BLUAddressManager nameColumn]];
        NSDictionary *r = @{[BLUAddressManager districtIDColumn]: @(districtID),
                            [BLUAddressManager nameColumn]: name};
        [results addObject:r];
    }
    if (error) {
        BLULogError(@"error ==> %@", error);
    }
    return results;
}

@end
