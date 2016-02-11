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
@synthesize status;

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
    [self getStatusColor];
    return self;
}

- (id)initPF:(PFObject*)responseObject{
    if ((self = [super init])) {
        
        @try {
            self.objectId = responseObject.objectId;
            self.createdAt = responseObject.createdAt;
            self.updatedAt = responseObject.updatedAt;
            self.complaint = responseObject[@"complaint"];
            self.flags = [NSNumber numberWithInt:[responseObject[@"flags"] intValue]];
            self.image = ((PFFile*)responseObject[@"image"]).url;
            self.from = ((PFUser*)responseObject[@"from"]).objectId;
            self.likes = [NSNumber numberWithInt:[responseObject[@"likes"] intValue]];
            self.visits = [NSNumber numberWithInt:[responseObject[@"visits"] intValue]];
            self.hashtags = responseObject[@"hashtags"];
            self.location = ((PFObject*)responseObject[@"location"]).objectId;
            self.video = ((PFFile*)responseObject[@"video"]).url;
            self.complainer = responseObject[@"complainer"];
        }
        @catch (NSException *exception) {
            NSLog(@"%@", exception);
        }
    }
    [self addMissingHashtags];
    [self getStatusColor];
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
    
    if ([complaint containsObject:@"Admin"]){
        status = StatusRed;
        return [UIColor redColor];
    }else if([complaint containsObject:@"Delete"]){
        status = StatusPurple;
        return [UIColor purpleColor];
    }else if(([self.flags intValue] <= 4) &&
             ([self.likes intValue] > -4)){
        status = StatusGreen;
        return [UIColor greenColor];
     }else if ([self.createdAt compare:newDate] == NSOrderedAscending){
        status = StatusRed;
        return [UIColor orangeColor];
    }else{
        status = StatusYellow;
        return [UIColor colorWithRed:242.0/255.0 green:218.0/255.0 blue:0/255.0 alpha:1];
    }
}

- (NSString*) getPostedTime{
    
    NSCalendar *c = [NSCalendar currentCalendar];
    NSDate *d1 = [NSDate date];
    NSDate *d2 = self.createdAt;
    NSDateComponents *components = [c components:(NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitHour) fromDate:d2 toDate:d1 options:0];
    if (components.hour > 0) {
        return [NSString stringWithFormat:@"%ldh", (long)components.hour];
    }
    if (components.minute > 0) {
        return [NSString stringWithFormat:@"%ldm", (long)components.minute];
    }
    if (components.second > 0){
        return [NSString stringWithFormat:@"sec"];
    }
    return @"now";
}

- (void) getUser:(NameCompletionBlock)block{
    
    if (self.user == nil) {
        PFQuery *query = [PFUser query];
        [query getObjectInBackgroundWithId:self.from
                                     block:^(PFObject *ouser, NSError *error) {
                                         if (error == nil) {
                                             PFUser *auser = (PFUser *)ouser;
                                             self.userObject = auser;
                                             self.user = auser.username;
                                             block(self.user);
                                         }else{
                                             block(nil);
                                         }
                                     }];
    }else{
        block(self.user);
    }
}

- (void) getLocation:(NameCompletionBlock)block{
    
    if (self.locationName.length == 0) {
        PFQuery *query = [PFQuery queryWithClassName:@"Location"];
        [query getObjectInBackgroundWithId:self.location
                                     block:^(PFObject *olocation, NSError *error) {
                                         if (error == nil) {
                                             self.locationName = olocation[@"name"];
                                             block(self.locationName);
                                         }else{
                                             block(nil);
                                         }
                                     }];
    }else{
        block(self.locationName);
    }
}

// BAD Hashtags

- (NSAttributedString *) getAtrributedHashtag:(NSString *)hashtag{

    
    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:hashtag];
    NSArray *flaggedKeyWords = [self getFlaggedHashtags:hashtag];
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,string.length)];

    if (flaggedKeyWords.count > 0) {
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:149.0/255.0 green:165.0/255.0 blue:166.0/255.0 alpha:1.0] range:NSMakeRange(0,string.length)];
        for (NSString *flaggedkey in flaggedKeyWords) {
            if ([hashtag rangeOfString:flaggedkey].location != NSNotFound){
                [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:241.0/255.0 green:196.0/255.0 blue:15.0/255.0 alpha:1.0]  range:NSMakeRange([hashtag rangeOfString:flaggedkey].location, flaggedkey.length)];
            }
        }
    }
    
    return string;
}

- (NSArray *) getFlaggedHashtags:(NSString *)hashtag{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bad_hashtags" ofType:@"plist"];
    NSArray *badHashtags = [NSArray arrayWithContentsOfFile:path];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ contains[c] SELF",hashtag];
    return [badHashtags filteredArrayUsingPredicate:predicate];
}

- (BOOL) isHashtagFlagged:(NSString *)hashtag{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"bad_hashtags" ofType:@"plist"];
    NSArray *badHashtags = [NSArray arrayWithContentsOfFile:path];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%@ contains[c] SELF",hashtag];
    NSArray *results = [badHashtags filteredArrayUsingPredicate:predicate];
    return results.count > 0;
}


@end
