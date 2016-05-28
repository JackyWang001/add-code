//
//  loadWebImageTableViewCell.h
//  图片下载
//
//  Created by 王建科 on 16/5/28.
//  Copyright © 2016年 第一小组. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface loadWebImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picture;

@property (weak, nonatomic) IBOutlet UILabel *namelable;
@property (weak, nonatomic) IBOutlet UILabel *loadLable;

@end
