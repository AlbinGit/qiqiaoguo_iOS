//
//  QGSaveService.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/26.
//
//

#import <Foundation/Foundation.h>

@interface QGSaveService : NSObject

+ (id)objectForKey:(NSString *)defaultName;
+ (void)setObject:(id)value forKey:(NSString *)defaultName;

@end
