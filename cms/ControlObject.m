//
//  ControlObject.m
//  cms
//
//  Created by Griffin Anderson on 8/16/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "ControlObject.h"

@implementation ControlObject


- (id)init{
    if ((self = [super init])) {
    }
    return self;
}

/** MAIN: UPDATE SELIFE **/

- (void) updateObject:(UpdateObject*)updateObject block:(ProgressCompletionBlock)block{
    if (updateObject.selfieObject != nil) {
        [self callSelfie:updateObject.selfieObject.objectId block:^(PFObject *loadSelfie, NSError *error) {
            if (error == nil) {
                
                // Update All Selfie
                [self updateSelifeLikes:updateObject.likes selife:loadSelfie];
                [self updateSelifeVisits:updateObject.visits selife:loadSelfie];
                [self removeHashtags:(NSArray*)updateObject.removedHashtags selife:loadSelfie];
                [self createEntryForBadHashtag:(NSArray*)updateObject.removedHashtags];
                [self changeState:(NewControlStates)updateObject.state complaint:(SelfieComplaint)updateObject.complaint selife:loadSelfie userId:updateObject.selfieObject.userObject.objectId];
                [loadSelfie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        block(ProgressPassed, loadSelfie, error);
                    }else{
                        block(ProgressFailedToSave, nil, error);
                    }
                }];
                
            }else{
                block(ProgressFailedToLoadObject, nil, error);
            }
        }];
    }else{
        block(ProgressFailedToInitControl, nil, nil);
    }
}

/** COMPLETION BLOCK **/

typedef void (^SelfieCompletionBlock)(PFObject *selfie, NSError *error);

/** HELPER METHODS **/

- (void) callSelfie:(NSString*)selfieId block:(SelfieCompletionBlock)completionBlock{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:selfieId block:^(PFObject *selfie, NSError *error) {
        completionBlock(selfie, error);
    }];
}

// UPDATE FILEDS

- (void) updateSelifeLikes:(int)by selife:(PFObject *)selfie{
    int newLikes = [selfie[@"likes"] intValue];
    newLikes += by;
    selfie[@"likes"] = @(newLikes);
}

- (void) updateSelifeVisits:(int)by selife:(PFObject *)selfie{
    int newLikes = [selfie[@"visits"] intValue];
    newLikes += by;
    selfie[@"visits"] = @(newLikes);
}

- (void) removeHashtags:(NSArray *)removeHashtags selife:(PFObject *)selfie{
    NSMutableArray* newHashtags = selfie[@"hashtags"];
    for (NSString *hashtag in removeHashtags) {
        if ([newHashtags containsObject:hashtag]) {
            [newHashtags removeObject:hashtag];
        }
    }
    [newHashtags removeObjectIdenticalTo:@""];
    selfie[@"hashtags"] = newHashtags;
}

- (void) changeState:(NewControlStates)state complaint:(SelfieComplaint)complaint selife:(PFObject *)selfie userId:(NSString*)userId{
    switch (state) {
        case StateGood:
            selfie[@"flags"] = @0;
            selfie[@"complaint"] = @[];
            break;
        case StateModerate:
            NSLog(@"state Moderate");
            selfie[@"flags"] = @6;
            [selfie addUniqueObject:[self getComplaintString:complaint] forKey:@"complaint"];
            [selfie addUniqueObject:[self getComplaintString:ComplaintAuto] forKey:@"complaint"];
            break;
        case StateSevere:
            NSLog(@"state Severe");
            selfie[@"flags"] = @6;
            [selfie addUniqueObject:[self getComplaintString:complaint] forKey:@"complaint"];
            [selfie addUniqueObject:[self getComplaintString:ComplaintAdmin] forKey:@"complaint"];
            break;
        case StateExtreme:
            selfie[@"flags"] = @6;
            [selfie addUniqueObject:[self getComplaintString:complaint] forKey:@"complaint"];
            [selfie addUniqueObject:[self getComplaintString:ComplaintAdmin] forKey:@"complaint"];
            [PFCloud callFunction:@"banUser" withParameters:@{@"userId": userId}];
            break;
        case StateAuthorities:
            selfie[@"flags"] = @6;
            [selfie addUniqueObject:[self getComplaintString:complaint] forKey:@"complaint"];
            [selfie addUniqueObject:[self getComplaintString:ComplaintAdmin] forKey:@"complaint"];
            [PFCloud callFunction:@"banUser" withParameters:@{@"userId": userId}];
            break;
        default:
            break;
    }
}

- (void) createEntryForBadHashtag:(NSArray*)badHashtags{
    
    for (NSString *badhashtag in badHashtags) {
        PFObject *badHashtagObject = [PFObject objectWithClassName:@"BadHashtag"];
        badHashtagObject[@"hashtag"] = badhashtag;
        [badHashtagObject saveEventually];
    }
}

/**
- (void) sendMessage:(SelfieMessage)messsage user:(PFUser *)user{
    
    PFQuery *pushQuery = [PFInstallation query];
    NSArray *users = [NSArray arrayWithObject:user.objectId];
    [pushQuery whereKey:@"user" containedIn:users];
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    NSString *emessage = @"";
    switch (messsage) {
        case stop_inappropriate:
            emessage = @"It's time to grow up, #life team";
            break;// you are now going to receive 50 ** picks, spam bi**tch
        case stop_spamming:
            emessage = @"special processed american meat, #life team";
            break;
        default:
            break;
    }
    [push setMessage:emessage];
    [push sendPushInBackground];
}
**/

/**
- (void) contentFlag:(SelfieComplaint)acomplaint flag:(int)flag{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            selfie[@"flags"] = @(flag);
            [selfie addUniqueObject:[self getComplaintString:acomplaint] forKey:@"complaint"];
            [selfie saveInBackground];
            self.flags = [NSNumber numberWithInt:flag];
            if (![self.complaint containsObject:[self getComplaintString:acomplaint]])
                [self.complaint addObject:[self getComplaintString:acomplaint]];
        }
    }];
}**/

/** HELPER METHODS **/

- (NSString *) getComplaintString:(SelfieComplaint)acomplaint{
    switch (acomplaint) {
        case ComplaintAuto:
            return @"Auto";
            break;
        case ComplaintDelete:
            return @"Delete";
            break;
        case ComplaintAdmin:
            return @"Admin";
            break;
        case ComplaintPornography:
            return @"Pornography";
            break;
        case ComplaintViolence:
            return @"Violence";
            break;
        case ComplaintHarm:
            return @"Harm";
            break;
        case ComplaintAttack:
            return @"Attack";
            break;
        case ComplaintHateful:
            return @"Hateful";
            break;
        case ComplaintOther:
            return @"Other";
            break;
        case ComplaintReport:
            return @"Report";
            break;
        case ComplaintSpam:
            return @"Spam";
            break;
        default:
            return @"";
            break;
    }
}

@end
