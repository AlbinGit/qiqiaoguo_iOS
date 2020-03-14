//
//  BLUAddressManager.h
//  Blue
//
//  Created by Bowen on 26/2/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLUAddressManager : NSObject

+ (BLUAddressManager *)sharedManager;

- (NSString *)districtWithDistrictID:(NSNumber *)districtID;
- (NSArray *)districtsWithParrentID:(NSNumber *)districtID;

+ (NSString *)districtIDColumn;
+ (NSString *)parentIDColumn;
+ (NSString *)nameColumn;

@end
