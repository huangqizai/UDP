//
//  WifiManager.h
//  WifiTest
//
//  Created by weich on 2017/3/3.
//  Copyright © 2017年 weich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WifiApi.h"
#import "DeviceModel.h"

@interface WifiDeviceModel : NSObject

@property (nonatomic, strong) NSString *deviceID;

@end

@protocol WifiManagerDelegate <NSObject>

- (void)didFoundDevice:(DeviceModel *)device;

@end

@interface WifiManager : NSObject

@property (nonatomic, weak) id<WifiManagerDelegate> delegate;

@property (nonatomic, copy) NSString *deviceType;

+ (instancetype)manager;
- (void)startScan:(NSString *)deviceType;
- (void)startScanOldLight;

- (void)stopScan;

- (void)connectDevice:(WifiDeviceModel *)device toWifi:(NSString *)string password:(NSString *)string;

@end
