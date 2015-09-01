//
//  UCIndexedObjectGroupImpl.h
//  CloseFriends
//
//  Created by John Y on 28/05/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//
#import "UCIndexedObjectItemImpl.h"

@protocol UCIndexedObjectGroupImpl <NSObject,NSCopying>



- (instancetype)initWithItem:(id<UCIndexedObjectItemImpl>)item;
- (void)innerCopy:(id)src;
- (NSString *)groupKey;

@end