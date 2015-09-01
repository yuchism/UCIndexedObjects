//
//  UCIndexedObjectsResult.h
//  CloseFriends
//
//  Created by John Y on 2/06/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCIndexedObjectsCompleteStatus.h"
#import "UCIndexedObjectItemImpl.h"

struct UCIndexedObjectsIndex
{
    NSInteger group;
    NSInteger item;
};

typedef struct UCIndexedObjectsIndex UCIndexedObjectsIndex;

NS_INLINE UCIndexedObjectsIndex UCMakeIndex(NSInteger group, NSInteger item)
{
    UCIndexedObjectsIndex index;
    index.group = group;
    index.item = item;
    return index;
}


@interface UCIndexedObjectsResult : NSObject
@property(nonatomic) UCIndexedObjectsIndex toIndex;
@property(nonatomic) UCIndexedObjectsIndex fromIndex;
@property(nonatomic) UCIndexedObjectsCompleteStatus status;
@property(nonatomic,strong) id<UCIndexedObjectItemImpl> addedObject;
@end
