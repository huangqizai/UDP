//
//  ViewController.m
//  UDP_Demo
//
//  Created by huangqizai on 2018/3/27.
//  Copyright © 2018年 FYCK. All rights reserved.
//

#import "ViewController.h"
#import "WifiManager.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,WifiManagerDelegate>

@property (nonatomic, strong) WifiManager *manager;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.manager = [WifiManager manager];
    self.manager.delegate = self;
#pragma 搜索设备号
    [self.manager startScan:ROOME_PLUG];
}

#pragma mark - WifiManagerDelegate
- (void)didFoundDevice:(DeviceModel *)device{
    NSLog(@"");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
