//
//  BLURedirectObject.m
//  Blue
//
//  Created by Bowen on 12/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLURedirectObject.h"

static void * kBLUPageRedirectionBackingStore = &kBLUPageRedirectionBackingStore;

static NSString * const BLUPageRedirectionIDKey = @"BLUPageRedirectionIDKey";
static NSString * const BLUPageRedirectionTypeKey = @"BLUPageRedirectionTypeKey";
static NSString * const BLUPageRedirectionURLKey = @"BLUPageRedirectionURLKey";
static NSString * const BLUPageRedirectionObjectKey = @"BLUPageRedirectionObjectKey";
static NSString * const BLUPageRedirectionTitleKey = @"BLUPageRedirectionTitleKey";

@implementation BLURedirectObject

- (NSMutableDictionary *)backingStore {
    NSMutableDictionary *backingStore = objc_getAssociatedObject(self, kBLUPageRedirectionBackingStore);
    if (backingStore) {
        return backingStore;
    } else {
        backingStore = [NSMutableDictionary new];
        objc_setAssociatedObject(self, kBLUPageRedirectionBackingStore, backingStore, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return backingStore;
    }
}

- (id)objectFromBackingStoreWithKey:(NSString *)key {
    NSMutableDictionary *backingStore = [self backingStore];
    return [backingStore objectForKey:key];
}

- (void)setObjectToBackingStoreWithKey:(NSString *)key value:(id)value {
    NSMutableDictionary *backingStore = [self backingStore];
    if (value != nil) {
        [backingStore setObject:value forKey:key];
    }
}

- (void)setRedirectID:(NSInteger)redirectID {
    [self setObjectToBackingStoreWithKey:BLUPageRedirectionIDKey value:@(redirectID)];
}

- (void)setRedirectType:(BLUPageRedirectionType)redirectType {
    [self setObjectToBackingStoreWithKey:BLUPageRedirectionTypeKey value:@(redirectType)];
}

- (void)setRedirectURL:(NSURL *)redirectURL {
    [self setObjectToBackingStoreWithKey:BLUPageRedirectionURLKey value:redirectURL];
}

- (void)setRedirectObject:(id)redirectObject {
    [self setObjectToBackingStoreWithKey:BLUPageRedirectionObjectKey value:redirectObject];
}

- (void)setRedirectTitle:(NSString *)redirectTitle {
    [self setObjectToBackingStoreWithKey:BLUPageRedirectionTitleKey value:redirectTitle];
}

- (NSInteger)redirectID {
    NSNumber *num = [self objectFromBackingStoreWithKey:BLUPageRedirectionIDKey];
    if ([num isKindOfClass:[NSNumber class]]) {
        return num.integerValue;
    } else {
        return 0;
    }
}

- (BLUPageRedirectionType)redirectType {
    NSNumber *num = [self objectFromBackingStoreWithKey:BLUPageRedirectionTypeKey];
    if ([num isKindOfClass:[NSNumber class]]) {
        return num.integerValue;
    } else {
        return 0;
    }
}

- (NSURL *)redirectURL {
    return [self objectFromBackingStoreWithKey:BLUPageRedirectionURLKey];
}

- (id)redirectObject {
    return [self objectFromBackingStoreWithKey:BLUPageRedirectionObjectKey];
}

- (NSString *)redirectTitle {
    return [self objectFromBackingStoreWithKey:BLUPageRedirectionTitleKey];
}

@end
