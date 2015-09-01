//
//  UCIndexedObjectDefaultGroup.m
//  CloseFriends
//
//  Created by John Y on 12/06/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

#import "UCIndexedObjectDefaultGroup.h"

@interface UCIndexedObjectDefaultGroup()
{
    NSString *_groupKey;
}
@property(nonatomic,readwrite) NSString *groupKey;
@end

@implementation UCIndexedObjectDefaultGroup
@synthesize groupKey = _groupKey;

#pragma mark - Initialization

- (instancetype)initWithItem:(id<UCIndexedObjectItemImpl>)item
{
    self = [super init];
    if(self)
    {
        self.groupKey = [item groupKey];
    }
    return self;
}

- (NSString *)name
{
    return self.groupKey;
}

#pragma mark - UCIndexedObjectGroupImpl

- (void)innerCopy:(UCIndexedObjectDefaultGroup *)src
{
    self.groupKey = src.groupKey;
}

// for sort
#pragma mark -- sort
- (NSComparisonResult)compare:(UCIndexedObjectDefaultGroup *)other {
    return [self.groupKey compare:other.groupKey];
}


- (id)copyWithZone:(NSZone *)zone
{
    UCIndexedObjectDefaultGroup *group = [[[self class] allocWithZone:zone] init];
    group.groupKey = self.groupKey;
    
    
    return group;
}

@end

