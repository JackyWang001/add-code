//
//  ViewController.m
//  图片下载
//
//  Created by 王建科 on 16/5/28.
//  Copyright © 2016年 第一小组. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "loadWebImageTableViewCell.h"
#import "loadModel.h"

static NSString * str = @"hahha";

@interface ViewController ()<UITableViewDataSource>
/**
 *  跟视图
 */
@property (nonatomic,strong) UITableView* tablev;
/**
 *  名字
 */
@property (nonatomic,strong) NSArray* array;
/**
 *  操作
 */
@property (nonatomic,strong) NSOperationQueue* queue;

/**
 *  图片缓存
 */
@property (nonatomic , strong) NSMutableDictionary * pictureDit;
/**
 *  操作缓存
 */
@property (nonatomic,strong) NSMutableDictionary* operation;
@end

@implementation ViewController

- (void)loadView{
    
    _tablev = [[UITableView alloc] init];
    self.view = _tablev;
    _tablev.dataSource = self;
    _queue = [[NSOperationQueue alloc] init];
}


- (NSMutableDictionary *)pictureDit{
    
    if (_pictureDit  == nil) {
        _pictureDit = [NSMutableDictionary dictionary];
    }
    return _pictureDit;
}

- (NSMutableDictionary *)operation{
    
    if (_pictureDit ==nil) {
        _operation = [NSMutableDictionary dictionary];
        
    }
    return _operation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //    [_tablev registerClass:[UITableViewCell class] forCellReuseIdentifier:str];
    [_tablev registerNib:[UINib nibWithNibName: @"loadWebImageTableViewCell" bundle:nil] forCellReuseIdentifier:str];
    _tablev.rowHeight = 100;
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    loadWebImageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str forIndexPath:indexPath];
    loadModel * mode =    _array[indexPath.row];
    cell.namelable.text = mode.name;
    cell.loadLable.text = mode.download;
    
    UIImage * imageM = self.pictureDit[ mode.icon];
    
    if (imageM != nil) {
        cell.picture.image = imageM;
                NSLog(@"内存加载图片");
        return cell;
    }
    
    
    
    UIImage * imageC = [UIImage imageWithContentsOfFile:[self getfile:mode.icon] ];
    if (imageC!= nil) {
        cell.picture.image = imageC;
        [self.pictureDit setObject:imageC forKey:mode.icon];
        
                NSLog(@"磁盘加载");
        return cell;
    }
    
// 判断操作缓存内有没有有 这个cell 的缓存
    if (self.operation[mode.icon] != nil) {
        
                NSLog(@"还在下载");
        return cell;
    }
    
    
    
    cell.picture.image = [UIImage imageNamed:@"threeDog006"];
    
    NSURL * url = [NSURL URLWithString:mode.icon];
    
    
    //新建操作代码块
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock:^{
        
        [NSThread sleepForTimeInterval:2];
        
        
        NSData * data = [NSData dataWithContentsOfURL:url];
        
        
        UIImage * imag = [UIImage imageWithData:data];
                NSLog(@"下载图片");
        if (imag != nil) {
            
            [self.pictureDit setObject:imag forKey:mode.icon];
            [data writeToFile:[self getfile:mode.icon] atomically:YES];
            
            [self.operation removeObjectForKey:mode.icon];

        }else{
         
                    NSLog(@"图片下载失败");
            [self.operation removeObjectForKey:mode.icon];
        }
        
        
        
        
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
                cell.picture.image = imag;
//            [self.tablev reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:NO];
            
        }];
        
        
    }];
    
    [_queue addOperation:block];
    
    [self.operation setObject:block forKey:mode.icon];
    
    
    
    
    return cell;
}

- (NSString *)getfile:(NSString *)str{
    
    NSString * strl = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString * strpath = [strl stringByAppendingPathComponent:str.lastPathComponent];
    
    return strpath;
}
                                
- (void)loadData{
    
    
    AFHTTPSessionManager * managet = [[AFHTTPSessionManager alloc] init];
    
    [managet GET:@"https://raw.githubusercontent.com/JackyWang001/loadWebImage/master/apps.json" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray * responseObject) {
        
        
        NSLog(@"%@",responseObject);
        NSMutableArray * arrayM = [NSMutableArray array];
    
        for (NSDictionary * dict in responseObject) {
            
            
            loadModel * modoal = [[loadModel alloc] init];
            [modoal setValuesForKeysWithDictionary:dict];
            
            [arrayM addObject: modoal];
            
        }
        
        
        self.array = arrayM;
        [self.tablev reloadData];
    
        
    }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"下载失败");
        
    }];
    
    
    
    
    
}



    



@end
