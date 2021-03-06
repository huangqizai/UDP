//
//  NSDate+Sankit.h
//  Sankit
//
//  Created by shelley on 14-1-12.
//  Copyright (c) 2014 Sanfriend Co, Ltd. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface NSDate (Sankit)

+ (NSDate *)dateFromTimestamp:(NSNumber *)timestamp;

+ (NSString *)stringFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)timeStringFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)monthDateStringFromTimestamp:(NSNumber *)timestamp;
+ (NSString *)stringFromTimestamp:(NSNumber *)timestamp dateFormat:(NSString *)dateFormat;
- (NSString *)stringWithReadableTimeDifference;

+ (NSDate *)dateFromString:(NSString *)string format:(NSString *)format;
- (NSString *)dateToString;
- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormat;
- (NSString *)dateToStringWithDateFormat:(NSString *)dateFormat timezone:(NSTimeZone *)timezone;

+ (NSString *)currentDateString;
+ (NSNumber *)currentTimestamp;
+ (NSInteger)currentYear;

+ (NSInteger)yearFromDate:(NSDate *)date;
+ (NSInteger)monthFromDate:(NSDate *)date;

+ (NSInteger)yearFromTimestamp:(NSNumber *)timestamp;
+ (NSInteger)monthFromTimestamp:(NSNumber *)timestamp;

- (NSDate *)dateByOffsetMonths:(NSUInteger)months days:(NSUInteger)days hours:(NSUInteger)hours minutes:(NSUInteger)minutes seconds:(NSUInteger)seconds;

- (NSDate *)beginningOfDay;
- (NSDate *)endOfDay;

@end
