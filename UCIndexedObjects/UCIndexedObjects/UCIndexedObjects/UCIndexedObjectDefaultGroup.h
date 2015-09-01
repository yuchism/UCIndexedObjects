//
//  UCIndexedObjectDefaultGroup.h
//  CloseFriends
//
//  Created by John Y on 12/06/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCIndexedObjectItemImpl.h"
#import "UCIndexedObjectGroupImpl.h"

@interface UCIndexedObjectDefaultGroup : NSObject <UCIndexedObjectGroupImpl>



- (NSString *)name;
@end
