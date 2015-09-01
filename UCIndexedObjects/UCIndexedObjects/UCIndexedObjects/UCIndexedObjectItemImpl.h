//
//  UCIndexedObjectItemImpl.h
//  CloseFriends
//
//  Created by John Y on 7/05/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

@protocol UCIndexedObjectItemImpl<NSObject,NSCopying>

- (NSString *) groupKey;
- (NSString *) itemKey;


- (void) innerCopy:(id<UCIndexedObjectItemImpl>)src;

@optional

- (NSString *)extendedIndexKey;
- (NSComparisonResult)compare:(id<UCIndexedObjectItemImpl>)other;

@end


