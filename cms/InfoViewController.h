//
//  InfoViewController.h
//  cms
//
//  Created by Griffin Anderson on 7/24/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewController.h"
#import "SelfieObject.h"

@interface InfoViewController : UIViewController <UIActionSheetDelegate, UIGestureRecognizerDelegate>

@property SelfieObject *currentSelfie;
@property CollectionViewController* collectionViewController;
- (void) setSelfie:(SelfieObject*)selfie;

@end
