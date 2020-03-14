//
//  QGEduOrderDownload.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/9/12.
//
//

#import <Foundation/Foundation.h>

@interface QGEduOrderDownload : NSObject
@property (nonatomic,copy)NSString *platform_id;
@property (nonatomic,copy)NSString *username;

@property (nonatomic,copy)NSString *tel;
@property (nonatomic,strong) NSArray *shoppingCart;


@end
