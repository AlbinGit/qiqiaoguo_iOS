//
//  TTTFileManager.h
//  3TClassEducation
//
//  Created by 贻成  王 on 2020/3/17.
//  Copyright © 2020 GSWS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 文件管理类.---2020.03.17(暂时处理课件JS文件zip包的下载和解压)
@interface TTTFileManager : NSObject

+ (TTTFileManager *)sharedInstance;

/// 下载zip文件
/// @param url 文件地址接口.
/// @param docsWbJs docs-wb.js的文件md5值，下载文件地址：接口地址+/resources/docsWbH5/3ttlive-wb/docs-wb.js
/// @param docsWbHtml docs-wb.html的文件md5值，下载文件地址：接口地址+/resources/docsWbH5/docs-wb.html
/// @param tttWhiteboardMinJs ttt-whiteboard.min.js的文件md5值，下载文件地址：接口地址+/resources/docsWbH5/3ttlive-wb/ttt-whiteboard.min.js
- (void)downloadZipWithFileUrl:(NSString *)url docsWbJs:(NSString *)docsWbJs docsWbHtml:(NSString *)docsWbHtml tttWhiteboardMinJs:(NSString *)tttWhiteboardMinJs;

@end

NS_ASSUME_NONNULL_END
