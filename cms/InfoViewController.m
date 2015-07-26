//
//  InfoViewController.m
//  cms
//
//  Created by Griffin Anderson on 7/24/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "InfoViewController.h"
#import "CollectionViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface InfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *statusMain;
@property (weak, nonatomic) IBOutlet UILabel *statusSecondary;
@property (weak, nonatomic) IBOutlet UIButton *flag;
- (IBAction)flag:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *created;
@property (weak, nonatomic) IBOutlet UIButton *user;
- (IBAction)user:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *userId;
@property (weak, nonatomic) IBOutlet UIButton *location;
- (IBAction)location:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *locationId;
@property (weak, nonatomic) IBOutlet UIButton *likes;
- (IBAction)likes:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *views;
- (IBAction)views:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hashtag1;
- (IBAction)hashtag1:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hashtag2;
- (IBAction)hashtag2:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hashtag3;
- (IBAction)hashtag3:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hashtag4;
- (IBAction)hashtag4:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *hashtag5;
- (IBAction)hashtag5:(id)sender;
- (IBAction)tapContentOk:(id)sender;
- (IBAction)tapContentOnlyPoster:(id)sender;
- (IBAction)tapContentBlock:(id)sender;
- (IBAction)tapUserSpamMsg:(id)sender;
- (IBAction)tapUserWarningMsg:(id)sender;
- (IBAction)tapUserBan:(id)sender;
- (IBAction)mlikes:(id)sender;
- (IBAction)mViews:(id)sender;
- (IBAction)exit:(id)sender;

@property SelfieObject *currentSelfie;

@end

@implementation InfoViewController

@synthesize currentSelfie;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)prefersStatusBarHidden { return YES; }

- (void) setSelfie:(SelfieObject*)selfie{

    
    
    currentSelfie = selfie;
    
    [self.view.layer setCornerRadius:5.0f];
    
    self.statusMain.text = selfie.getStatusLabel;
    self.statusMain.textColor = selfie.getStatusColor;
    self.statusSecondary.text = [[selfie.complaint valueForKey:@"description"] componentsJoinedByString:@" "];
    [self.flag setTitle:[NSString stringWithFormat:@"%@", selfie.flags] forState:UIControlStateNormal];
    self.created.text = selfie.getPostedTime;
    [self.user setTitle:selfie.user forState:UIControlStateNormal];
    [self.userId setTitle:selfie.from forState:UIControlStateNormal];
    [self.location setTitle:selfie.locationName forState:UIControlStateNormal];
    [self.locationId setTitle:selfie.location forState:UIControlStateNormal];
    [self.likes setTitle:[NSString stringWithFormat:@"%@ likes  (+)", selfie.likes] forState:UIControlStateNormal];
    [self.views setTitle:[NSString stringWithFormat:@"%@ views  (+)", selfie.visits] forState:UIControlStateNormal];
    
    [self.hashtag1 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:0]] forState:UIControlStateNormal];
    [self.hashtag2 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:1]] forState:UIControlStateNormal];
    [self.hashtag3 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:2]] forState:UIControlStateNormal];
    [self.hashtag4 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:3]] forState:UIControlStateNormal];
    [self.hashtag5 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:4]] forState:UIControlStateNormal];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)flag:(id)sender {
    NSLog(@"tap flag");
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)user:(id)sender {
    NSLog(@"tap user");
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)location:(id)sender {
    NSLog(@"tap location");
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)likes:(id)sender {
    [currentSelfie incrementLike:YES by:1];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)views:(id)sender {
    [currentSelfie incrementVisits:YES by:1];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)hashtag1:(id)sender {
    [currentSelfie deleteHashtag:[currentSelfie.hashtags objectAtIndex:0]];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)hashtag2:(id)sender {
    [currentSelfie deleteHashtag:[currentSelfie.hashtags objectAtIndex:1]];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)hashtag3:(id)sender {
    [currentSelfie deleteHashtag:[currentSelfie.hashtags objectAtIndex:2]];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)hashtag4:(id)sender {
    [currentSelfie deleteHashtag:[currentSelfie.hashtags objectAtIndex:3]];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}
- (IBAction)hashtag5:(id)sender {
    [currentSelfie deleteHashtag:[currentSelfie.hashtags objectAtIndex:4]];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)tapContentOk:(id)sender {
    [currentSelfie contentClear];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)tapContentOnlyPoster:(id)sender {
    [self showAlertViewForComplaints:0];
}

- (IBAction)tapContentBlock:(id)sender {
    [self showAlertViewForComplaints:1];
}

- (IBAction)tapUserSpamMsg:(id)sender {
    [currentSelfie sendMessage:stop_spamming];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)tapUserWarningMsg:(id)sender {
    [currentSelfie sendMessage:stop_inappropriate];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)tapUserBan:(id)sender {
    [currentSelfie banPoster];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)mlikes:(id)sender {
    [currentSelfie incrementLike:NO by:1];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)mViews:(id)sender {
    [currentSelfie incrementVisits:NO by:1];
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
}

- (IBAction)exit:(id)sender {
    self.view.hidden = YES;
    [((CollectionViewController*) self.parentViewController).collectionView reloadData];
}

// Action Sheet
- (void)showAlertViewForComplaints:(int)tag{
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Complaint Reason:"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Spam"];
    [actionSheet addButtonWithTitle:@"Pornography"];
    [actionSheet addButtonWithTitle:@"Violence"];
    [actionSheet addButtonWithTitle:@"Harm"];
    [actionSheet addButtonWithTitle:@"Attack"];
    [actionSheet addButtonWithTitle:@"Hateful"];
    [actionSheet addButtonWithTitle:@"Other"];
    [actionSheet addButtonWithTitle:@"Report"];
    actionSheet.tag = tag;
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showInView:[[[[[UIApplication sharedApplication] delegate] window] rootViewController] view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    SelfieComplaint complaint = ComplaintAuto;
    
    if([title isEqual:@"Spam"]){
        complaint = ComplaintSpam;
    }else if([title isEqual:@"Pornography"]){
        complaint = ComplaintPornography;
    }else if([title isEqual:@"Violence"]){
        complaint = ComplaintViolence;
    }else if([title isEqual:@"Harm"]){
        complaint = ComplaintHarm;
    }else if([title isEqual:@"Attack"]){
        complaint = ComplaintAttack;
    }else if([title isEqual:@"Hateful"]){
        complaint = ComplaintHateful;
    }else if([title isEqual:@"Other"]){
        complaint = ComplaintOther;
    }else if([title isEqual:@"Report"]){
        complaint = ComplaintReport;
    }else if([title isEqual:@"Cancel"]){
        return;
    }
    
    if (actionSheet.tag == 0) {
        [currentSelfie contentOnlyUserCanSee:complaint];
    }else if (actionSheet.tag == 1) {
        [currentSelfie contentBlock:complaint];
    }
    [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];

}


@end
