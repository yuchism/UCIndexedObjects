//
//  UCIndexedObjectsCompleteStatus.h
//  CloseFriends
//
//  Created by John Y on 2/06/2015.
//  Copyright (c) 2015 CloseFriends. All rights reserved.
//

typedef enum
{
    UCIndexedObjectsCompleteStatusUnknown = 0,
    UCIndexedObjectsCompleteStatusAddNewRow,
    UCIndexedObjectsCompleteStatusAddNewRowAndSection,
    UCIndexedObjectsCompleteStatusMoveRowAndSection,
    UCIndexedObjectsCompleteStatusReplaced,
} UCIndexedObjectsCompleteStatus;
