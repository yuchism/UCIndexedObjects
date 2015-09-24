//
//  Item.m
//  UCIndexedObjects
//
//  Created by John Y on 24/09/2015.
//  Copyright © 2015 Yuch. All rights reserved.
//

#import "Item.h"
#import "NSDate+Utils.h"
#import "UCIDGen.h"

@implementation Item

- (id)init
{
    self = [super init];
    if(self)
    {
        self.itemId = [[UCIDGen sharedInstance] generateID];
        self.name = self.itemId;
        self.date = [NSDate date];
        
    }
    
    return self;
}

- (NSString *) groupKey
{
    return [self.date YYYYMMddHHmmss];
}

- (NSString *) itemKey
{
    return self.itemId;
}

- (void) innerCopy:(id<UCIndexedObjectItemImpl>)src
{
    [self copyWithSource:src target:self];
}

- (void) copyWithSource:(Item *)src target:(Item *)target
{
    target.itemId = src.itemId;
    target.groupId = src.groupId;
    
    target.date = src.date;
    target.name = src.name;
    
}

- (id)copyWithZone:(NSZone *)zone
{
    typeof(self) newOne = [[[self class] allocWithZone:zone] init];
    
    [self copyWithSource:self target:newOne];
    
    return newOne;
}

- (NSString *)extendedIndexKey
{
    return [self.date YYYYMMddHHmmssSSS];
}

- (NSComparisonResult)compare:(Item *)other
{
    return [self.date compare:other.date];
}

@end