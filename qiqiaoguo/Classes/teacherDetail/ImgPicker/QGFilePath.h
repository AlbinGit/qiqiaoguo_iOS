//
//  QGFilePath.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGFilePath : NSObject
//获取要保存的本地文件路径
+ (NSString *)getSavePathWithFileSuffix:(NSString *)suffix;
//获取录像的缩略图
+ (UIImage *)getVideoThumbnailWithFilePath:(NSString *)filePath;
+ (UIImage *)getImage:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
