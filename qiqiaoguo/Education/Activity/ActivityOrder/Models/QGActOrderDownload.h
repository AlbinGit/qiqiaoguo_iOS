//
//  QGActOrderDownload.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGHttpDownload.h"

@interface QGActOrderDownload : QGHttpDownload
@property (nonatomic,copy)NSString *platform_id;
@property (nonatomic,copy)NSString *activity_id;

@property (nonatomic,strong) NSArray *ticketList;
@property (nonatomic,strong) NSArray *applyDataList;
@property (nonatomic,copy) NSString *remark;

@end

