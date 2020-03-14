//
//  BLUCircleAdViewModel.m
//  Blue
//
//  Created by Bowen on 24/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUCircleAdViewModel.h"
#import "BLUAd.h"
#import "BLUApiManager+Ad.h"

static NSString * const BLUCircleAdsKey = @"BLUCircleAdsKey";

@interface BLUCircleAdViewModel ()

@property (nonatomic, weak) RACDisposable *fetchDisposable;
@property (nonatomic, assign) NSInteger currentHashOfAds;
@property (nonatomic, strong, readonly) NSString *circleAdsPath;
@property (nonatomic, strong) NSArray *ads;

@end

@implementation BLUCircleAdViewModel

@synthesize circleAdsPath = _circleAdsPath;

#pragma mark - Model.

- (instancetype)init {
    if (self = [super init]) {
        self.ads = [self adsFromPath:self.circleAdsPath];
    }
    return self;
}

- (RACSignal *)fetch {
    [self.fetchDisposable dispose];
    @weakify(self);
    return [[[[BLUApiManager sharedManager]
      fetchCircleAD]
     doNext:^(NSArray *ads) {
         @strongify(self);
         if ([self.delegate respondsToSelector:@selector(shouldRefreshAds:fromViewModel:)]) {
             self.ads = ads;
             [self.delegate shouldRefreshAds:ads fromViewModel:self];
             [self writeAds:ads toPath:self.circleAdsPath];
         }
    }] doError:^(NSError *error) {
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(shouldHandleFetchError:fromViewModel:)]) {
            [self.delegate shouldHandleFetchError:error fromViewModel:self];
        }
    }];
}

- (BOOL)isLeftAds:(NSArray *)leftAds equalRightAds:(NSArray *)rightAds {
    NSInteger leftHash = [self hashOfAds:leftAds];
    NSInteger rightHash = [self hashOfAds:rightAds];

    if (leftHash == rightHash) {
        return YES;
    } else {
        return NO;
    }
}

- (NSInteger)hashOfAds:(NSArray *)ads {
    NSInteger hash = 0;
    for (BLUAd *ad in ads) {
        if (hash == 0) {
            hash = ad.hash;
        } else {
            hash = hash | ad.hash;
        }
    }
    return hash;
}

#pragma mark - File manager.

- (NSString *)circleAdsPath {
    if (_circleAdsPath == nil) {
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        _circleAdsPath = [[BLUCircleAdsKey MD5String] stringByAppendingString:@".plist"];
        _circleAdsPath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@", _circleAdsPath]];
    }
    return _circleAdsPath;
}

- (void)writeAds:(NSArray *)ads toPath:(NSString *)path {
    if (ads != nil) {
        [NSKeyedArchiver archiveRootObject:ads toFile:path];
        BLULogInfo(@"Did write circle ads to file.");
    } else {
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        if (error) {
            BLULogError(@"Error = %@", error);
        }
    }
}

- (NSArray *)adsFromPath:(NSString *)path {
    NSArray *ads = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    BLULogInfo(@"Did get circle ads from file");
    return ads;
}

@end
