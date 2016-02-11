//
//  UpdateObject.h
//  cms
//
//  Created by Griffin Anderson on 8/16/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SelfieObject.h"

typedef enum {
    StateGood,
    StateModerate,
    StateSevere,
    StateExtreme,
    StateAuthorities,
} NewControlStates;

@interface UpdateObject : NSObject

- (id) initWithSelfie:(SelfieObject*)selfie;
- (BOOL) canPost;

@property SelfieObject *selfieObject;
@property NewControlStates state;
@property SelfieComplaint complaint;
@property NSMutableArray* removedHashtags;
@property int likes;
@property int visits;

@end
