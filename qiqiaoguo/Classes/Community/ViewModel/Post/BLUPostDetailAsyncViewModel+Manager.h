//
//  BLUPostDetailAsyncViewModel+Manager.h
//  Blue
//
//  Created by Bowen on 16/12/2015.
//  Copyright © 2015 com.boki. All rights reserved.
//

#import "BLUPostDetailAsyncViewModel.h"

@interface BLUPostDetailAsyncViewModel (Manager)

- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
- (BLUPostDetailAsyncObjectType)objectTypeOfRowAtIndexPath:(NSIndexPath *)indexPath;

- (BLUPostDetailAsyncSectionType)sectionTypeOfSection:(NSInteger)section;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection:(NSInteger)section;

- (NSInteger)sectionOfRows:(NSArray *)rows;
- (NSMutableArray *)rowsAtSection:(NSInteger)section;
- (BOOL)isRowsInPostDetails:(NSArray *)rows;

- (NSArray *)indexPathsOfRows:(NSArray *)rows
                      section:(NSInteger)section;
- (NSArray *)newIndexPathOfRows:(NSArray *)rows
                        newRows:(NSArray *)newRows
                        section:(NSInteger)section;

- (NSString *)titleOfHeaderInSection:(NSInteger)section;

@end
