//
//  Group.h
//  UCIndexedObjects
//
//  Created by John Y on 24/09/2015.
//  Copyright © 2015 Yuch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCIndexedObjectItemImpl.h"
#import "UCIndexedObjectGroupImpl.h"

@interface Group : NSObject<UCIndexedObjectGroupImpl>


@property(nonatomic,strong) NSString *groupKey;
@property(nonatomic,strong) NSString *name;
@end