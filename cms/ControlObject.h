//
//  ControlObject.h
//  cms
//
//  Created by Griffin Anderson on 8/16/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpdateObject.h"

typedef enum {
    ProgressPassed,
    ProgressFailedToLoadObject,
    ProgressFailedToSave,
    ProgressFailedToInitControl
} ControlProgress;

@interface ControlObject : NSObject

typedef void (^ProgressCompletionBlock)(ControlProgress progress, PFObject *selfie, NSError *error);

- (id) init;
- (void) updateObject:(UpdateObject *)updateObject block:(ProgressCompletionBlock)block;

@end
