//
//  QGNewCatalogModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGNewCatalogModel : NSObject
@property (nonatomic,copy) NSString *myID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *images;
@property (nonatomic,copy) NSString *begin_date;
@property (nonatomic,copy) NSString *start_time;
@property (nonatomic,copy) NSString *end_time;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *section_type;
@property (nonatomic,copy) NSString *video_url;
@property (nonatomic,copy) NSString *video_time;
@property (nonatomic,copy) NSString *save_type;
@property (nonatomic,copy) NSString *video_type;//video_type 0录播  1  直播
@property (nonatomic,copy) NSString *password;
@property (nonatomic,copy) NSString *is_free;
@property (nonatomic,copy) NSArray *fileList;//新增课件
@property (nonatomic,copy) NSString *live_status;//直播状态live_status   0=未开始  1=直播中  2=已结束


@end

@interface QGfileListModel : NSObject
@property (nonatomic,copy) NSString *file_id;
@property (nonatomic,copy) NSString *file_name;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *mediatype;
@property (nonatomic,copy) NSString *filesize;
@end
NS_ASSUME_NONNULL_END
