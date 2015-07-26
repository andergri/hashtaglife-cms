//
//  SelfieObject.h
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef enum {
    stop_spamming,
    stop_inappropriate,
} SelfieMessage;

typedef enum {
    ComplaintAuto,
    ComplaintDelete,
    ComplaintAdmin,
    ComplaintPornography,
    ComplaintViolence,
    ComplaintHarm,
    ComplaintAttack,
    ComplaintHateful,
    ComplaintOther,
    ComplaintReport,
    ComplaintSpam,
} SelfieComplaint;

/**
 @"Delete my photo": @"Delete",
 @"Spam": @"Spam",
 @"Nudity or Pornography": @"Pornography",
 @"Graphic Violence": @"Violence",
 @"Actively promotes self-harm": @"Harm",
 @"Attacks a group or individual": @"Attack",
 @"Hateful Speech or Symbols": @"Hateful",
 @"I just don't like it": @"Other"
 **/

@interface SelfieObject : NSObject

@property NSString* objectId;
@property NSDate* createdAt;
@property NSDate* updatedAt;
@property NSMutableArray* complaint;
@property NSNumber* flags;
@property NSString* image;
@property NSString* from;
@property NSString* user;
@property PFUser* userObject;
@property NSNumber* likes;
@property NSNumber* visits;
@property NSMutableArray* hashtags;
@property NSString* location;
@property NSString* locationName;
@property NSString* video;
@property NSArray* complainer;

- (id)init:(id)responseObject;

// Methods
- (NSString *) getStatusLabel;
- (UIColor *) getStatusColor;
- (NSString*) getPostedTime;

// Actions
- (void) incrementLike:(BOOL)increment by:(int)by;
- (void) incrementVisits:(BOOL)increment by:(int)by;
- (void) deleteHashtag:(NSString*)hashtag;
- (void) sendMessage:(SelfieMessage)messsage;
- (void) contentClear;
- (void) contentFlag:(SelfieComplaint)acomplaint flag:(int)flag;
- (void) contentOnlyUserCanSee:(SelfieComplaint)acomplaint;
- (void) contentBlock:(SelfieComplaint)acomplaint;
- (void) banPoster;


@end
