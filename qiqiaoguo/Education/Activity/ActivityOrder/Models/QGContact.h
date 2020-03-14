//
//  QGContact.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import <Foundation/Foundation.h>

@interface QGContact : NSObject
@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *phone;
@property (nonatomic,strong) NSMutableArray *arrM;
+ (instancetype)contactWithName:(NSString *)name phone:(NSString *)phone;

@end
