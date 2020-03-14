//
//  BLUResponse.h
//  Blue
//
//  Created by Bowen on 29/6/15.
//  Copyright (c) 2015 com.blue. All rights reserved.
//

#import "MTLModel.h"

@interface BLUResponse : MTLModel

@property (nonatomic, strong) id object;
@property (nonatomic, copy) NSURLResponse *URLResponse;
@property (nonatomic, copy) NSDictionary *JSONDictionary;
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, copy) NSString *message;

@end
