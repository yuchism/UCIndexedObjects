//
//  UCIdGen.h
//  UCIndexedObjects
//
//  Created by John Y on 15/09/2015.
//  Copyright (c) 2015 Yuch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UCIDGen : NSObject

+ (instancetype)sharedInstance;
- (NSString *) generateID;

@end
