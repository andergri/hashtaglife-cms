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
    ComplaintNotSet,
} SelfieComplaint;

typedef enum {
    StatusRed,
    StatusYellow,
    StatusGreen,
    StatusPurple,
    StatusAll
} SelfieStatus;

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
@property SelfieStatus status;

- (id)init:(id)responseObject;
- (id)initPF:(PFObject*)responseObject;

typedef void (^NameCompletionBlock)(NSString *name);

// Methods
- (NSString *) getStatusLabel;
- (UIColor *) getStatusColor;
- (NSString*) getPostedTime;

- (void) getUser:(NameCompletionBlock)block;
- (void) getLocation:(NameCompletionBlock)block;
- (BOOL) isHashtagFlagged:(NSString *)hashtag;
- (NSAttributedString *) getAtrributedHashtag:(NSString *)hashtag;


@end
