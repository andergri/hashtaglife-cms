//
//  InfoViewController.m
//  cms
//
//  Created by Griffin Anderson on 7/24/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "InfoViewController.h"
#import "UpdateObject.h"
#import "ControlObject.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <QuartzCore/QuartzCore.h>

@interface InfoViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusMain;
@property (weak, nonatomic) IBOutlet UILabel *statusSecondary;
@property (weak, nonatomic) IBOutlet UIButton *flag;
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
@property (weak, nonatomic) IBOutlet UILabel *clikes;
@property (weak, nonatomic) IBOutlet UILabel *cvisits;
- (IBAction)mlikes:(id)sender;
- (IBAction)mViews:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
@property (weak, nonatomic) IBOutlet UIButton *buttonC;
- (IBAction)buttonA:(id)sender;
- (IBAction)buttonB:(id)sender;
- (IBAction)buttonC:(id)sender;
- (IBAction)pageControl:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@property (weak, nonatomic) IBOutlet UIButton *submit;
- (IBAction)submit:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property UIActivityIndicatorView *mySpinner;
- (IBAction)exitModel:(id)sender;
- (IBAction)showImage:(id)sender;
@property UpdateObject *updateSelfie;
@property ControlObject *controlSelife;
@property (weak, nonatomic) IBOutlet UIView *movieOverlayView;

@end

@implementation InfoViewController

@synthesize mySpinner;
@synthesize currentSelfie;
@synthesize updateSelfie;
@synthesize controlSelife;
@synthesize collectionViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.center = CGPointMake([[UIScreen mainScreen] bounds].size.width / 2.0, [[UIScreen mainScreen] bounds].size.height / 2.0);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMoviePlayer)];
    singleTap.numberOfTapsRequired = 1;
    [self.videoImageView setUserInteractionEnabled:YES];
    [self.videoImageView addGestureRecognizer:singleTap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**************/
/**  SET SELFIE  **/
/**************/

- (void) setSelfie:(SelfieObject*)selfie{

    currentSelfie = selfie;
    updateSelfie = [[UpdateObject alloc] initWithSelfie:currentSelfie];
    controlSelife = [[ControlObject alloc] init];
    
    [self.view.layer setCornerRadius:5.0f];
    [self.submit.layer setCornerRadius:5.0];
    
    self.statusMain.text = selfie.getStatusLabel;
    self.statusMain.textColor = selfie.getStatusColor;
    self.statusSecondary.text = [[selfie.complaint valueForKey:@"description"] componentsJoinedByString:@" "];
    [self.flag setTitle:[NSString stringWithFormat:@"%@", selfie.flags] forState:UIControlStateNormal];
    self.created.text = selfie.getPostedTime;
    [selfie getUser:^(NSString *name) {
        [self.user setTitle:name forState:UIControlStateNormal];
    }];
    [selfie getLocation:^(NSString *name) {
        [self.location setTitle:name forState:UIControlStateNormal];
    }];
    [self.userId setTitle:selfie.from forState:UIControlStateNormal];
    [self.locationId setTitle:selfie.location forState:UIControlStateNormal];
    self.clikes.text = [NSString stringWithFormat:@"%@", selfie.likes];
    self.cvisits.text = [NSString stringWithFormat:@"%@", selfie.visits];
    if (selfie.video != nil) {
        self.videoImageView.hidden = NO;
    }else{
        self.videoImageView.hidden = YES;
    }
    [self.hashtag1 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:0]] forState:UIControlStateNormal];
    [self.hashtag2 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:1]] forState:UIControlStateNormal];
    [self.hashtag3 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:2]] forState:UIControlStateNormal];
    [self.hashtag4 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:3]] forState:UIControlStateNormal];
    [self.hashtag5 setTitle:[NSString stringWithFormat:@"# %@",[selfie.hashtags objectAtIndex:4]] forState:UIControlStateNormal];
    
    mySpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    mySpinner.center = CGPointMake(105, 25);
    mySpinner.hidesWhenStopped = YES;
    [self.submit addSubview:mySpinner];
    
    [self.imageView setImageWithURL:[NSURL URLWithString:selfie.image]];
    self.imageView.hidden = YES;

    self.submit.selected = NO;
    self.submit.enabled = YES;

    UIBarButtonItem *imageButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"img"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                    action:@selector(showImage:)];
    self.navigationItem.rightBarButtonItem = imageButton;
    
    self.pageControl.currentPage = 0;
    [self pageControl:nil];
}

// USER Interface

- (void) createButtonColor:(UIButton*)button title:(NSString*)title color:(UIColor*)color
                     state:(NewControlStates)state{
    [button.layer setCornerRadius:(button.frame.size.width/2.0)];
    button.backgroundColor = color;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.textColor = [UIColor yellowColor];
    button.tag = state;
    if (state == updateSelfie.state) {
        button.selected = YES;
    }else{
        button.selected = NO;
    }
}

/**************/
/**  ACTIONS  **/
/**************/

- (IBAction)likes:(id)sender {
    updateSelfie.likes++;
    self.clikes.text = [NSString stringWithFormat:@"%d", [self.currentSelfie.likes intValue] + updateSelfie.likes];
}
- (IBAction)mlikes:(id)sender {
    updateSelfie.likes--;
    self.clikes.text = [NSString stringWithFormat:@"%d", [self.currentSelfie.likes intValue] + updateSelfie.likes];
}
- (IBAction)views:(id)sender {
    updateSelfie.visits++;
    self.cvisits.text = [NSString stringWithFormat:@"%d", [self.currentSelfie.visits intValue] + updateSelfie.visits];
}
- (IBAction)mViews:(id)sender {
    updateSelfie.visits--;
    self.cvisits.text = [NSString stringWithFormat:@"%d", [self.currentSelfie.visits intValue] + updateSelfie.visits];
}
- (IBAction)hashtag1:(id)sender {
    [self hashtag:sender location:0];
}
- (IBAction)hashtag2:(id)sender {
    [self hashtag:sender location:1];
}
- (IBAction)hashtag3:(id)sender {
    [self hashtag:sender location:2];
}
- (IBAction)hashtag4:(id)sender {
    [self hashtag:sender location:3];
}
- (IBAction)hashtag5:(id)sender {
    [self hashtag:sender location:4];
}

- (IBAction)buttonA:(id)sender {
    updateSelfie.state = (NewControlStates)((UIButton*)sender).tag;
    [self pageControl:nil];
    if (self.pageControl.currentPage != 0) {
        [self showAlertViewForComplaints];
    }else{
        updateSelfie.complaint = ComplaintNotSet;
    }
}
- (IBAction)buttonB:(id)sender {
    updateSelfie.state = (NewControlStates)((UIButton*)sender).tag;
    [self pageControl:nil];
    [self showAlertViewForComplaints];
}
- (IBAction)buttonC:(id)sender {
    updateSelfie.state = (NewControlStates)((UIButton*)sender).tag;
    [self pageControl:nil];
    [self showAlertViewForComplaints];
}

/** MORE **/

- (void) hashtag:(id)sender location:(int)location{
    if(!((UIButton *)sender).selected){
        [updateSelfie.removedHashtags addObject:[currentSelfie.hashtags objectAtIndex:location]];
        ((UIButton *)sender).selected = YES;
    }else{
        if ([updateSelfie.removedHashtags containsObject:[currentSelfie.hashtags objectAtIndex:location]]) {
            [updateSelfie.removedHashtags removeObject:[currentSelfie.hashtags objectAtIndex:location]];
            ((UIButton *)sender).selected = NO;
        }
    }
}

- (IBAction)pageControl:(id)sender {
    switch (self.pageControl.currentPage) {
        case 0:
            [self createButtonColor:self.buttonA title:@"Good" color:[UIColor colorWithRed:46.0/255.0 green:204.0/255.0 blue:113.0/255.0 alpha:1] state:StateGood];
            [self createButtonColor:self.buttonB title:@"Poster" color:[UIColor colorWithRed:244.0/255.0 green:208.0/255.0 blue:63.0/255.0 alpha:1] state:StateModerate];
            [self createButtonColor:self.buttonC title:@"Block" color:[UIColor colorWithRed:214.0/255.0 green:69.0/255.0 blue:65.0/255.0 alpha:1] state:StateSevere];
            self.buttonC.hidden = NO;
            break;
        case 1:
            [self createButtonColor:self.buttonA title:@"Ban" color:[UIColor colorWithRed:192.0/255.0 green:57.0/255.0 blue:43.0/255.0 alpha:1]state:StateExtreme];
            [self createButtonColor:self.buttonB title:@"Emergency" color:[UIColor colorWithRed:207.0/255.0 green:0.0/255.0 blue:15.0/255.0 alpha:1] state:StateAuthorities];
            self.buttonC.hidden = YES;
            break;
        default:
            break;
    }
}

/**  NOT IN USE  **/

// [self performSelector:@selector(setSelfie:) withObject:currentSelfie afterDelay:2];
- (IBAction)user:(id)sender {
    NSLog(@"tap user");
}
- (IBAction)location:(id)sender {
    NSLog(@"tap location");
}

/********************/
/**  MOVIE PLAYER  **/
/*******************/

- (void) playMoviePlayer{

    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionViewController playMovie:currentSelfie.video];
    }];
}


/********************/
/**  ACTION SHEET **/
/*******************/

- (void)showAlertViewForComplaints{
    
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
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showInView:self.view];
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
    
    updateSelfie.complaint = complaint;
}


/********************/
/**  MORE  **/
/*******************/


- (IBAction)submit:(id)sender {
    
   // if (updateSelfie.canPost) {
        
        NSLog(@"___________");
        NSLog(@"likes %d", updateSelfie.likes);
        NSLog(@"visits %d", updateSelfie.visits);
        NSLog(@"hash %@", updateSelfie.removedHashtags);
        NSLog(@"state %d", updateSelfie.state);
        NSLog(@"complaint %d", updateSelfie.complaint);
        
        [mySpinner startAnimating];
        
        [controlSelife updateObject:updateSelfie block:^(ControlProgress progress, PFObject *selfie, NSError *error) {
            [mySpinner stopAnimating];
            switch (progress) {
                case ProgressPassed:
                    NSLog(@"# Progress: Passed #");
                    [self setSelfie:[[SelfieObject alloc] initPF:selfie]];
                    self.submit.selected = YES;
                    break;
                    
                case ProgressFailedToInitControl:
                    NSLog(@"# Progress: FailedToInitControl #");
                    self.submit.selected = NO;
                    self.submit.enabled = NO;
                    break;
                    
                case ProgressFailedToLoadObject:
                    NSLog(@"# Progress: FailedToLoadObject #");
                    self.submit.selected = NO;
                    self.submit.enabled = NO;
                    break;
                    
                case ProgressFailedToSave:
                    NSLog(@"# Progress: FailedToSave #");
                    self.submit.selected = NO;
                    self.submit.enabled = NO;
                    break;
                    
                default:
                    break;
            }
        }];
  //  }
}

- (IBAction) showImage:(id)sender{
    self.imageView.hidden = !self.imageView.hidden;
}
- (IBAction)exitModel:(id)sender {
    [collectionViewController refreshAllData];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
@end
