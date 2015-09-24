//
//  NSDate+Utils.m
//  UCIndexedObjects
//
//  Created by John Y on 17/09/2015.
//  Copyright © 2015 Yuch. All rights reserved.
//

#import "NSDate+Utils.h"

@implementation NSDate(Utils)


- (NSString *)YYYYMMddHHmmss
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [formatter stringFromDate:self];
}

- (NSString *)YYYYMMddHHmmssSSS
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYYMMddHHmmss.SSS"];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [formatter stringFromDate:self];
}


@end
