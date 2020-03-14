//
//  QGMessageListModel.h
//  qiqiaoguo
//
//  Created by cws on 16/7/5.
//
//

#import "QGModel.h"

@interface QGMessageListModel : QGModel

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *imageURL;
@property (nonatomic,assign) NSInteger messageID;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic, copy) NSDate *createDate;

@end
