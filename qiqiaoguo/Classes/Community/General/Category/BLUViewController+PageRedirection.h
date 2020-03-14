//
//  BLUViewController+PageRedirect.h
//  Blue
//
//  Created by Bowen on 12/1/2016.
//  Copyright © 2016 com.boki. All rights reserved.
//

#import "BLUViewController.h"
#import "BLUPageRedirection.h"


@interface BLUViewController (PageRedirection)

- (void)redirectWithPageRedirection:(id <BLUPageRedirection>)redirection;

@end
