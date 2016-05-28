//
//  loadModel.h
//  图片下载
//
//  Created by 王建科 on 16/5/28.
//  Copyright © 2016年 第一小组. All rights reserved.
//

#import "UIKit/UIkit.h"

@interface loadModel : NSObject

/**
 *
 */
@property (nonatomic,copy) NSString* name;
/**
 *  名字
 */
@property (nonatomic,strong) UIImage * image;;
/**
 *
 */
@property (nonatomic,copy) NSString* download;
/**
 *
 */
@property (nonatomic,copy) NSString* icon;
@end
