//
//  QGPostListModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/19.
//
//

#import <Foundation/Foundation.h>

@interface QGPostListModel : NSObject
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy) NSString *access_count;

@property (nonatomic,copy)NSString *id;
@property (nonatomic,strong)NSMutableArray *imageList;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *comment_count;
@property (nonatomic,copy) NSString *circle_id;
@property (nonatomic,copy) NSString *circle_name ;
@property (nonatomic,copy) NSString *is_video;

@end

@interface QGImageListModel : NSObject
@property (nonatomic,copy)NSString *id;
@property (nonatomic,copy) NSString *image_url;


@end