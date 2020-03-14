//
//  QGContact.m
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/28.
//
//

#import "QGContact.h"

@implementation QGContact
+ (instancetype)contactWithName:(NSString *)name phone:(NSString *)phone{
    
    QGContact *c = [[self alloc] init];
    c.name = name;

    c.phone = phone;
    return c;
}
@end
