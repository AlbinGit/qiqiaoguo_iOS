//
//  QGPostListFrameModel.h
//  qiqiaoguo
//
//  Created by xieminqiang on 16/7/19.
//
//

#import <Foundation/Foundation.h>

#import "QGPostListModel.h"
@interface QGPostListFrameModel : NSObject
@property (nonatomic,strong) QGPostListModel *post;

/**
 * 图片的frame
 */
@property (nonatomic, assign) CGRect iconF;
/**
 *  昵称的frame
 */
@property (nonatomic, assign) CGRect nameF;

/**
 *  正文的frame
 */
@property (nonatomic, assign) CGRect introF;
/**
 *  评论的frame
 */
@property (nonatomic, assign) CGRect commentbtnF;

@property (nonatomic, assign) CGRect accessbtnF;

@property (nonatomic, assign) CGRect circlenameF;

@property (nonatomic, assign) CGRect videoImageF;

/**
 *  行高
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  线
 */

@property (nonatomic, assign) CGRect lineF;
@end
