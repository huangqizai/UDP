//
//  WifiManager.m
//  WifiTest
//
//  Created by weich on 2017/3/3.
//  Copyright © 2017年 weich. All rights reserved.
//

#import "WifiManager.h"
#import "GCDAsyncUdpSocket.h"
#import <SanKit/SanKit.h>
#import "WifiApiServer.h"

@implementation WifiDeviceModel

@end

@interface WifiManager () < GCDAsyncUdpSocketDelegate >

@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket;
@property (strong, nonatomic) GCDAsyncUdpSocket *udpSocket2;
@property (nonatomic, strong) NSTimer *redioTimer;

@property (nonatomic, strong) NSMutableArray *devices;

@end

//（1）监听的端口(绑定端口)和发送到的目的端口要一致。
//（2）如果要进行广播数据，必须只能使用[socket bindToPort:54321 error:&error] 方法来绑定端口，不能绑定IP地址并且启用广播，否则不能广播数据。
//（3）该实例没有被销毁前，只能被创建一次，因为端口正在被使用，可以用一个懒加载优化下。
//（4）注意NSTimer 的销毁防止内存泄露。



//若客户端也要实现接收到服务器发送的消息，也必须实现上述代码，只是不需要实现enableBraodcast:error:这个方法，这样在客户端就可以接收到消息了
//另外，客户端的端口号不需要与服务端的端口号保持一致。这时候，从另外一个角度来说，客户端变成了一个简易的服务端。

@implementation WifiManager

- (NSMutableArray *)devices
{
    if (_devices == nil) {
        _devices = @[].mutableCopy;
    }
    return _devices;
}

+ (instancetype)manager
{
    return [[WifiManager alloc] init];
}

- (void)startScan:(NSString *)deviceType
{
    self.deviceType = deviceType;
    
    self.udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
//    if ([deviceType isEqualToString:ROOME_PLUG]) {
//        [self.udpSocket bindToPort:9529 error:&error];//9529墙插
//    } else {
    //绑定端口号
    [self.udpSocket bindToPort:9528 error:&error];//9528晚安灯、网关
//    }
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    //启用广播
    [self.udpSocket enableBroadcast:YES error:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    //组播224.0.0.2地址，如果地址大于224的话，就要设置GCDAsyncUdpSocket的TTL （默认TTL为1）
    [self.udpSocket joinMulticastGroup:@"0.0.0.2" error:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    //开始接收数据（不然收不到数据）
    [self.udpSocket beginReceiving:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    self.redioTimer = [NSTimer scheduledTimerRepeats:YES withTimeInterval:1. andBlock:^{
        NSData *getData = [WifiApiServer SelectWifiDevices:deviceType];
        if (getData) {
            //host是在服务端设置的host，port也是服务端绑定的port，上文说过如果客户端不需要接收消息，就不用绑定端口
            [self.udpSocket sendData:getData toHost:@"255.255.255.255" port:9528 withTimeout:5 tag:100];
        }
    }];
}

//该方法只能用于已经连接了的Socket中
//- (void)sendData:(NSData *)data withTimeout:(NSTimeInterval)timeout tag:(long)tag;
//该方法不能用于已经连接了socket中，只能用于没有长连接的socket中
//- (void)sendData:(NSData *)data toHost:(NSString *)host port:(uint16_t)port
//     withTimeout:(NSTimeInterval)timeout tag:(long)tag;
//该方法不能用于已经连接了socket中，只能用于没有长连接的socket中
//- (void)sendData:(NSData *)data toAddress:(NSData *)remoteAddr withTimeout:(NSTimeInterval)timeout tag:(long)tag;

- (void)startScanOldLight
{
    self.udpSocket2 = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
    NSError *error;
    [self.udpSocket2 bindToPort:8899 error:&error];
    
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    [self.udpSocket2 enableBroadcast:YES error:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    //组播224.0.0.2地址，如果地址大于224的话，就要设置GCDAsyncUdpSocket的TTL （默认TTL为1）
    [self.udpSocket2 joinMulticastGroup:@"0.0.0.2" error:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
    
    [self.udpSocket2 beginReceiving:&error];
    if (nil != error) {
        NSLog(@"failed.:%@",[error description]);
    }
}


- (void)stopScan
{
    [self.redioTimer invalidate];
    self.redioTimer = nil;
    
    [self.udpSocket close];
    self.udpSocket.delegate = nil;
    self.udpSocket = nil;
    
    if (self.udpSocket2) {
        [self.udpSocket2 close];
        self.udpSocket.delegate = nil;
        self.udpSocket = nil;
    }
}

#pragma mark -GCDAsyncUdpsocket Delegate

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data fromAddress:(NSData *)address withFilterContext:(id)filterContext
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@",string);
    DeviceModel *device = [[DeviceModel alloc] init];
    [self.delegate didFoundDevice:device];
//    if ([self.deviceType isEqualToString:ROOME_LIGHT]) {
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"string == %@",string);
//        if(string.length > 3){
//            string = [string substringWithRange:NSMakeRange(2, string.length-2)];
//        }
//        string = [string lowercaseString];
//        if ([string hasPrefix:@"roome_hl_"]){ //简版灯
//            NSString *lamp2 = [string substringWithRange:NSMakeRange(9, 8)];
//            NSString *devicesid10 = [CustomNSObject convertHexToLampId:lamp2];
            
//            if (devicesid10) {
//                if (![self.devices containsObject:devicesid10]) {
//                    [self.devices addObject:devicesid10];
//                    DeviceModel *device = [[DeviceModel alloc] init];
//                    device.connectType = DeviceConnectTypeWiFi;
//                    device.kindType = DeviceKindTypeOldLight;
//                    device.deviceName = L(@"good_night_lamp");
//                    device.deviceImage = @"add_dev_light";
//                    device.deviceCode = devicesid10;
//                    device.deviceID = devicesid10;
//                    [self.delegate didFoundDevice:device];
//                    return;
//                }
//            }
//        }
//    }

//    NSString *str = [NSString stringWithFormat:@"%@",[CustomNSObject convertDataToHexStr:data]];
//    NSLog(@"str == %@",str);
//    NSString *str2 =  [str stringByReplacingOccurrencesOfString:@"ff00" withString:@"ff"];
//    str2 =  [str2 stringByReplacingOccurrencesOfString:@"ffa5" withString:@"5a"];
//    str2 =  [str2 stringByReplacingOccurrencesOfString:@"ffa4" withString:@"5b"];
////    NSLog(@"%@",str2);
//
//    if (str.length > 23) {
//        NSString *getStr = [str substringToIndex:22];
//
//        if ([getStr isEqualToString:@"5a42002100000000400102"] ) {
//            NSString *devicesCode16 = [NSString stringWithFormat:@"%@",[str2 substringWithRange:NSMakeRange(62, 8)]];
//            NSString *devicesCode10 = [NSString stringWithFormat:@"%@",[CustomNSObject convertHexToLampId:devicesCode16]];
////            NSLog(@"%@",devicesCode10);
//
//            if (devicesCode10) {
//                if (![self.devices containsObject:devicesCode10] && [str containsString:self.deviceType]) {
//                    [self.devices addObject:devicesCode10];
//
//                    if ([self.delegate respondsToSelector:@selector(didFoundDevice:)]) {
//                        if ([self.deviceType isEqualToString:ROOME_GATEWAY]) {
//                            DeviceModel *device = [[DeviceModel alloc] init];
//                            device.connectType = DeviceConnectTypeWiFi;
//                            device.kindType = DeviceKindTypeSwitchZigbee;
//                            device.deviceName = L(@"gateway");
//                            device.deviceImage = @"management_getaway_on-1";
//                            device.deviceID = devicesCode10;
//                            device.deviceCode = devicesCode10;
//                            [self.delegate didFoundDevice:device];
//
//                        }else if ([self.deviceType isEqualToString:ROOME_LIGHT]){
//                            DeviceModel *device = [[DeviceModel alloc] init];
//                            device.connectType = DeviceConnectTypeWiFi;
//                            device.kindType = DeviceKindTypeLight;
//                            device.deviceName = L(@"good_night_lamp");
//                            device.deviceImage = @"add_dev_light";
//                            device.deviceID = devicesCode10;
//                            device.deviceCode = devicesCode10;
//                            [self.delegate didFoundDevice:device];
//                        }else if ([self.deviceType isEqualToString:ROOME_PLUG]){
//                            NSLog(@"墙插");
//                            DeviceModel *device = [[DeviceModel alloc] init];
//                            device.connectType = DeviceConnectTypeWiFi;
//                            device.kindType = DeviceKindTypeWallPlug;
//                            device.deviceName = L(@"Homi_Plug");
//                            device.deviceImage = @"add_dev_socket";
//                            device.deviceID = devicesCode10;
//                            device.deviceCode = devicesCode10;
//                            [self.delegate didFoundDevice:device];
//                        }
//                    }
//                }
//            }
//        }
//    }
}

- (void)udpSocketDidClose:(GCDAsyncUdpSocket *)sock withError:(NSError *)error
{
    NSLog(@"udpSocketDidClose Error:%@",[error description]);
}




@end
