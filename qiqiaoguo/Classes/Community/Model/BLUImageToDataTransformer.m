//
//  BLUImageToDataTransformer.m
//  Blue
//
//  Created by Bowen on 22/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUImageToDataTransformer.h"

@implementation BLUImageToDataTransformer

+ (BOOL)allowsReverseTransformation {
    return YES;
}

+ (Class)transformedValueClass {
    return [NSData class];
}

- (id)transformedValue:(id)value {
    return UIImagePNGRepresentation(value);
}

- (id)reverseTransformedValue:(id)value {
    return [[UIImage alloc] initWithData:value];
}

@end
