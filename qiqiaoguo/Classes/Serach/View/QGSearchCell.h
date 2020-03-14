//
//  QGSearchCell.h
//  qiqiaoguo
//
//  Created by cws on 16/7/8.
//
//

#import "QGModel.h"
#import "QGCell.h"

@protocol QGSearchCellDelegate <NSObject>
- (void)searchWithKeyword:(NSString *)keyword;
@end

@interface QGSearchCell : QGCell
@property (nonatomic, weak) id <QGSearchCellDelegate> searchDelegate;
@property (nonatomic,strong) NSArray *TagArray;
@end
