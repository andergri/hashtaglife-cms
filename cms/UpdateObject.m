//
//  UpdateObject.m
//  cms
//
//  Created by Griffin Anderson on 8/16/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "UpdateObject.h"

@interface UpdateObject ()

@end

@implementation UpdateObject

@synthesize selfieObject;
@synthesize removedHashtags;
@synthesize likes;
@synthesize visits;
@synthesize state;
@synthesize complaint;

- (id)initWithSelfie:(SelfieObject*)selfie{
    if ((self = [super init])) {
        selfieObject = selfie;
        likes = 0;
        visits = 0;
        [self setIntialState];
        complaint = ComplaintNotSet;
        removedHashtags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void) setIntialState{
    switch (selfieObject.status) {
        case StatusRed:
            state = StateSevere;
            break;
        case StatusPurple:
            state = StateGood;
            break;
        case StatusGreen:
            state = StateGood;
            break;
        case StatusYellow:
            state = StateModerate;
            break;
        default:
            break;
    }
}

- (BOOL) canPost{
    if (complaint == ComplaintNotSet && state != StateGood) {
        return false;
    }
    return true;
}

@end
