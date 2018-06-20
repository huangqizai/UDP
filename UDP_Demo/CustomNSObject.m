//
//  CustomNSObject.m
//  HmNsb
//
//  Created by zhoutianyu on 16/8/27.
//  Copyright © 2016年 zhoutianyu. All rights reserved.
//

#import "CustomNSObject.h"
#import <SystemConfiguration/CaptiveNetwork.h>

//#define BlueToothDevicesMsg @"BlueToothDevicesMsg"

@implementation CustomNSObject

//利用正则表达式验证手机的合法性
+(BOOL)isPhone:(NSString *)phone{
    
//    NSString *regex = @"^[1][3-8]+\\d{9}$";
//    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
//    return [phonePredicate evaluateWithObject:phone];
    return YES;
}

//#pragma mark 判断邮箱
//+ (BOOL)checkEmail:(NSString *)email{
//    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
//    
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    
//    return [emailTest evaluateWithObject:email];
//    
//}

//利用正则表达式验证用户姓名的合法性 不能输入特殊符号
+(BOOL)isUsername:(NSString *)username
{
    NSString *regex = @"^[a-zA-Z0-9\u4e00-\u9fa5]+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [userNamePredicate evaluateWithObject:username];
    
}
//改变图片大小并且绘制
+(UIImage*)imageWithImageSimple:(UIImage *)image scaleTOSize:(CGSize)newSize{
    newSize.height = image.size.height *(newSize.width /image.size.width);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dictionary
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&parseError];
     return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

 

//删除userdefault
+(void)deleteUserDefaultMessage:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

 //匹配正整数
+(BOOL)isPositiveNum:(NSString *)Num{
    
    NSString *regex = @"^[1-9]\\d*$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [phonePredicate evaluateWithObject:Num];
}

//验证本地有没有存wifiName ,有的话更新，没有的话直接添加
+ (void)validation:(NSString*)wifiName wifiPwd:(NSString*)wifiPwd{
    
    BOOL isIn = [self isInUserDef:wifiName];
    if (isIn == YES) {
        //        NSLog(@"存储有数据");
        [self updateArray:wifiName wifiPwd:wifiPwd];
        
     }else{
        //        NSLog(@"没有数据");
        [self addUserDef:wifiName wifiPwd:wifiPwd];
        
     }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *wifiArr = [userDefaults objectForKey:@"LocalWifiNameAndPwd"];
    NSLog(@"本地wifi名称，密码存储信息 %@",wifiArr);
    
    
}

//验证是否存在
+ (BOOL)isInUserDef:(NSString*)wifiName{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *wifiArr = [userDefaults objectForKey:@"LocalWifiNameAndPwd"];
    NSString *pwd ;
    
    if (wifiArr) {
        for (int i = 0; i<wifiArr.count; i++) {
            NSString *userMsg = [wifiArr objectAtIndex:i];
            NSArray *arr = [userMsg componentsSeparatedByString:@";"];
            NSString *name = [NSString stringWithFormat:@"%@",arr[0]];
            NSString *msg = [NSString stringWithFormat:@"%@",arr[1]];
            if ([wifiName isEqualToString:name]) {
                pwd = msg;
            }
        }
    }
    
    if (pwd.length > 0) {
        return YES;
    }else{
        return NO;
    }
}



//更改wifi用户，密码
+ (void)updateArray:(NSString*)wifiName wifiPwd:(NSString*)wifiPwd{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *wifiArr = [userDefaults objectForKey:@"LocalWifiNameAndPwd"];
    //取出userDefaults中数组数据，修改后重新赋值给新的数组
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    if (wifiArr) {
        for (int i = 0; i<wifiArr.count; i++) {
            NSString *userMsg = [wifiArr objectAtIndex:i];
            NSArray *arr = [userMsg componentsSeparatedByString:@";"];
            NSString *name = [NSString stringWithFormat:@"%@",arr[0]];
            if ([wifiName isEqualToString:name]) {
                NSString *nsObj = [NSString stringWithFormat:@"%@;%@",wifiName,wifiPwd];
                [newArray addObject:nsObj];
            }else{
                [newArray addObject:userMsg];
            }
        }
        
        //同步userDefault
        [userDefaults setObject:newArray forKey:@"LocalWifiNameAndPwd"];
        [userDefaults synchronize];
    }
}

//添加wifi用户，密码
+ (void)addUserDef:(NSString*)wifiName wifiPwd:(NSString*)wifiPwd{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *wifiArr = [userDefaults objectForKey:@"LocalWifiNameAndPwd"];
    
    NSMutableArray *addArr = [NSMutableArray arrayWithArray:wifiArr];
    
    NSString *addObj = [NSString stringWithFormat:@"%@;%@",wifiName,wifiPwd];
    [addArr addObject:addObj];
    
    //    NSLog(@"添加 addArr = %@",addArr);
    //同步userDefault
    [userDefaults setObject:addArr forKey:@"LocalWifiNameAndPwd"];
    [userDefaults synchronize];
}

//根据wifi名称获取wifi密码
+ (NSString *)getWifiPwd:(NSString *)wifiName{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *wifiArr = [userDefaults objectForKey:@"LocalWifiNameAndPwd"];
    NSString *pwd ;
    
    if (wifiArr) {
        for (int i = 0; i<wifiArr.count; i++) {
            NSString *userMsg = [wifiArr objectAtIndex:i];
            NSArray *arr = [userMsg componentsSeparatedByString:@";"];
            NSString *name = [NSString stringWithFormat:@"%@",arr[0]];
            NSString *msg = [NSString stringWithFormat:@"%@",arr[1]];
            if ([wifiName isEqualToString:name]) {
                pwd = msg;
            }
        }
    }
    
    return pwd;
    
}

+ (NSString *)convertTo10:(NSString *)string16
{
    if (nil == string16) {
        return nil;
    }
    
    NSString * temp10 = [NSString stringWithFormat:@"%lu",strtoul([string16 UTF8String],0,16)];
    NSString *cycleNumber = [NSString stringWithFormat:@"%@",temp10];
    return cycleNumber;
}


//16进制转10进制
+ (NSString *)convertHexToLampId:(NSString *)Id
{
    NSString * sb1;
    NSString * sb2;
    NSString * sb3;
    NSString * sb4;
    
    NSString *s1 = [Id substringWithRange:NSMakeRange(0, 2)];
    int b1 = (int)strtoul([s1 UTF8String], 0, 16);
    if(b1<10){
        sb1 = [NSString stringWithFormat:@"00%d",b1];
    }else if(b1>=10 && b1<100){
        sb1 = [NSString stringWithFormat:@"0%d",b1];
    }else{
        sb1 = [NSString stringWithFormat:@"%d",b1];
    }
    
    NSString *s2 = [Id substringWithRange:NSMakeRange(2, 2)];
    int b2 = (int)strtoul([s2 UTF8String], 0, 16);
    if(b2<10){
        sb2 = [NSString stringWithFormat:@"00%d",b2];
    }else if(b2>=10 && b2<100){
        sb2 = [NSString stringWithFormat:@"0%d",b2];
    }else{
        sb2 = [NSString stringWithFormat:@"%d",b2];
    }
    
    NSString *s3 = [Id substringWithRange:NSMakeRange(4, 2)];
    int b3 = (int)strtoul([s3 UTF8String], 0, 16);
    if(b3<10){
        sb3 = [NSString stringWithFormat:@"00%d",b3];
    }else if(b3>=10 && b3<100){
        sb3 = [NSString stringWithFormat:@"0%d",b3];
    }else{
        sb3 = [NSString stringWithFormat:@"%d",b3];
    }
    
    NSString *s4 = [Id substringWithRange:NSMakeRange(6, 2)];
    int b4 = (int)strtoul([s4 UTF8String], 0, 16);
    if(b4<10){
        sb4 = [NSString stringWithFormat:@"00%d",b4];
    }else if(b4>=10 && b4<100){
        sb4 = [NSString stringWithFormat:@"0%d",b4];
    }else{
        sb4 = [NSString stringWithFormat:@"%d",b4];
    }
    
    NSString * result = [NSString stringWithFormat:@"%@%@%@%@",sb1,sb2,sb3,sb4];
    return result;

}

 

//验证密码是不是字母和数字的组合
+(BOOL)isPwdWithLetterAndNumber:(NSString *)pwd{
    
    NSString *regex = @"^[a-zA-Z].*[0-9]|.*[0-9].*[a-zA-Z]";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [userNamePredicate evaluateWithObject:pwd];
}

+ (NSString *)ToHex16:(uint16_t)denary{

    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=denary%16;
        denary=denary/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [[nLetterValue stringByAppendingString:str] lowercaseString];
        if (denary == 0) {
            break;
        }
        
    }
    return str;

}

+ (NSString *)ToHex16_string:(NSString *)string{
    NSInteger denary = [string integerValue];
    
    NSString *nLetterValue;
    NSString *str =@"";
    uint16_t ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=denary%16;
        denary=denary/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:
                nLetterValue = [NSString stringWithFormat:@"%u",ttmpig];
                
        }
        str = [[nLetterValue stringByAppendingString:str] lowercaseString];
        if (denary == 0) {
            break;
        }
        
    }
    
//    NSLog(@"10进制：%@；16进制：%@",string,str);
    
    return str;

}

+ (NSData*)stringToByte:(NSString*)string{

    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([hexString length]%2!= 0) {
        return nil;
    }
    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];
    for(int i=0;i<[hexString length];i++)
    {
        unichar hex_char1 = [hexString characterAtIndex:i]; ////两位16进制数中的第一位(高位*16)
        int int_ch1;
        if(hex_char1 >= '0' && hex_char1 <='9')
            int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
        else if(hex_char1 >= 'A' && hex_char1 <='F')
            int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
        else
            return nil;
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i]; ///两位16进制数中的第二位(低位)
        int int_ch2;
        if(hex_char2 >= '0' && hex_char2 <='9')
            int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
        else if(hex_char2 >= 'A' && hex_char2 <='F')
            int_ch2 = hex_char2-55; //// A 的Ascll - 65
        else
            return nil;
        
        tempbyt[0] = int_ch1+int_ch2;  ///将转化后的数放入Byte数组里
        [bytes appendBytes:tempbyt length:1];
    }
    

    return bytes;

}

+ (NSString *)data2Hex:(NSData *)data {
    if (!data) {
        return nil;
    }
    Byte *bytes = (Byte *)[data bytes];
    NSMutableString *str = [NSMutableString stringWithCapacity:data.length * 2];
    for (int i=0; i < data.length; i++){
        [str appendFormat:@"%0x", bytes[i]];
    }
    return str;
}

+ (NSString *)toDecimalSystemWithBinarySystem:(NSString *)binary{

    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}


+(BOOL)isInBluetooth:(NSString *)Blueuuid{
    
    BOOL isIn = NO;
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *DateList = [[NSMutableDictionary alloc]init];
//    DateList = [userdef objectForKey:UserNightLightInfo];
    
    NSString *keyName;
    for (int i = 0; i< [[DateList allKeys] count]; i++) {
        keyName = [[DateList allKeys]objectAtIndex:i];
        if ([keyName isEqualToString:Blueuuid]) {
            NSLog(@"存在 keyname = %@",Blueuuid);
            isIn = YES;
        }
    }
    return isIn;
}

+(void)InsertBlueToothDevicesMsgTo_UserDefault:(NSMutableDictionary *)BlueToothDevicesDic Blueuuid:(NSString *)Blueuuid{
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    //取字典
    NSMutableDictionary *DateList = [[NSMutableDictionary alloc]init];
    NSMutableDictionary *DateList2 = [[NSMutableDictionary alloc]init];
    
//    DateList = [userdef objectForKey:UserNightLightInfo];
    
//    NSLog(@"uuid = %@,dic = %@",Blueuuid,BlueToothDevicesDic);
    
    if (DateList) {
        for (int i = 0; i< [[DateList allKeys] count]; i++) {
            NSLog(@"%@",[[DateList allKeys]objectAtIndex:i ]);
            NSString *keyName = [[DateList allKeys]objectAtIndex:i];
            NSString *value = [DateList objectForKey:[[DateList allKeys]objectAtIndex:i ]];
            //更新蓝牙设备信息
            [DateList2 setObject:value forKey:keyName];
        }
    }
    
    [DateList2 setObject:BlueToothDevicesDic forKey:Blueuuid];
    
//    [userdef setObject:DateList2 forKey:UserNightLightInfo];
    
    [userdef synchronize];
    
}

+(void)UpdateBlueToothDevicesMsgTo_UserDefault:(NSMutableDictionary *)BlueToothDevicesDic Blueuuid:(NSString *)Blueuuid{
    /*
     更新思路：
     1.先取出这个设备存储的字典信息，更改这个字典
     2.过滤取出，除了这个key之外的其他设备信息，全部添加到一个可变的字典中
     3.更新后的设备字典，添加到所有设备的可变字典中
     4.所有设备的可变字典信息就是存储所有设备信息了，更新本地userdefaults信息
     */
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSDictionary *DateList = [[NSDictionary alloc]init];
//    DateList = [userdef objectForKey:UserNightLightInfo];
    //取出userdefault中蓝牙设备信息
    NSMutableDictionary *BlueToothDic = [DateList objectForKey:Blueuuid];
    
    for (int i = 0; i< [[BlueToothDevicesDic allKeys] count]; i++) {
        NSLog(@"%@",[[BlueToothDevicesDic allKeys]objectAtIndex:i ]);
        NSString *keyName = [[BlueToothDevicesDic allKeys]objectAtIndex:i];
        NSString *value = [BlueToothDevicesDic objectForKey:[[BlueToothDevicesDic allKeys]objectAtIndex:i ]];
        //更新蓝牙设备信息
        [BlueToothDic setObject:value forKey:keyName];
    }
    
    NSMutableDictionary  *BlueToothMsg2 = [[NSMutableDictionary alloc]init];
    //过滤本地存储信息
    if ([[DateList allKeys]count] > 1) { //假如仅仅就一个设备的话，就不用拆分了
        for (int i = 0; i< [[DateList allKeys] count]; i++) {
            NSString *keyName = [[DateList allKeys]objectAtIndex:i];
            NSDictionary *dicvalue = [DateList objectForKey:[[DateList allKeys]objectAtIndex:i ]];
            if (![keyName isEqualToString:Blueuuid]) {
                [BlueToothMsg2 setObject:dicvalue forKey:keyName];
            }
        }
    }
    [BlueToothMsg2 setObject:BlueToothDic forKey:Blueuuid];
//    [userdef setObject:BlueToothMsg2 forKey:UserNightLightInfo];
    [userdef synchronize];
    
}

+(void)UpdateBlueTooThDevicesMsgTo_Single:(NSString *)Blueuuid UpKey:(NSString *)UpKey UpValue:(NSString *)UpVlaue{
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *DateList = [[NSMutableDictionary alloc]init];
//    DateList = [userdef objectForKey:UserNightLightInfo];
    
    //取出userdefault中蓝牙设备信息
    NSMutableDictionary *BlueToothDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *tempDic = [DateList objectForKey:Blueuuid];
    if (tempDic) {
        for (int i = 0; i < [[tempDic allKeys]count]; i++) {
            NSString *keyName = [[tempDic allKeys]objectAtIndex:i];
            NSString *value = [tempDic objectForKey:[[tempDic allKeys]objectAtIndex:i ]];
            [BlueToothDic setObject:value forKey:keyName];
        }
    }
    [BlueToothDic setObject:UpVlaue forKey:UpKey];
    NSLog(@"修改后 = %@",BlueToothDic);
    
    
    NSMutableDictionary  *BlueToothMsg2 = [[NSMutableDictionary alloc]init];
    //    过滤本地存储信息
    if ([[DateList allKeys]count] > 1) { //假如仅仅就一个设备的话，就不用拆分了
        for (int i = 0; i< [[DateList allKeys] count]; i++) {
            NSString *keyName = [[DateList allKeys]objectAtIndex:i];
            NSDictionary *dicvalue = [DateList objectForKey:[[DateList allKeys]objectAtIndex:i ]];
            if (![keyName isEqualToString:Blueuuid]) {
                [BlueToothMsg2 setObject:dicvalue forKey:keyName];
            }
        }
    }
    
    [BlueToothMsg2 setObject:BlueToothDic forKey:Blueuuid];
    
//    [userdef setObject:BlueToothMsg2 forKey:UserNightLightInfo];
    [userdef synchronize];
    
}

+(void)DeleteBlueTooThDevicesMsgTo_single:(NSString *)Blueuuid{
    
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *DateList = [[NSMutableDictionary alloc]init];
    
    NSMutableDictionary  *BlueToothMsg2 = [[NSMutableDictionary alloc]init];
    
//    DateList = [userdef objectForKey:UserNightLightInfo];
    NSLog(@"删除datelist = %@ ，uuid = %@",DateList,Blueuuid);
    
    if ([self isInBluetooth:Blueuuid]) {
        NSLog(@"有这个设备");
        //        [DateList removeObjectForKey:Blueuuid];  //删除仅限value是object 字符串的情况下
        if ([[DateList allKeys]count] ==1) { //仅有一个设备的情况下，直接删除usd
            NSLog(@"仅有这个设备");
//            [userdef removeObjectForKey:UserNightLightInfo];
            [userdef synchronize];
            
        }else{
            NSLog(@"有多个设备");
            for (int i = 0; i< [[DateList allKeys] count]; i++) {
                NSString *keyName = [[DateList allKeys]objectAtIndex:i];
                NSDictionary *dicvalue = [DateList objectForKey:[[DateList allKeys]objectAtIndex:i ]];
                if (![keyName isEqualToString:Blueuuid]) {
                    [BlueToothMsg2 setObject:dicvalue forKey:keyName];
                }
            }
//            [userdef setObject:BlueToothMsg2 forKey:UserNightLightInfo];
            [userdef synchronize];
            
        }
        
    }
    
}

//接收到蓝牙信息，转换为string
+ (NSString *)convertDataToHexStr:(NSData *)data{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    
    return string;
}

+ (NSString *)StringToTimestamp:(NSString *)nsTime{
    
    
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *setDate = [dateformatter dateFromString:nsTime];
    NSString *  locationString=[dateformatter stringFromDate:setDate];
    NSDate * now = [dateformatter dateFromString:locationString];
    //转成时间戳
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];
    
    return timeSp;

}

+ (NSString *)TimestampToString:(NSString *)nsTime{
    
//    NSString *str=@"933955200";//时间戳
    NSString *str=nsTime;//时间戳
    NSTimeInterval time=[str doubleValue]+28800;//因为时差问题要加8小时 == 28800 sec
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    NSLog(@"date:%@",[detaildate description]);
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *currentDateStr = [dateFormatter stringFromDate: detaildate];
    
    return currentDateStr;

}

+ (NSString*)getCurrentSSID{
    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    NSString *strSSID = [dctySSID objectForKey:@"SSID"]; //lowercaseString];
    return strSSID;


}

+ (NSString *)getCRC16:(NSString *)str{
    NSString *crc;
    
    NSData *data2 = [[NSData alloc]init];
    NSString *str1 = str;
    data2 = [CustomNSObject stringToByte:str1];
    
    
    int leng = (int)[data2 length] ;
    
    char *test = (char*)[data2 bytes];
    
//    uint16_t ttmpig = [self crc16:test length:leng];
 //    NSLog(@"ttmpig = %hu",ttmpig);
//    NSLog(@"%d", [self crc16:test length:leng]);
//    NSLog(@"%@", [[NSString alloc] initWithFormat: @"%02x", (int) [self crc16:test length:leng]]);
    
    NSString *endString = [[NSString alloc] initWithFormat: @"%02x", (int) [self crc16:test length:leng]];
//    NSLog(@"endString = %@",endString);
    
//    //crc小端
//    if (endString.length == 4) {
//        NSString *str1 = [endString substringToIndex:2];
//        NSString *str2 = [endString substringFromIndex:2];
//         NSString *str3 = [NSString stringWithFormat:@"%@%@",str2,str1];
////        NSLog(@"str3 = %@",str3);
//        crc = str3;
//    }
    
    crc = endString;
    
    
    
    return crc;
    
}


+ (uint16_t)crc16:(const char *)buf length:(int)len{
    int counter;
    uint16_t crc = 0;
    for (counter = 0; counter < len; counter++)
        crc = (crc<<8) ^ crc16tab[((crc>>8) ^ *(char *)buf++)&0x00FF];  // NOLINT
    return crc;
}

static const unsigned short crc16tab[256]= {
    0x0000,0x1021,0x2042,0x3063,0x4084,0x50a5,0x60c6,0x70e7,
    0x8108,0x9129,0xa14a,0xb16b,0xc18c,0xd1ad,0xe1ce,0xf1ef,
    0x1231,0x0210,0x3273,0x2252,0x52b5,0x4294,0x72f7,0x62d6,
    0x9339,0x8318,0xb37b,0xa35a,0xd3bd,0xc39c,0xf3ff,0xe3de,
    0x2462,0x3443,0x0420,0x1401,0x64e6,0x74c7,0x44a4,0x5485,
    0xa56a,0xb54b,0x8528,0x9509,0xe5ee,0xf5cf,0xc5ac,0xd58d,
    0x3653,0x2672,0x1611,0x0630,0x76d7,0x66f6,0x5695,0x46b4,
    0xb75b,0xa77a,0x9719,0x8738,0xf7df,0xe7fe,0xd79d,0xc7bc,
    0x48c4,0x58e5,0x6886,0x78a7,0x0840,0x1861,0x2802,0x3823,
    0xc9cc,0xd9ed,0xe98e,0xf9af,0x8948,0x9969,0xa90a,0xb92b,
    0x5af5,0x4ad4,0x7ab7,0x6a96,0x1a71,0x0a50,0x3a33,0x2a12,
    0xdbfd,0xcbdc,0xfbbf,0xeb9e,0x9b79,0x8b58,0xbb3b,0xab1a,
    0x6ca6,0x7c87,0x4ce4,0x5cc5,0x2c22,0x3c03,0x0c60,0x1c41,
    0xedae,0xfd8f,0xcdec,0xddcd,0xad2a,0xbd0b,0x8d68,0x9d49,
    0x7e97,0x6eb6,0x5ed5,0x4ef4,0x3e13,0x2e32,0x1e51,0x0e70,
    0xff9f,0xefbe,0xdfdd,0xcffc,0xbf1b,0xaf3a,0x9f59,0x8f78,
    0x9188,0x81a9,0xb1ca,0xa1eb,0xd10c,0xc12d,0xf14e,0xe16f,
    0x1080,0x00a1,0x30c2,0x20e3,0x5004,0x4025,0x7046,0x6067,
    0x83b9,0x9398,0xa3fb,0xb3da,0xc33d,0xd31c,0xe37f,0xf35e,
    0x02b1,0x1290,0x22f3,0x32d2,0x4235,0x5214,0x6277,0x7256,
    0xb5ea,0xa5cb,0x95a8,0x8589,0xf56e,0xe54f,0xd52c,0xc50d,
    0x34e2,0x24c3,0x14a0,0x0481,0x7466,0x6447,0x5424,0x4405,
    0xa7db,0xb7fa,0x8799,0x97b8,0xe75f,0xf77e,0xc71d,0xd73c,
    0x26d3,0x36f2,0x0691,0x16b0,0x6657,0x7676,0x4615,0x5634,
    0xd94c,0xc96d,0xf90e,0xe92f,0x99c8,0x89e9,0xb98a,0xa9ab,
    0x5844,0x4865,0x7806,0x6827,0x18c0,0x08e1,0x3882,0x28a3,
    0xcb7d,0xdb5c,0xeb3f,0xfb1e,0x8bf9,0x9bd8,0xabbb,0xbb9a,
    0x4a75,0x5a54,0x6a37,0x7a16,0x0af1,0x1ad0,0x2ab3,0x3a92,
    0xfd2e,0xed0f,0xdd6c,0xcd4d,0xbdaa,0xad8b,0x9de8,0x8dc9,
    0x7c26,0x6c07,0x5c64,0x4c45,0x3ca2,0x2c83,0x1ce0,0x0cc1,
    0xef1f,0xff3e,0xcf5d,0xdf7c,0xaf9b,0xbfba,0x8fd9,0x9ff8,
    0x6e17,0x7e36,0x4e55,0x5e74,0x2e93,0x3eb2,0x0ed1,0x1ef0
};


+ (NSString *)OverturnCode:(NSString *)DevicesCode{
    
    
    NSString *str1 = [DevicesCode substringWithRange:NSMakeRange(0, 3)];
    NSString *str2 = [DevicesCode substringWithRange:NSMakeRange(3, 3)];
    NSString *str3 = [DevicesCode substringWithRange:NSMakeRange(6, 3)];
    NSString *str4 = [DevicesCode substringWithRange:NSMakeRange(9, 3)];
    
    NSString *str = str4;
    
    str = [str stringByAppendingString:str3];
    str = [str stringByAppendingString:str2];
    str = [str stringByAppendingString:str1];
        
    return str;
    
}

+ (NSString *)getDateTime{
    
    //获取当前时间
    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSUInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
      NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSString *year = [NSString stringWithFormat:@"%ld",(long)[dateComponent year]];
    NSString *month = [NSString stringWithFormat:@"%ld",(long)[dateComponent month]];
    NSString *day = [NSString stringWithFormat:@"%ld",(long)[dateComponent day]];
    NSString *hour = [NSString stringWithFormat:@"%ld",(long)[dateComponent hour]];
    NSString *minute = [NSString stringWithFormat:@"%ld",(long)[dateComponent minute]];
    NSString *second = [NSString stringWithFormat:@"%ld",(long)[dateComponent second]];
    
    
//    NSLog(@"year is: %ld", (long)year);
//    NSLog(@"month is: %ld", (long)month);
//    NSLog(@"day is: %ld", (long)day);
//    NSLog(@"hour is: %ld", (long)hour);
//    NSLog(@"minute is: %ld", (long)minute);
//    NSLog(@"second is: %ld", (long)second);
    

    
    
    NSString *nsDateTime = [year substringWithRange:NSMakeRange(2, 2)];
//    nsDateTime = [nsDateTime stringByAppendingString:month];
//    nsDateTime = [nsDateTime stringByAppendingString:day];
//    nsDateTime = [nsDateTime stringByAppendingString:hour];
//    nsDateTime = [nsDateTime stringByAppendingString:minute];
//    nsDateTime = [nsDateTime stringByAppendingString:second];
    
//    NSLog(@"sddd = %@",nsDateTime);
    
    NSString *year16 = [self ToHex16_string:nsDateTime];
     NSString *month16 = [self ToHex16_string:month];
     NSString *day16 = [self ToHex16_string:day];
     NSString *hour16 = [self ToHex16_string:hour];
     NSString *minute16 = [self ToHex16_string:minute];
     NSString *second16 = [self ToHex16_string:second];
    
    //屎一样的代码
    if (year16.length == 1) {
        year16 = [NSString stringWithFormat:@"0%@",year16];
    }
    if (month16.length == 1) {
        month16 = [NSString stringWithFormat:@"0%@",month16];
    }
    if (day16.length == 1) {
        day16 = [NSString stringWithFormat:@"0%@",day16];
    }
    if (hour16.length == 1) {
        hour16 = [NSString stringWithFormat:@"0%@",hour16];
    }
    if (minute16.length == 1) {
        minute16 = [NSString stringWithFormat:@"0%@",minute16];
    }
    if (second16.length == 1) {
        second16 = [NSString stringWithFormat:@"0%@",second16];
    }
    
    NSString *nsDateTime2 = year16;
    nsDateTime2 = [nsDateTime2 stringByAppendingString:month16];
    nsDateTime2 = [nsDateTime2 stringByAppendingString:day16];
    nsDateTime2 = [nsDateTime2 stringByAppendingString:hour16];
    nsDateTime2 = [nsDateTime2 stringByAppendingString:minute16];
    nsDateTime2 = [nsDateTime2 stringByAppendingString:second16];
    
  
 
    
    
    return nsDateTime2;

}

+ (NSString *)GetBlueVersion10xFrom16x:(NSString *)version16{

    NSString *str11 = [version16 substringWithRange:NSMakeRange(0, 2)];
    NSString *str12 = [version16 substringWithRange:NSMakeRange(2, 2)];
    NSString *str13 = [version16 substringWithRange:NSMakeRange(4, 2)];
    
    NSString *ver1 = [self convertTo10:str11];
    NSString *ver2 = [self convertTo10:str12];
    NSString *ver3 = [self convertTo10:str13];
    
    
    
    NSString *version = [NSString stringWithFormat:@"%@.%@.%@",ver1,ver2,ver3];
    
    return version;
    
}


+ (NSString *)getMacAddress:(NSString *)value{

    NSString *str0 = value;
    str0 = [str0 uppercaseString]; //大写
    NSLog(@"str0 = %@",str0);
    
    NSString *str1 = [str0 substringWithRange:NSMakeRange(0, 2)];
    NSString *str2 = [str0 substringWithRange:NSMakeRange(2, 2)];
    NSString *str3 = [str0 substringWithRange:NSMakeRange(4, 2)];
    NSString *str4 = [str0 substringWithRange:NSMakeRange(6, 2)];
    NSString *str5 = [str0 substringWithRange:NSMakeRange(8, 2)];
    NSString *str6 = [str0 substringWithRange:NSMakeRange(10, 2)];
    NSString *str7 = @":";
    
    NSString *str = str1;
    str = [str stringByAppendingString:str7];
    str = [str stringByAppendingString:str2];
    str = [str stringByAppendingString:str7];
    str = [str stringByAppendingString:str3];
    str = [str stringByAppendingString:str7];
    str = [str stringByAppendingString:str4];
    str = [str stringByAppendingString:str7];
    str = [str stringByAppendingString:str5];
    str = [str stringByAppendingString:str7];
    str = [str stringByAppendingString:str6];
    
    NSLog(@"str = %@",str );
    
    return str;
}

//十进制转二进制
+ (NSString *)toBinarySystemWithDecimalSystem:(NSInteger)decimal
{
    NSInteger num = decimal;//[decimal intValue];
    NSInteger remainder = 0;      //余数
    NSInteger divisor = 0;        //除数
    
    NSString * prepare = @"";
    
    while (true)
    {
        remainder = num%2;
        divisor = num/2;
        num = divisor;
        prepare = [prepare stringByAppendingFormat:@"%ld",(long)remainder];
        
        if (divisor == 0)
        {
            break;
        }
    }
    
    NSString * result = @"";
    for (NSInteger i = prepare.length - 1; i >= 0; i --)
    {
        result = [result stringByAppendingFormat:@"%@",
                  [prepare substringWithRange:NSMakeRange(i , 1)]];
    }
    
    return result;
}

+ (NSString *)Geterjinzhi8wei:(NSString *)value{

    NSString *getStr = value;
    if (getStr.length==1) {
        getStr = [NSString stringWithFormat:@"0000000%@",getStr];
        
    }else if (getStr.length == 2){
        getStr = [NSString stringWithFormat:@"000000%@",getStr];
    
    }else if (getStr.length == 3){
        getStr = [NSString stringWithFormat:@"00000%@",getStr];
    }else if (getStr.length == 4){
        getStr = [NSString stringWithFormat:@"0000%@",getStr];
    }else if (getStr.length == 5){
        getStr = [NSString stringWithFormat:@"000%@",getStr];
    }else if (getStr.length == 6){
        getStr = [NSString stringWithFormat:@"00%@",getStr];
    }else if (getStr.length == 7){
        getStr = [NSString stringWithFormat:@"0%@",getStr];
    }else{
    
    }
    return getStr;
}

+ (NSString *)GetRoomNameByRoomeId:(NSString *)RoomeId{

    NSString *roomeName = @"";
//    if ([RoomeId isEqualToString:@"00"]) {
//        roomeName = L(@"room_type_0");
//    }else if ([RoomeId isEqualToString:@"01"]){
//        roomeName  = L(@"livingroom");
//    }else if ([RoomeId isEqualToString:@"02"]){
//        roomeName  = @"书房";
//    }else if ([RoomeId isEqualToString:@"03"]){
//        roomeName  = @"儿童房";
//    }else if ([RoomeId isEqualToString:@"04"]){
//        roomeName  = @"浴室";
//    }else if ([RoomeId isEqualToString:@"05"]){
//        roomeName  = @"厨房";
//    }else if ([RoomeId isEqualToString:@"06"]){
//        roomeName  = @"餐厅";
//    }else if ([RoomeId isEqualToString:@"07"]){
//        roomeName  = @"走廊";
//    }else if ([RoomeId isEqualToString:@"08"]){
//        roomeName  = @"衣帽间";
//    }else if ([RoomeId isEqualToString:@"09"]){
//        roomeName  = L(@"feedback_4");
//    }else if ([RoomeId isEqualToString:@"10"]){
//        roomeName  = @"休息室";
//    }else{
//        roomeName  = @"公共空间";
//    }
    
    
    return roomeName;
}


+ (NSString *)getClickWeekDay:(NSString *)repeatOptions{
    
    NSString *SettingWeekDays;
    
    NSInteger decimal = [repeatOptions integerValue];
    NSString *reser2 = [CustomNSObject toBinarySystemWithDecimalSystem:decimal];
    
    if ([reser2 isEqualToString:@"0"]) {
//        return L(@"only_one");
    }
    
    if (decimal == 254) {
//        return L(@"everyday");
    }
    
    reser2 = [NSString stringWithFormat:@"%.8ld",[reser2 integerValue]];
//    if (reser2.length <8) {
//        if (reser2.length == 7) {
//            reser2 = [NSString stringWithFormat:@"0%@",reser2];
//        }else if (reser2.length == 6) {
//            reser2 = [NSString stringWithFormat:@"00%@",reser2];
//        }else if (reser2.length == 5) {
//            reser2 = [NSString stringWithFormat:@"000%@",reser2];
//        }else if (reser2.length == 4) {
//            reser2 = [NSString stringWithFormat:@"0000%@",reser2];
//        }else if (reser2.length == 3) {
//            reser2 = [NSString stringWithFormat:@"00000%@",reser2];
//        }else if (reser2.length == 2) {
//            reser2 = [NSString stringWithFormat:@"000000%@",reser2];
//        }else if (reser2.length == 1) {
//            reser2 = [NSString stringWithFormat:@"0000000%@",reser2];
//        }
//    }
    
//    NSString *str0 = L(@"wakeup");
    NSString *str0 = @"";
//    if ([AppDelegate getInstance].isChinese) {
////        str0 = [str0 stringByAppendingString:L(@"comma")];
//    }
    
    NSString *str1 = [reser2 substringWithRange:NSMakeRange(6, 1)];
    if ([str1 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"monday1")]];
    }
    NSString *str2 = [reser2 substringWithRange:NSMakeRange(5, 1)];
    if ([str2 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"tuesday2")]];
    }
    NSString *str3 = [reser2 substringWithRange:NSMakeRange(4, 1)];
    if ([str3 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"wednesday3")]];
    }
    NSString *str4 = [reser2 substringWithRange:NSMakeRange(3, 1)];
    if ([str4 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"thursday4")]];
    }
    NSString *str5 = [reser2 substringWithRange:NSMakeRange(2, 1)];
    if ([str5 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"friday5")]];
    }
    NSString *str6 = [reser2 substringWithRange:NSMakeRange(1, 1)];
    if ([str6 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"saturday6")]];
    }
    NSString *str7 = [reser2 substringWithRange:NSMakeRange(0, 1)];
    if ([str7 isEqualToString:@"1"]) {
//        str0 = [str0 stringByAppendingString:[NSString stringWithFormat:@"%@ ",L(@"sunday7")]];
    }
    
    SettingWeekDays = str0;
    
    return SettingWeekDays;
}

//1000001 to "每周两天"/"每天"/"周末"
//+ (NSString *)repeatBinToDayString:(NSString *)repeatBin
//{
//    if ([repeatBin hasPrefix:@"1111111"]) {
////        return L(@"everyday");
//    }
//    
////    if ([repeatBin hasPrefix:@"1100000"]) {
////        return L(@"weekend");
////    }
////
////    if ([repeatBin hasPrefix:@"0011111"]) {
////        return L(@"workday");
////    }
//    
//    NSInteger count = 0;
//    for(int i = 0; i < [repeatBin length] - 1; i++)
//    {
//        NSString *tag = [repeatBin substringWithRange:NSMakeRange(i, 1)];
//        if ([tag integerValue] == 1) {
//            count++;
//        }
//    }
//    return [NSString stringWithFormat:L(@"ever_week"),@(count)];
//}

+ (NSString *)decimalToBinary:(uint16_t)tmpid backLength:(int)length
{
    NSString *a = @"";
    while (tmpid)
    {
        a = [[NSString stringWithFormat:@"%d",tmpid%2] stringByAppendingString:a];
        if (tmpid/2 < 1)
        {
            break;
        }
        tmpid = tmpid/2 ;
    }
    
    if (a.length <= length)
    {
        NSMutableString *b = [[NSMutableString alloc]init];;
        for (int i = 0; i < length - a.length; i++)
        {
            [b appendString:@"0"];
        }
        
        a = [b stringByAppendingString:a];
    }
    
    return a;
}

//  二进制转十进制
+ (NSString *)toDecimalWithBinary:(NSString *)binary
{
    int ll = 0 ;
    int  temp = 0 ;
    for (int i = 0; i < binary.length; i ++)
    {
        temp = [[binary substringWithRange:NSMakeRange(i, 1)] intValue];
        temp = temp * powf(2, binary.length - i - 1);
        ll += temp;
    }
    
    NSString * result = [NSString stringWithFormat:@"%d",ll];
    
    return result;
}

//+ (NSString *)getDeviceNameWithModel:(NSString *)deviceModel
//{
//    NSDictionary *names = @{@"switch_bt_1":L(@"ble_switch_1_key_pro"),
//                            @"switch_bt_2":L(@"ble_switch_2_key_pro"),
//                            @"switch_bt_3":L(@"ble_switch_3_key_pro"),
//                            @"switch_bt_4":L(@"ble_switch_4_key_pro"),
//                            @"switch_zb_1":L(@"switch_1_key_pro"),
//                            @"switch_zb_2":L(@"switch_2_key_pro"),
//                            @"switch_zb_3":L(@"switch_3_key_pro"),
//                            @"switch_zb_4":L(@"switch_4_key_pro"),
//                            @"gateway":L(@"gateway"),
//                            kDMLight:L(@"good_night_lamp"),
//                            kDMLightMini:L(@"roome_light_bottle"),
//                            kDMWallplug:L(@"Homi_Plug")
//                            };

//    if (![names.allKeys containsObject:deviceModel]) {
//        return deviceModel;
//    } else {
//        return names[deviceModel];
//    }
//}

//+ (NSString *)getDeviceTypeWithModel:(NSString *)deviceModel
//{
//    NSDictionary *types = @{@"switch_bt_1":L(@"ble_switch_1_key"),
//                            @"switch_bt_2":L(@"ble_switch_2_key"),
//                            @"switch_bt_3":L(@"ble_switch_3_key"),
//                            @"switch_bt_4":L(@"ble_switch_4_key"),
//                            @"switch_zb_1":L(@"switch_1_key"),
//                            @"switch_zb_2":L(@"switch_2_key"),
//                            @"switch_zb_3":L(@"switch_3_key"),
//                            @"switch_zb_4":L(@"switch_4_key"),
//                            @"gateway":@"Roome Hub",
//                            kDMLight:@"Roome Light",
//                            kDMLightMini:@"Roome Light Mini",
//                            kDMWallplug:L(@"Roome HomiPlug")
//                            };
//    if (![types.allKeys containsObject:deviceModel]) {
//        return deviceModel;
//    } else {
//        return types[deviceModel];
//    }
//}

+ (NSString *)getDeviceIdWithCode:(NSString *)deviceCode
{
    return [NSString stringWithFormat:@"ROOME-%@",deviceCode];
}

//+ (UIView *)tableViewHeaderFooterWithText:(NSString *)text
//{
//    if (text == nil || text.length == 0) {
//        return nil;
//    }

//    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
//    header.backgroundColor = [UIColor clearColor];
//
//    UILabel *label = [UILabel initWithFrame:CGRectMake(18, 0, kScreenWidth - 36, 30)
//                                       text:text
//                                       font:NormalFont
//                                       size:12
//                                      color:[UIColor colorWithHexString:@"576F82"]
//                                  alignment:NSTextAlignmentLeft
//                                      lines:0];
//    [label linesToFit];
//    [header addSubview:label];
//
//    if (label.height > 30) {
//        header.height = label.height + 10;
//    }
//    label.bottom = header.height - 5;
//
//    if ([text isEqualToString:L(@"lightmini_light_sensor_auto_open_tip")] || [text isEqualToString:L(@"lightmini_light_sensor_auto_close_tip")]) {
//        label.top = 5;
////    }
//    return header;
//}

//+ (CGFloat)heightForHeaderFooterWithText:(NSString *)text
//{
//    if (text == nil || text.length == 0) {
//        return 0;
//    }
//
//    UILabel *label = [UILabel initWithFrame:CGRectMake(18, 0, kScreenWidth - 36, 30)
//                                       text:text
//                                       font:NormalFont
//                                       size:12
//                                      color:[UIColor colorWithHexString:@"576F82"]
//                                  alignment:NSTextAlignmentLeft
//                                      lines:0];
//    [label linesToFit];
//
//    if (label.height > 30) {
//        return label.height + 10;
//    } else {
//        return 40;
//    }
//}

+ (NSInteger)numberWithHexString:(NSString *)hexString
{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

+ (NSString *)weekStringWithRepeatOption:(NSInteger)repeat
{
    NSString *week = [self toBinarySystemWithDecimalSystem:repeat];
    return [NSString stringWithFormat:@"%.8ld",[week integerValue]];
}

//+ (NSArray *)genderGroup
//{
//    return @[L(@"female"),L(@"male")];
//}

//+ (NSString *)genderWithIndex:(NSString *)index
//{
//    NSArray *gender = [self genderGroup];
//    if ([index integerValue] < gender.count) {
//        return [gender objectAtIndex:[index integerValue]];
//    } else {
//        return L(@"please_choose");
//    }
//}
//
//+ (NSArray *)userGroups
//{
//    return @[L(@"student"),L(@"worker"),L(@"retire_people")];
//}
//
//+ (NSArray *)memberCharacters
//{
//    return @[L(@"member_character0"),L(@"member_character1"),L(@"member_character2"),L(@"member_character3")];
//}

//+ (UIView *)getRedDot
//{
//    UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
//    dot.layer.cornerRadius = 4;
//    dot.layer.masksToBounds = YES;
//    dot.backgroundColor = [UIColor redColor];
//    dot.centerY = 25;
//    return dot;
//}
//
//+ (NSArray<NSString *> *)serverURLLists
//{
//    return @[ChinaServer,
//             USServer,
//             @"http://59.110.49.197:8080/rmf-web/",
//             @"http://192.168.3.9:8080/",
//             @"http://192.168.3.173:8089/",
//             @"http://192.168.31.138:8089/",
//             @"http://192.168.3.247:8089/",
//             @"http://192.168.32.254:8055/"];
//}
//
//+ (NSString *)defaultServerURL
//{
//    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:groupIdentifier];
//    NSString *baseUrl = [userDefault objectForKey:@"kBaseURL"];
//    if (DEMOMODE) {
//        NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:groupIdentifier];
//        baseUrl = [userDefault objectForKey:@"kBaseURL"];
//        if (baseUrl == nil) {
//            baseUrl = @"http://59.110.49.197:8080/rmf-web/";
//        }
//    } else {
//        if ([AppDelegate getInstance].serverType == ServerTypeCN) {
//            baseUrl = ChinaServer;
//        } else {
//            baseUrl = USServer;
//        }
//    }
//    [self saveServerURL:baseUrl];
//    return baseUrl;
//}

//+ (void)saveServerURL:(NSString *)URL
//{
//    NSUserDefaults *userDefault = [[NSUserDefaults alloc] initWithSuiteName:groupIdentifier];
//    [userDefault setObject:URL forKey:@"kBaseURL"];
//    [userDefault synchronize];
//}

+ (NSArray<NSString *> *)testMember
{
    return @[@"17600119101",
             @"18734911273",
             @"weichunhao@live.com",
             @"373448494@qq.com",
             @"373448494@vip.qq.com",
             @"171966841@qq.com"];
}

//获取当前屏幕显示的viewcontroller
//+ (UIViewController *)getCurrentVC
//{
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
//
//    if ([currentVC isKindOfClass:[RTContainerController class]]) {
//        UIViewController *controller = ((RTContainerController *)currentVC).contentViewController;
//        return controller;
//    }
//
//    return currentVC;
//}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if ([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    
    if ([rootVC isKindOfClass:[UITabBarController class]]) {
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    } else if ([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    } else {
        // 根视图为非导航类
        currentVC = rootVC;
    }
    
    return currentVC;
}

/**
 十六进制转换为二进制(输出八位)
 
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex
{
    if (hex == nil) {
        return nil;
    }
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i < [hex length]; i++) {
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            binary = [binary stringByAppendingString:value];
        }
    }
    if (binary.length < 8) {
        binary = [NSString stringWithFormat:@"0000%@",binary];
    }
    return binary;
}

/**
 二进制转换成十六进制
 
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary
{
    if (binary == nil) {
        return nil;
    }
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex.lowercaseString;
}

/**
 二进制转换为十进制
 
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary
{
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            decimal += pow(2, i);
        }
    }
    return decimal;
}

/**
 十进制转换为二进制
 
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal
{
    NSString *binary = @"";
    while (decimal) {
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

/**
 十进制转换十六进制
 
 @param decimal 十进制数
 @return 十六进制数
 */
+ (NSString *)getHexByDecimal:(NSInteger)decimal
{
    NSString *hex =@"";
    NSString *letter;
    NSInteger number;
    for (int i = 0; i<9; i++) {
        
        number = decimal % 16;
        decimal = decimal / 16;
        switch (number) {
                
            case 10:
                letter =@"A"; break;
            case 11:
                letter =@"B"; break;
            case 12:
                letter =@"C"; break;
            case 13:
                letter =@"D"; break;
            case 14:
                letter =@"E"; break;
            case 15:
                letter =@"F"; break;
            default:
                letter = [NSString stringWithFormat:@"%ld", number];
        }
        hex = [letter stringByAppendingString:hex];
        if (decimal == 0) {
            
            break;
        }
    }
    return hex;
}

/**
 十六进制换十进制转
 */
+ (NSString *)getDecimalByHex:(NSString *)hex
{
    if (nil == hex) {
        return nil;
    }
    NSString *temp10 = [NSString stringWithFormat:@"%lu",strtoul([hex UTF8String], 0, 16)];
    NSString *cycleNumber = [NSString stringWithFormat:@"%@",temp10];
    return cycleNumber;
}

@end
