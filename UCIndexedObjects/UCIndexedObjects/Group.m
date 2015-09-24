//
//  Group.m
//  UCIndexedObjects
//
//  Created by John Y on 24/09/2015.
//  Copyright © 2015 Yuch. All rights reserved.
//

#import "Group.h"

@implementation Group

- (instancetype)initWithItem:(id<UCIndexedObjectItemImpl>)item
{
    if(self = [super init])
    {
        self.groupKey = [item groupKey];
        self.name = self.groupKey;
    }
    return self;
}

- (void)innerCopy:(Group *)src
{
    self.groupKey = src.groupKey;
    self.name = src.name;
}

- (id)copyWithZone:(NSZone *)zone
{
    typeof(self) group = [[[self class] allocWithZone:zone] init];
    group.groupKey = self.groupKey;
    group.name = self.name;
    
    return group;
}

- (NSComparisonResult)compare:(Group *)other
{
    return [self.groupKey compare:other.groupKey];
}


@end
