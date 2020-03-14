//
//  BLUImageMO.m
//  
//
//  Created by Bowen on 22/1/2016.
//
//

#import "BLUImageMO.h"
#import "BLUImageToDataTransformer.h"

@implementation BLUImageMO

+ (void)initialize {
    if (self == [BLUImageMO class]) {
        BLUImageToDataTransformer *transformer = [[BLUImageToDataTransformer alloc] init];
        [NSValueTransformer setValueTransformer:transformer forName:@"BLUImageToDataTransformer"];
    }
}

- (void)configureWithImageRes:(BLUImageRes *)imageRes {
    BLUAssertObjectIsKindOfClass(imageRes, [BLUImageRes class]);
    self.imageID        = @(imageRes.imageID);
    self.image          = imageRes.image;
    self.name           = imageRes.name;
    self.createDate     = imageRes.createDate;
    self.originURL      = imageRes.originURL;
    self.thumbnailURL   = imageRes.thumbnailURL;
    self.width          = @(imageRes.width);
    self.height         = @(imageRes.height);
}

@end
