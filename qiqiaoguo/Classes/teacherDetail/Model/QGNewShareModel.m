//
//  QGNewShareModel.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/8.
//

#import "QGNewShareModel.h"

@implementation QGNewShareModel

- (BLUShareObjectType)objectType {
    return BLUShareObjectTypePost;
}

- (NSString *)shareTitle{
    return self.title;
}

- (NSString *)shareContent {
    return self.content;
}

- (NSURL *)shareImageURL {
    return [NSURL URLWithString:self.shareImg];
}

- (NSURL *)shareRedirectURL {
    
    return [NSURL URLWithString:self.sharUrl];
}

- (UIImage *)shareDefaultImage {
    return [UIImage imageNamed:@"logo-40"];
}

@end
