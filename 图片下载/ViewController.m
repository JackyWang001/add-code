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
 *  <#名字#>
 */
@property (nonatomic,strong) NSOperationQueue* queue;
/**
 *  <#名字#>
 */

@end

@implementation ViewController

- (void)loadView{
    
    _tablev = [[UITableView alloc] init];
    self.view = _tablev;
    _tablev.dataSource = self;
    _queue = [[NSOperationQueue alloc] init];
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
    if (mode.image != nil ) {
        
        cell.picture.image = mode.image;
        return cell;
        
    }
    cell.picture.image = [UIImage imageNamed:@"threeDog006"];
    
    NSURL * url = [NSURL URLWithString:mode.icon];
    
    NSBlockOperation * block = [NSBlockOperation blockOperationWithBlock:^{
        
        [NSThread sleepForTimeInterval:2];
        NSData * data = [NSData dataWithContentsOfURL:url];
        UIImage * imag = [UIImage imageWithData:data];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            
                cell.picture.image = imag;
            mode.image = imag;
        }];
        
        
    }];
    
    [_queue addOperation:block];
    
    
    
    
    return cell;
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
