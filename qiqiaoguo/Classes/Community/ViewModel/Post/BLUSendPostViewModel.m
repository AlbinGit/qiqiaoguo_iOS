//
//  BLUSendPostViewModel.m
//  Blue
//
//  Created by Bowen on 27/8/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "BLUSendPostViewModel.h"
#import "BLUApiManager+Post.h"
#import "BLUPost.h"

@implementation BLUSendPostViewModel

- (RACCommand *)send {
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:[self _validatePost] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[BLUApiManager sharedManager] sendPostWithTitle:self.title content:self.content circleID:self.circleID images:self.photos anonymousEable:self.anonymousEnable];
    }];
}

- (RACSignal *)_validatePost {
    return [[RACSignal combineLatest:@[[self _validateTitle], [self _validateContent], [self _validatePhoto]]] reduceEach:^id(NSNumber *isTitle, NSNumber *isContent, NSNumber *isPhoto){
        return @(isTitle.boolValue && (isContent.boolValue || isPhoto.boolValue));
    }];
}

- (RACSignal *)_validateContent {
    return [BLUPost validatePostContent:RACObserve(self, content)];
}

- (RACSignal *)_validateTitle {
    return [BLUPost validatePostTitle:RACObserve(self, title)];
}

- (RACSignal *)_validatePhoto {
    return [RACObserve(self, photos) map:^id(NSArray *photos) {
        return @(photos.count > 0);
    }];
}

@end
