//
//  QGFilePath.m
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/6/9.
//

#import "QGFilePath.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@implementation QGFilePath

+ (NSString *)getSavePathWithFileSuffix:(NSString *)suffix
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [paths objectAtIndex:0];
    
    NSDate *date = [NSDate date];
    //获取当前时间
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSString *curretDateAndTime = [dateFormat stringFromDate:date];
    //获取用户userID
//    NSDictionary *userDic= [[NSUserDefaults standardUserDefaults] objectForKey:USERDEFAULTS_id];
	NSString * userID = [SAUserDefaults getValueWithKey:USERDEFAULTS_id];
    //命名文件
    NSString *fileName = [NSString stringWithFormat:@"%@%@.%@",userID,curretDateAndTime,suffix];
    //指定文件存储路径
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    
    return filePath;
}

+ (UIImage *)getVideoThumbnailWithFilePath:(NSString *)filePath
{
    MPMoviePlayerController *moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:filePath]];
    moviePlayer.shouldAutoplay = NO;
    UIImage *image = [moviePlayer thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    return image;
}

+ (UIImage *)getImage:(NSString *)filePath
{
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:url options:options];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(60, 60);
    CGImageRef imageRef = [generator copyCGImageAtTime:CMTimeMake(10, 10) actualTime:NULL error:nil];
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}
@end

