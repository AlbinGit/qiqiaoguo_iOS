//
//  QGActlistHomeModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/6.
//
//

#import <Foundation/Foundation.h>


@interface QGActlistHomeModel : NSObject

@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *coverPicPop;
@property (nonatomic,copy)NSString *apply_begin_date;
@property (nonatomic,copy)NSString *apply_end_date;
@property (nonatomic,copy)NSString *valid_begin_date;
@property (nonatomic,assign)int user_count;
@property (nonatomic,copy)NSString *apply_count;
@property (nonatomic,copy)NSString *price;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,copy)NSString *user_range;
@property (nonatomic,copy)NSString *sign_tips;//已有报名
@property (nonatomic,copy)NSString *price_tail;



@end



@interface QGActlistHomeResultModel : NSObject
@property (nonatomic,strong) NSMutableArray *items;
@property (nonatomic,copy)NSString *current_page;
@property (nonatomic,copy)NSString *per_page;
@property (nonatomic,copy)NSString *total_page;
@property (nonatomic,copy)NSString *total_count;
@end

@interface QGActlistHomeDownload : QGHttpDownload
@property (nonatomic,strong) NSString *platform_id;
@property (nonatomic,copy) NSString *page;

@end

@interface QGUserActivDownload : QGHttpDownload
@property (nonatomic,strong) NSString *platform_id;
@property (nonatomic,copy) NSString *page;

@end

@interface QGUserPartActivDownload : QGHttpDownload
@property (nonatomic,strong) NSString *platform_id;
@property (nonatomic,copy) NSString *page;

@end











