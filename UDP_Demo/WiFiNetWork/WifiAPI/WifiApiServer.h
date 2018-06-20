//
//  WifiApiServer.h
//  Homi_M4
//
//  Created by zhoutianyu on 2016/12/16.
//  Copyright © 2016年 zhoutianyu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiApiServer : NSObject



/**
 通过WIFI添加设备时使用，APP广播此条命令

 @param devicesType 设备类型

 */
+ (NSData *)SelectWifiDevices:(NSString *)devicesType;

 
@end
