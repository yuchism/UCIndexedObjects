//
//  UCIndexedObjects.h
//  CloseFriends
//
//  Created by John Y on 7/05/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCIndexedObjectItemImpl.h"
#import "UCIndexedObjectGroupImpl.h"
#import "UCIndexedObjectsResult.h"


@interface UCIndexedObjects : NSObject <NSFastEnumeration>
{
    NSMutableDictionary *_index;
    NSMutableArray *_list;
    NSArray *_groupOrderedKeys;
    NSMutableDictionary *_inGroupObjectsMap;

    NSMutableDictionary *_groupObjectMap;
    NSMutableDictionary *_extendedIndex;
}

//default NO
@property(nonatomic)    BOOL useReverseSortingForGroup;
@property(nonatomic)    BOOL removeEmptyGroupAfterMovingObject;
@property(nonatomic)    Class groupClass;

- (void)reset;

//get object
- (id)firstObjectOfGroup:(NSInteger)group;
- (id)objectForGroup:(NSInteger)group idx:(NSInteger)idx;
- (id)objectForItemKey:(NSString *)itemKey;
- (id)objectForExtendedKey:(NSString *)key;

// utility method for collection
- (NSInteger)numberOfGroup;
- (NSInteger)numberOfObjectsInGroup:(NSInteger)group;
- (NSInteger)count;

// utility method for object
- (NSInteger) groupIdx:(id<UCIndexedObjectItemImpl>)object;
- (NSInteger) groupIdxWithGroupObject:(id<UCIndexedObjectGroupImpl>)object;

- (NSInteger) objectIdxInGroup:(id<UCIndexedObjectItemImpl>)object;

//addobject
- (UCIndexedObjectsResult *) addObject:(id<UCIndexedObjectItemImpl>)object needResult:(BOOL)needResult;
- (void) addObject:(id<UCIndexedObjectItemImpl>)object;
- (void) deleteObject:(id<UCIndexedObjectItemImpl>)object;

//bulk addObject
- (void) insertObectsBefore:(NSArray *)array;

//addGroup
- (void)addGroup:(id<UCIndexedObjectGroupImpl>)group;
- (NSArray *) deleteGroup:(id<UCIndexedObjectGroupImpl>)group;

//remove Empty Group
- (void) removeEmptyGroup;

//
- (id)groupWithIdx:(NSInteger)group;

//
- (void) sortObjectItem;

- (NSArray *) array;


@end
