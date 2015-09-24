//
//  UCIdGen.m
//  UCIndexedObjects
//
//  Created by John Y on 15/09/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import "UCIDGen.h"

@interface UCIDGen()
{
    NSInteger index;
}
@end

@implementation UCIDGen

+ (instancetype)sharedInstance {
    static UCIDGen *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^ {
        sharedInstance = [[UCIDGen alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        index = 0;
    }
    return self;
}


- (NSString *) generateID
{
    NSString *str = nil;
    @synchronized(self)
    {
        index = (index >= 3000000) ? 0 : index + 1;
        long long timeKey = [[NSDate date] timeIntervalSince1970] * 100;
        str = [NSString stringWithFormat:@"%llX%04lX",timeKey,(long)index];
    }
    return str;
}
@end
