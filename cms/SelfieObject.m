//
//  SelfieObject.m
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "SelfieObject.h"


@interface SelfieObject ()

@end

@implementation SelfieObject

@synthesize objectId;
@synthesize createdAt;
@synthesize updatedAt;
@synthesize complaint;
@synthesize flags;
@synthesize image;
@synthesize from;
@synthesize user;
@synthesize userObject;
@synthesize likes;
@synthesize visits;
@synthesize hashtags;
@synthesize location;
@synthesize locationName;
@synthesize video;
@synthesize complainer;

- (id)init:(id)responseObject{
    if ((self = [super init])) {
        
        @try {
            self.objectId = [responseObject objectForKey:@"objectId"];
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            self.createdAt = [dateFormat dateFromString:[responseObject objectForKey:@"createdAt"]];
            self.updatedAt = [dateFormat dateFromString:[responseObject objectForKey:@"updatedAt"]];
            self.complaint = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"complaint"]];
            self.flags = [responseObject objectForKey:@"flags"];
            self.image = [[responseObject objectForKey:@"image"] objectForKey:@"url"];
            self.from = [[responseObject objectForKey:@"from"] objectForKey:@"objectId"];
            self.likes = [responseObject objectForKey:@"likes"];
            self.visits = [responseObject objectForKey:@"visits"];
            self.hashtags = [NSMutableArray arrayWithArray:[responseObject objectForKey:@"hashtags"]];
            self.location = [[responseObject objectForKey:@"location"] objectForKey:@"objectId"];
            self.video = [[responseObject objectForKey:@"video"] objectForKey:@"url"];
            self.complainer = [responseObject objectForKey:@"complainer"];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    [self addMissingHashtags];
    [self getUser];
    [self getLocation];
    return self;
}

- (void) addMissingHashtags{
    for(int i = (int)self.hashtags.count; i < 6; i++){
        [self.hashtags addObject:@""];
    }
}

// Public metods
- (NSString *) getStatusLabel{
  
     NSDate *newDate = [[NSDate alloc] initWithTimeInterval:-3600*4
     sinceDate:[NSDate date]];
    
    if ([complaint containsObject:@"Admin"]) {
        return @"Blocked";
    }else if([complaint containsObject:@"Delete"]){
        return @"User Deleted";
    }else if(([self.flags intValue] <= 4) &&
                ([self.likes intValue] > -4)){
        return @"Everyone";
    }else if ([self.createdAt compare:newDate] == NSOrderedAscending){
         return @"Blocked";
    }else{
        return @"Poster Only";
    }
}

- (UIColor *) getStatusColor{
    
    NSDate *newDate = [[NSDate alloc] initWithTimeInterval:-3600*4
                                                 sinceDate:[NSDate date]];
    
    if ([complaint containsObject:@"Admin"]) {
        return [UIColor redColor];
    }else if([complaint containsObject:@"Delete"]){
        return [UIColor purpleColor];
    }else if(([self.flags intValue] <= 4) &&
             ([self.likes intValue] > -4)){
        return [UIColor greenColor];
     }else if ([self.createdAt compare:newDate] == NSOrderedAscending){
        return [UIColor redColor];
    }else{
        return [UIColor colorWithRed:242.0/255.0 green:218.0/255.0 blue:0/255.0 alpha:1];
    }
}

- (NSString*) getPostedTime{
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *d1 = [[NSDate date] dateByAddingTimeInterval:3600*4];
    NSDate *d2 = self.createdAt;
    NSDateComponents *components = [c components:(NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitHour) fromDate:d2 toDate:d1 options:0];
    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ldh", (long)components.hour];
    }
    if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ldm", (long)components.minute];
    }
    if (components.second > 0){
        return [NSString stringWithFormat:@"%lds", (long)components.second];
    }
    return @"null";
}

- (void) getUser{

    PFQuery *query = [PFUser query];
    [query getObjectInBackgroundWithId:self.from
        block:^(PFObject *ouser, NSError *error) {
        PFUser *auser = (PFUser *)ouser;
        self.userObject = auser;
        self.user = auser.username;
    }];
}

- (void) getLocation{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Location"];
    [query getObjectInBackgroundWithId:self.location
                                 block:^(PFObject *olocation, NSError *error) {
                                     self.locationName = olocation[@"name"];
                                 }];
}

/**
 ACTIONS *****
 **/


// Actions
- (void) incrementLike:(BOOL)increment by:(int)by{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            int newLikes;
            if (increment) {
                newLikes = by + [self.likes intValue];
            }else {
                newLikes = [self.likes intValue] - by;
            }
            NSLog(@"%d %d %d", newLikes, [self.likes intValue], by);
            selfie[@"likes"] = @(newLikes);
            [selfie saveInBackground];
            self.likes = [NSNumber numberWithInt:newLikes];
        }
    }];
}
- (void) incrementVisits:(BOOL)increment by:(int)by{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            int newVisits;
            if (increment) {
                newVisits = by + [self.visits intValue];
            }else {
                newVisits = [self.visits intValue] - by;
            }
            NSLog(@"%d %d %d", newVisits,[self.visits intValue], by);
            selfie[@"visits"] = @(newVisits);
            [selfie saveInBackground];
            self.visits = [NSNumber numberWithInt:newVisits];
        }
    }];
}
- (void) deleteHashtag:(NSString*)hashtag{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    NSLog(@"hashtag %@", hashtag);
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            if ([self.hashtags containsObject:hashtag]) {
                [self.hashtags removeObject:hashtag];
                [self.hashtags removeObjectIdenticalTo:@""];
                selfie[@"hashtags"] = self.hashtags;
                [selfie saveInBackground];
                [self addMissingHashtags];
            }
        }
    }];
}
- (void) sendMessage:(SelfieMessage)messsage{
    
    PFQuery *pushQuery = [PFInstallation query];
    NSArray *users = [NSArray arrayWithObject:self.userObject];
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

- (void) contentClear{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            selfie[@"flags"] = @0;
            selfie[@"complaint"] = @[];
            [selfie saveInBackground];
            self.flags = [NSNumber numberWithInt:0];
            [self.complaint removeAllObjects];
        }
    }];
}
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
}
- (void) contentOnlyUserCanSee:(SelfieComplaint)acomplaint{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            selfie[@"flags"] = @6;
            [selfie addUniqueObject:[self getComplaintString:ComplaintAuto] forKey:@"complaint"];
            [selfie addUniqueObject:[self getComplaintString:acomplaint] forKey:@"complaint"];
            [selfie saveInBackground];
            self.flags = [NSNumber numberWithInt:6];
            if (![self.complaint containsObject:[self getComplaintString:ComplaintAuto]])
                [self.complaint addObject:[self getComplaintString:ComplaintAuto]];
            if (![self.complaint containsObject:[self getComplaintString:acomplaint]])
                [self.complaint addObject:[self getComplaintString:acomplaint]];
        }
    }];
}
- (void) contentBlock:(SelfieComplaint)acomplaint{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    [query getObjectInBackgroundWithId:self.objectId block:^(PFObject *selfie, NSError *error) {
        if (error == nil) {
            selfie[@"flags"] = @6;
            [selfie addUniqueObject:[self getComplaintString:ComplaintAdmin] forKey:@"complaint"];
            [selfie addUniqueObject:[self getComplaintString:acomplaint] forKey:@"complaint"];
            [selfie saveInBackground];
            self.flags = [NSNumber numberWithInt:6];
            if (![self.complaint containsObject:[self getComplaintString:ComplaintAdmin]])
                [self.complaint addObject:[self getComplaintString:ComplaintAdmin]];
            if (![self.complaint containsObject:[self getComplaintString:acomplaint]])
                [self.complaint addObject:[self getComplaintString:acomplaint]];
        }
    }];
}
- (void) banPoster{
    [PFCloud callFunction:@"banUser" withParameters:@{
                                                       @"userId": self.from,
                                                       }];
    
}

// Other
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
            break;
    }
}

@end
