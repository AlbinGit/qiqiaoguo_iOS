//
//  BLUShowImageDelegate.h
//  Blue
//
//  Created by Bowen on 18/11/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLUShowImageProtocol.h"

@interface BLUShowImageController : NSObject <BLUShowImageProtocol>

@property (nonatomic, weak) BLUViewController *fromViewController;

@end
