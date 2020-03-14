//
//  BLUObjectInteraction.h
//  Blue
//
//  Created by Bowen on 21/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLUObjectInteraction <NSObject>

- (void)shouldShowObjectDetails:(id)object fromSender:(id)sender;

@end
