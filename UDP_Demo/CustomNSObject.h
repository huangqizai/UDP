//
//  CustomNSObject.h
//  HmNsb
//
//  Created by zhoutianyu on 16/8/27.
//  Copyright © 2016年 zhoutianyu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CustomNSObject : NSObject

//利用正则表达式验证手机的合法性
+(BOOL)isPhone:(NSString *)phone;
#pragma mark 判断邮箱
+ (BOOL)checkEmail:(NSString *)email;

//利用正则表达式验证用户名的合法性 不能输入特殊符号
+(BOOL)isUsername:(NSString *)username;

//改变图片大小并且绘制   //压缩图片大小
//+(UIImage*)imageWithImageSimple:(UIImage *)image scaleTOSize:(CGSize)newSize;

//NSDictionary 转json  字典转Json
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary;

//删除userdefault
//+(void)deleteUserDefaultMessage:(NSString *)key;

//匹配正整数
+(BOOL)isPositiveNum:(NSString *)Num;

//根据wifi名称获取wifi密码
//+ (NSString *)getWifiPwd:(NSString *)wifiName;

//添加wifi用户，密码
//+ (void)addUserDef:(NSString*)wifiName wifiPwd:(NSString*)wifiPwd;

//验证本地有没有存wifiName ,有的话更新，没有的话直接添加
//+ (void)validation:(NSString*)wifiName wifiPwd:(NSString*)wifiPwd;

//更改wifi用户，密码
//+ (void)updateArray:(NSString*)wifiName wifiPwd:(NSString*)wifiPwd;

//验证密码是否存在
//+ (BOOL)isInUserDef:(NSString*)wifiName;

/**
 单个16进制转10进制数

 @param string16 16进制数
 */
+ (NSString *)convertTo10:(NSString *)string16;


/**
 16进制转10进制

 @param Id 16进制数
 */
+ (NSString *)convertHexToLampId:(NSString*)Id;


//验证密码是不是字母和数字的组合
+(BOOL)isPwdWithLetterAndNumber:(NSString *)pwd;

 
/**
 十进制转换十六进制
 */
+ (NSString *)ToHex16:(uint16_t)denary;

 /**
 十进制转换16进制 string
 */
+ (NSString *)ToHex16_string:(NSString *)string;

 
/**
 16进制数 -->  nsdata
 从字符串中取字节数组
 
 @param string 16进制数
 */
+ (NSData*)stringToByte:(NSString*)string;

/**
 *  将二进制数据转换成十六进制字符串
 *
 *  @param data 二进制数据
 *
 *  @return 十六进制字符串
 */
+ (NSString *)data2Hex:(NSData *)data;


/**
 2进制转10进制

 @param binary 二进制字符串
 */
+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary;

#pragma mark  蓝牙本地存储相关封装 begin
/**
 查找设备信息，是否已经存在本地
 
 */
//+(BOOL)isInBluetooth:(NSString *)Blueuuid;

/**
 添加蓝牙设备信息到本地
 
 @param BlueToothDevicesDic 蓝牙设备信息
 @param Blueuuid 蓝牙设备的uuid
 */
//+(void)InsertBlueToothDevicesMsgTo_UserDefault:(NSMutableDictionary *)BlueToothDevicesDic Blueuuid:(NSString *)Blueuuid;



/**
 更新本地蓝牙设备信息
 
 @param BlueToothDevicesDic 修改的蓝牙设备信息
 @param Blueuuid 蓝牙设备的uuid
 */
//+(void)UpdateBlueToothDevicesMsgTo_UserDefault:(NSMutableDictionary *)BlueToothDevicesDic Blueuuid:(NSString *)Blueuuid;



/**
 更改本地蓝牙设备单个属性
 
 @param Blueuuid 蓝牙设备的uuid
 @param UpKey 要修改属性的key值
 @param UpVlaue 要修改属性的value
 */
//+(void)UpdateBlueTooThDevicesMsgTo_Single:(NSString *)Blueuuid UpKey:(NSString *)UpKey UpValue:(NSString *)UpVlaue;


/**
 删除一个蓝牙设备
 
 @param Blueuuid 蓝牙设备的uuid
 */
//+(void)DeleteBlueTooThDevicesMsgTo_single:(NSString *)Blueuuid;

//接收到蓝牙信息，转换为string
+ (NSString *)convertDataToHexStr:(NSData *)data;
#pragma mark 蓝牙本地存储相关 end


/**
 年月日 转换为时间戳

 @param nsTime 年与日
 */
//+ (NSString *)StringToTimestamp:(NSString *)nsTime;


/**
 时间戳转换为年与日

 @param nsTime 时间戳
 */
//+ (NSString *)TimestampToString:(NSString *)nsTime;


/**
 获取已连接wifi名称

 @return WiFi名称
 */
//+ (NSString*)getCurrentSSID;



/**
 获取翻转后的crc校验码

 @param str 验证的16进制数 
 */
+ (NSString *)getCRC16:(NSString *)str;


/**
 crc校验码

 @param buf cha类型数组
 @param len 数组长度
 */
+ (uint16_t)crc16:(const char *)buf length:(int)len;



/**
 翻转设备编号

 @param DevicesCode 设备编号，12位10进制数
 */
//+ (NSString *)OverturnCode:(NSString *)DevicesCode;


/**
 蓝牙小夜灯设置日期，年月日时分秒

 @return 年月日时分秒
 */
+ (NSString *)getDateTime;


/**
 蓝牙小夜灯版本号，16进制转换为10进制

 @param version16 16进制版本号
 */
//+ (NSString *)GetBlueVersion10xFrom16x:(NSString *)version16;



/**
 命令获取的mac字符串，转mac格式的地址
 */
+ (NSString *)getMacAddress:(NSString *)value;



/**
 十进制转二进制

 @param decimal 10进制数
 */
+ (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal;


/**
 10进制转2进制后，二进制数转成8位格式

 @param value 2进制数
 */
+ (NSString *)Geterjinzhi8wei:(NSString *)value;


/**
 蓝牙设备，根据蓝牙设备id获取蓝牙设备坐在房间

 @param RoomeId 房间类型
 */
//+ (NSString *)GetRoomNameByRoomeId:(NSString *)RoomeId;

/**
传进来十进制，转成二进制，转化成周几
 
 @param repeatOptions 十进制
 */
+ (NSString *)getClickWeekDay:(NSString *)repeatOptions;

//1000001 to "每周两天"/"每天"/"周末"
+ (NSString *)repeatBinToDayString:(NSString *)repeatBin;

//将十进制转化为二进制,设置返回NSString 长度
+ (NSString *)decimalToBinary:(uint16_t)tmpid backLength:(int)length;

//  二进制转十进制
+ (NSString *)toDecimalWithBinary:(NSString *)binary;


+ (NSString *)getDeviceNameWithModel:(NSString *)deviceModel;
+ (NSString *)getDeviceTypeWithModel:(NSString *)deviceModel;
+ (NSString *)getDeviceIdWithCode:(NSString *)deviceCode;

//+ (UIView *)tableViewHeaderFooterWithText:(NSString *)text;
//+ (CGFloat)heightForHeaderFooterWithText:(NSString *)text;

/**
 16进制数字字符串转数字

 @param hexString <#hexString description#>
 @return <#return value description#>
 */
+ (NSInteger)numberWithHexString:(NSString *)hexString;

/**
 服务器用一个字符代表一周的设置，8位字节，1、0代表on、off，这个方法是把字符转为8位字符串

 @param repeat <#repeat description#>
 @return <#return value description#>
 */
+ (NSString *)weekStringWithRepeatOption:(NSInteger)repeat;

+ (NSArray<NSString *> *)genderGroup;
+ (NSString *)genderWithIndex:(NSString *)index;
+ (NSArray<NSString *> *)userGroups;
+ (NSArray<NSString *> *)memberCharacters;

+ (UIView *)getRedDot;

+ (NSArray<NSString *> *)serverURLLists;
+ (NSString *)defaultServerURL;
+ (void)saveServerURL:(NSString *)URL;

+ (NSArray<NSString *> *)testMember;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC;

/**
 十六进制转换为二进制(输出八位)
 
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;

/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary;

/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary;

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;

/**
 十六进制换十进制转
 */
+ (NSString *)getDecimalByHex:(NSString *)hex;

@end
