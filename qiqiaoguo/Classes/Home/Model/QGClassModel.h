//
//  QGClassModel.h
//  qiqiaoguo
//
//  Created by 史志杰 on 2020/5/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QGClassModel : NSObject
//@property (nonatomic,copy) NSString *parent_id;
//@property (nonatomic,copy) NSString *myID;
//@property (nonatomic,copy) NSString *title;
//@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSString *icon;
@property (nonatomic,copy) NSString *category_name;
@property (nonatomic,copy) NSString *category_id;
@property (nonatomic,copy) NSString *theme;
@property (nonatomic,copy) NSString *sort;
@property (nonatomic,copy) NSArray *sublist;

@end

@interface QGClassListModel : NSObject
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *myID;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *sort;
@end


NS_ASSUME_NONNULL_END
