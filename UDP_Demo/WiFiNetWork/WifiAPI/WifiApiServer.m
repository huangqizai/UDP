//
//  WifiApiServer.m
//  Homi_M4
//
//  Created by zhoutianyu on 2016/12/16.
//  Copyright © 2016年 zhoutianyu. All rights reserved.
//

#import "WifiApiServer.h"
#import "WifiApi.h"
#import "CustomNSObject.h"

@interface WifiApiServer()

@property(retain,nonatomic)NSMutableArray* bytes;

@end

@implementation WifiApiServer


+ (NSData *)SelectWifiDevices:(NSString *)devicesType
{
    NSString *strbegin = @"5a"; //帧头
    NSString *strend = @"5b"; //帧尾
    
    NSString *areaCode = @"";
//    if ([AppDelegate getInstance].serverType == ServerTypeCN) {
//        areaCode = @"0000";//0000
//    } else {
    areaCode = @"0001";//0001
//    }
//    if ([devicesType isEqualToString:ROOME_PLUG]) {
//        areaCode = @"0008";
//    }

    NSString *str1 = @"42001b00000000400201"; //字符串
    str1 = [str1 stringByAppendingString:devicesType];
    str1 = [str1 stringByAppendingString:@"04ffffffff010200"];
    str1 = [str1 stringByAppendingString:devicesType];
    str1 = [str1 stringByAppendingString:areaCode];
    
    //crc校验码
    NSString *crc16 = [CustomNSObject getCRC16:str1];
    if (crc16) {
         str1 = [str1 stringByAppendingString:crc16];
    }
    
    NSString *str2 = [str1 stringByReplacingOccurrencesOfString:@"ff" withString:@"ff00"];
    str2 =  [str2 stringByReplacingOccurrencesOfString:@"5a" withString:@"ffa5"];
    str2 =  [str2 stringByReplacingOccurrencesOfString:@"5b" withString:@"ffa4"];
   
    strbegin = [strbegin stringByAppendingString:str2]; //帧头 + 格式 + crc16
    strbegin = [strbegin stringByAppendingString:strend]; //加上帧尾
    
    NSLog(@"发送：%@",strbegin);
    NSData *data = [CustomNSObject stringToByte:strbegin];  //16进制 --> nsdata
    
    return data;
}

 



 @end
