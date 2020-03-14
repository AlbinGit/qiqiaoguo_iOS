//
//  BLUPostDetailAsyncViewController+TableView.h
//  Blue
//
//  Created by Bowen on 15/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewController.h"
#import "BLUPostDetailAllCommentsHeaderDelegate.h"

@interface BLUPostDetailAsyncViewController (TableView)
<ASTableViewDelegate,
ASTableViewDataSource,
BLUPostDetailAllCommentsHeaderDelegate>

- (void)configureNode:(ASCellNode *)node
          atIndexPath:(NSIndexPath *)indexPath;

@end
