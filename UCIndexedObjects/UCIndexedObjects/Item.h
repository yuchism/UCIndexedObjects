//
//  Item.h
//  UCIndexedObjects
//
//  Created by John Y on 24/09/2015.
//  Copyright © 2015 Yuch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UCIndexedObjectItemImpl.h"

@interface Item : NSObject<UCIndexedObjectItemImpl>

@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSDate *date;
@property(nonatomic,strong) NSString *itemId;
@property(nonatomic,strong) NSString *groupId;
@end
