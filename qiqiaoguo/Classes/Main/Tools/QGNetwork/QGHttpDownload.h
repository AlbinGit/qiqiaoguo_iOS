//
//  SAHttpDownload.h
//  AFNetworkingTestDemo
//
//  Created by Albin on 14-8-18.
//  Copyright (c) 2014年 platomix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QGHttpDownload : NSObject

@property (nonatomic,strong)NSMutableDictionary *mapDict;// 处理关键字为id时
- (NSString *)method;
- (NSString *)path;
- (NSMutableDictionary *)params;
- (NSMutableDictionary *)paramsDic;
@end

// 批量上图片data（图片，视频文件）
@interface SAUploadModel : NSObject
@property (nonatomic,copy)NSString *fileKey;
@property (nonatomic,copy)NSString *filePath;
@property (nonatomic,copy)NSString *fileName;
@property (nonatomic,strong)QGHttpDownload *hd;
@end
