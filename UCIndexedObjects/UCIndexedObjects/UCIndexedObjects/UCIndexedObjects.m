//
//  UCIndexedObjects.m
//  CloseFriends
//
//  Created by John Y on 7/05/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

#import "UCIndexedObjects.h"
#import "UCIndexedObjectDefaultGroup.h"

#define kNumberOfCapacity 200

@implementation UCIndexedObjects

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        [self reset];
    }
    return self;
}

- (void)reset
{
    @synchronized(self)
    {
        _inGroupObjectsMap = [NSMutableDictionary dictionaryWithCapacity:kNumberOfCapacity];
        _list = [NSMutableArray arrayWithCapacity:kNumberOfCapacity];
        _index = [NSMutableDictionary dictionaryWithCapacity:kNumberOfCapacity];
        _groupOrderedKeys = nil;
        
        _groupObjectMap = [NSMutableDictionary dictionaryWithCapacity:kNumberOfCapacity];
        _extendedIndex = [NSMutableDictionary dictionaryWithCapacity:kNumberOfCapacity];
        
        self.useReverseSortingForGroup = NO;
    }
}

#pragma mark -- getObject
- (id)firstObjectOfGroup:(NSInteger)group
{
    id<UCIndexedObjectItemImpl> obj = nil;

    @synchronized(self)
    {
        NSArray *array = nil;

        NSString *key = [_groupOrderedKeys objectAtIndex:group];
        array =  [_inGroupObjectsMap objectForKey:key];
        obj = [[array firstObject] copy];
    }
    
    return obj;
}

- (id)objectForGroup:(NSInteger)group idx:(NSInteger)idx
{
    id<UCIndexedObjectItemImpl> obj = nil;
    
    @synchronized(self)
    {
        NSArray *array = nil;

        NSString *key = [_groupOrderedKeys objectAtIndex:group];
        array =  [_inGroupObjectsMap objectForKey:key];
        
        if(idx < [array count])
        {
            obj = [[array objectAtIndex:idx] copy];
        }
    }
    
    return 	obj;
}

- (id)objectForItemKey:(NSString *)itemKey
{
    id object = nil;
    
    @synchronized(self)
    {
        object = [_index objectForKey:itemKey];
    }
    
    return [object copy];
}

- (id) objectForExtendedKey:(NSString *)key
{
    id obj = nil;
    @synchronized(self)
    {
        obj = [_extendedIndex objectForKey:key];
    }
    return [obj copy];
}


#pragma mark -- utility method for collection
- (NSInteger)numberOfGroup
{
    return [_groupOrderedKeys count];
}

- (NSInteger)numberOfObjectsInGroup:(NSInteger)group
{
    NSInteger count = 0;
    @synchronized(self)
    {
        NSString *key = [_groupOrderedKeys objectAtIndex:group];
        count = [(NSArray *)[_inGroupObjectsMap objectForKey:key] count];
    }
    
    return count;
}

- (NSInteger)count
{
    return [_list count];
}


#pragma mark -- utility method for object
- (id)groupWithIdx:(NSInteger)group
{
    NSString *key = [_groupOrderedKeys objectAtIndex:group];
    return [[_groupObjectMap objectForKey:key] copy];
}

- (NSInteger) groupIdx:(id<UCIndexedObjectItemImpl>)object
{
    NSInteger count = 0;
    BOOL isFound = NO;
    for (NSString *tmp in _groupOrderedKeys)
    {
        if([tmp isEqual:[object groupKey]])
        {
            isFound = YES;
            break;
        }
        count ++;
    }
    
    if(!isFound) return NSNotFound;
    
    return count;
}

- (NSInteger) groupIdxWithGroupObject:(id<UCIndexedObjectGroupImpl>)object
{
    NSInteger count = 0;
    BOOL isFound = NO;
    for (NSString *tmp in _groupOrderedKeys)
    {
        if([tmp isEqual:[object groupKey]])
        {
            isFound = YES;
            break;
        }
        count ++;
    }
    
    if(!isFound) return NSNotFound;
    
    return count;
}

- (NSInteger) objectIdxInGroup:(id<UCIndexedObjectItemImpl>)object
{
    id original = [_index objectForKey:[object itemKey]];
    NSMutableArray *array = [_inGroupObjectsMap objectForKey:[object groupKey]];
    
    if(original)
    {
        NSInteger row = [array indexOfObject:original];
        return row;
    }
    
    return NSNotFound;
}

- (void) removeEmptyGroup
{
    [self _removeEmptyGroup];
    [self _sortGroupOrder];
}

- (void) _removeEmptyGroup
{
    NSMutableArray *removeKeys = [NSMutableArray array];
    void (^enumerationBlock)(NSString *,NSArray *, BOOL* )= ^(NSString* key, NSArray * array, BOOL *stop)
    {
        if ([array count] == 0) {
            [removeKeys addObject:key];
        }
    };
    [_inGroupObjectsMap enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:enumerationBlock];
    [_inGroupObjectsMap removeObjectsForKeys:removeKeys];
    [_groupObjectMap removeObjectsForKeys:removeKeys];
}

- (void) _sortGroupOrder
{
    

    if(self.useReverseSortingForGroup)
    {
        _groupOrderedKeys = [[[_groupObjectMap keysSortedByValueUsingSelector:@selector(compare:)] reverseObjectEnumerator] allObjects];
        
    } else
    {
        _groupOrderedKeys = [[[_groupObjectMap keysSortedByValueUsingSelector:@selector(compare:)] objectEnumerator] allObjects];
    }
}


- (UCIndexedObjectsIndex) _indexFromObject:(id<UCIndexedObjectItemImpl>)object
{
    NSMutableArray *groupItems = [_inGroupObjectsMap objectForKey:[object groupKey]];
    NSInteger groupIdx = [_groupOrderedKeys indexOfObject:[object groupKey]];
    NSInteger itemIdx = [groupItems indexOfObject:object];
    
    return UCMakeIndex(groupIdx, itemIdx);
}


- (void) insertObectsBefore:(NSArray *)array
{

    @synchronized(self)
    {
        NSMutableArray *newList = [NSMutableArray array];

        for (id<UCIndexedObjectItemImpl>object in array)
        {
            

                @autoreleasepool {
                    id<UCIndexedObjectItemImpl> original = nil;
                    if((original = [_index objectForKey:[object itemKey]]))
                    {
                        if(![[original groupKey] isEqual:[object groupKey]])
                        {
                            [self _moveObject:original with:object needResult:NO];
                        } else
                        {
                            [self _replaceObject:original with:object needResult:NO];
                        }
                    } else
                    {
                        [self _insertNew:object needResult:NO];
                        [newList addObject:object];
                    }
                }
        }
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:
                               NSMakeRange(0,[newList count])];
        
        [_list insertObjects:newList atIndexes:indexes];
    }
}

- (void) addObject:(id<UCIndexedObjectItemImpl>)object
{
    [self addObject:object needResult:NO];
}



- (UCIndexedObjectsResult *) addObject:(id<UCIndexedObjectItemImpl>)object needResult:(BOOL)needResult
{
    UCIndexedObjectsResult *result = nil;
    NSAssert([object itemKey] != nil, @"item key must be not null");

    if (needResult) {
        result = [[UCIndexedObjectsResult alloc] init];
        result.status = UCIndexedObjectsCompleteStatusUnknown;
    }
    
    @synchronized(self)
    {
        id<UCIndexedObjectItemImpl> original = nil;
        if((original = [_index objectForKey:[object itemKey]]))
        {
            if(![[original groupKey] isEqual:[object groupKey]])
            {
                result = [self _moveObject:original with:object needResult:needResult];
            } else
            {
                result = [self _replaceObject:original with:object needResult:needResult];
            }
            result.addedObject = original;
        } else
        {
            result = [self _insertNew:object needResult:needResult];
            [_list addObject:object];
            result.addedObject = object;
        }
    }
    
    return result;
}

- (void) addGroup:(id<UCIndexedObjectGroupImpl>)group
{
    [self _addGroup:group];
}

- (void) _addGroup:(id<UCIndexedObjectGroupImpl>)group
{
    if ([group groupKey]) {
        if(![_inGroupObjectsMap objectForKey:[group groupKey]])
        {
            [_inGroupObjectsMap setObject:[NSMutableArray array] forKey:[group groupKey]];
        }
        
        if(![_groupObjectMap objectForKey:[group groupKey]])
        {
            [_groupObjectMap setObject:group forKey:[group groupKey]];
        } else
        {
            id<UCIndexedObjectGroupImpl>original = [_groupObjectMap objectForKey:[group groupKey]];

            [original innerCopy:group];
        }
        [self _sortGroupOrder];
    }
}

- (NSArray *) deleteGroup:(id<UCIndexedObjectGroupImpl>)group
{
    NSArray *removedObjects = nil;

    if ([group groupKey])
    {
        
        if((removedObjects = [_inGroupObjectsMap objectForKey:[group groupKey]]))
        {
            [_groupObjectMap removeObjectForKey:[group groupKey]];
            [_inGroupObjectsMap removeObjectForKey:[group groupKey]];
        }
        
        if([_groupObjectMap objectForKey:[group groupKey]])
        {
            [_groupObjectMap removeObjectForKey:[group groupKey]];
        }
        
        [self _sortGroupOrder];
    }

    NSMutableArray *retArray = [NSMutableArray array];
    for (id<UCIndexedObjectItemImpl>item in removedObjects)
    {
        id<UCIndexedObjectItemImpl> copy = [item copyWithZone:nil];
        [retArray addObject:copy];
    }
    return retArray;
}



- (void) sortObjectItem
{
    @synchronized(self)
    {
        for (NSString *groupKey in _groupOrderedKeys)
        {
            NSArray *orignalArray = [_inGroupObjectsMap objectForKey:groupKey];
            if(orignalArray)
            {
                NSArray *sortedArray = [orignalArray sortedArrayUsingSelector:@selector(compare:)];
                [_inGroupObjectsMap setObject:[sortedArray mutableCopy] forKey:groupKey];
            }
        }
    }
}

#pragma mark -- private method for addObject

- (UCIndexedObjectsResult *) _moveObject:(id<UCIndexedObjectItemImpl>)original
                                     with:(id<UCIndexedObjectItemImpl>)object
                               needResult:(BOOL)needResult
{
    UCIndexedObjectsResult *result = nil;
    
    NSMutableArray *beforeGroupItems = [_inGroupObjectsMap objectForKey:[original groupKey]];
    NSMutableArray *afterGroupItems = [_inGroupObjectsMap objectForKey:[object groupKey]];
    
    if(needResult)
    {
        result = [[UCIndexedObjectsResult alloc] init];
        result.status = UCIndexedObjectsCompleteStatusMoveRowAndSection;
        result.fromIndex = [self _indexFromObject:original];
    }
    
    //move group
    if(!afterGroupItems)
    {
        [self _createNewGroupByObject:object];
        afterGroupItems = [_inGroupObjectsMap objectForKey:[object groupKey]];
    }
    
    
    if(NSNotFound != [beforeGroupItems indexOfObject:original])
    {
        [beforeGroupItems removeObject:original];
        [afterGroupItems addObject:original];
    }
    
    [original innerCopy:object];

    
    if([beforeGroupItems count] == 0 && self.removeEmptyGroupAfterMovingObject)
    {
        [self _removeEmptyGroup];
        [self _sortGroupOrder];
    }
    
    
    
    //after move
    if(needResult)
    {
        result.toIndex = [self _indexFromObject:original];
    }
    
    return result;
}

- (UCIndexedObjectsResult *) _replaceObject:(id<UCIndexedObjectItemImpl>)original
                                        with:(id<UCIndexedObjectItemImpl>)object
                                  needResult:(BOOL)needResult
{
    UCIndexedObjectsResult *result = nil;
    
    [original innerCopy:object];
    
    if(needResult)
    {
        result = [[UCIndexedObjectsResult alloc] init];
        result.toIndex = [self _indexFromObject:original];
        result.status = UCIndexedObjectsCompleteStatusReplaced;
    }
    return result;
}

- (UCIndexedObjectsResult *) _insertNew:(id<UCIndexedObjectItemImpl>)object
                              needResult:(BOOL)needResult
{
    UCIndexedObjectsResult *result = nil;
    
    
    [_index setObject:object forKey:[object itemKey]];
    
    //
    if([object respondsToSelector:@selector(extendedIndexKey)])
    {
        NSString *key = [object extendedIndexKey];
        [_extendedIndex setObject:object forKey:key];
    }
    
    //
    if(needResult)
    {
        result = [[UCIndexedObjectsResult alloc] init];
        result.status = UCIndexedObjectsCompleteStatusAddNewRow;
    }
    
    if([object groupKey])
    {
        if(![_inGroupObjectsMap objectForKey:[object groupKey]])
        {

            [self _createNewGroupByObject:object];
            if(needResult)
            {
                result.status = UCIndexedObjectsCompleteStatusAddNewRowAndSection;
            }
        }
        
        NSMutableArray *array = [_inGroupObjectsMap objectForKey:[object groupKey]];
        [array addObject:object];
    }
    
    if(needResult)
    {
        result.toIndex = [self _indexFromObject:object];
    }
    return result;
}

- (void) deleteObject:(id<UCIndexedObjectItemImpl>)object
{
    id<UCIndexedObjectItemImpl> tmpObj = [_index objectForKey:[object itemKey]];
    
    if(!tmpObj) return;
    
    [_index removeObjectForKey:[tmpObj itemKey]];
    if([tmpObj respondsToSelector:@selector(extendedIndexKey)])
    {
        [_extendedIndex removeObjectForKey:[tmpObj extendedIndexKey]];
    }
    
    if([tmpObj groupKey])
    {
        NSMutableArray *array = [_inGroupObjectsMap objectForKey:[tmpObj groupKey]];
        [array removeObject:tmpObj];
    }
    
    if(self.removeEmptyGroupAfterMovingObject)
    {
        [self removeEmptyGroup];
    }
}

- (void) _createNewGroupByObject:(id<UCIndexedObjectItemImpl>)object
{
    id<UCIndexedObjectGroupImpl> group = nil;
    if ([self.groupClass conformsToProtocol:@protocol(UCIndexedObjectGroupImpl)])
    {
        group = [[self.groupClass alloc] initWithItem:object];
    } else
    {
        group = [[UCIndexedObjectDefaultGroup alloc] initWithItem:object];
    }
    [self _addGroup:group];
}


#pragma mark -- NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len
{
    return [_list countByEnumeratingWithState:state objects:buffer count:len];
}


#pragma mark --

- (NSArray *) array
{
    return [_list copy];
}


@end
