//
//  ViewController.m
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <PubNub/PubNub.h>
#import "SelfieObject.h"
#import "CollectionViewController.h"

@interface ViewController ()

@property CollectionViewController * childCollectionViewController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *systemStatus;
@property (weak, nonatomic) IBOutlet UIView *containerView;
- (IBAction)colorSwitch:(id)sender;
@property (weak, nonatomic) IBOutlet UIPageControl *colorControl;
- (IBAction)refreshStatus:(id)sender;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@end

@implementation ViewController

@synthesize childCollectionViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.containerView.frame = [[UIScreen mainScreen] bounds];
    //self.colorControl.pageIndicatorTintColor = [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.5];
    
    NSString *notificationName = @"CMSPub";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotification:)
     name:notificationName
     object:nil];
    
    //self.navigationController.navigationBar.topItem.title = @"ALL";
    
    //self.pickerView.delegate = self;
    //self.pickerView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString * segueName = segue.identifier;
    if ([segueName isEqualToString: @"CollectionViewControllerSegue"]) {
        childCollectionViewController = (CollectionViewController *) [segue destinationViewController];
    }
}

- (void)useNotification:(NSNotification *)notification{
    
    NSString *keyStatus = @"status";
    NSString *keyResult = @"result";
    NSDictionary *dictionary = [notification userInfo];
    
    // Message Received
    PNMessageResult *result = [dictionary valueForKey:keyResult];
    if (result != nil) {
        //NSLog(@"Received message: %@ on channel %@ at %@", result.data.message, result.data.subscribedChannel, result.data.timetoken);
        SelfieObject *selfie = [[SelfieObject alloc] init:result.data.message];
        
        BOOL foundMatch = NO;
        for(int e = 0; e < (int)childCollectionViewController.selfies.count; e++) {
            if ([[childCollectionViewController.selfies objectAtIndex:e] class] == [SelfieObject class]){
                SelfieObject *fselfie = [childCollectionViewController.selfies objectAtIndex:e];
                if ([fselfie.objectId isEqualToString:selfie.objectId]) {
                    [childCollectionViewController.selfies replaceObjectAtIndex:[childCollectionViewController.selfies indexOfObject:fselfie] withObject:selfie];
                    foundMatch = YES;
                    break;
                }
            }
        }
        if (!foundMatch)
            [childCollectionViewController.selfies insertObject:selfie atIndex:0];
        
        [self addMissingObjects];
        if([childCollectionViewController canReloadData]){
            [childCollectionViewController.collectionView reloadData];
        }
    }
    
    // Status has changed
    PNSubscribeStatus *status = [dictionary valueForKey:keyStatus];
    if (status != nil && status.category == PNUnexpectedDisconnectCategory) {
        self.systemStatus.title = @"offline";
        self.systemStatus.tintColor = [UIColor redColor];
    } else if (status.category == PNConnectedCategory) {
        [childCollectionViewController.selfies removeAllObjects];
        [self getRecentSelfies];
        self.systemStatus.title = @"online";
        self.systemStatus.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }else if (status.category == PNReconnectedCategory) {
        [childCollectionViewController.selfies removeAllObjects];
        [self getRecentSelfies];
        self.systemStatus.title = @"online";
        self.systemStatus.tintColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    }else if (status.category == PNDecryptionErrorCategory) {
        self.systemStatus.title = @"error";
        self.systemStatus.tintColor = [UIColor redColor];
    }
}

- (void) addMissingObjects{
    [childCollectionViewController.selfies removeObjectIdenticalTo:@"temp"];
    int columns = floor(self.view.frame.size.width / 106.00);
    int remainder = childCollectionViewController.selfies.count % columns;
    int temp = columns - remainder;
    for (int i = 0; i < temp; i++) {
        [childCollectionViewController.selfies insertObject:@"temp" atIndex:0];
    }
}

- (void) getRecentSelfies{
    PFQuery *query = [PFQuery queryWithClassName:@"Selfie"];
    query.limit = 75;
    [query findObjectsInBackgroundWithBlock:^(NSArray *selfies, NSError *error) {
        if (!error) {
            for (int i = (int)(selfies.count - 1); i >= 0; i--) {
                PFObject* selfie = [selfies objectAtIndex:i];
                SelfieObject *eselfie = [[SelfieObject alloc] initPF:selfie];
                [childCollectionViewController.selfies insertObject:eselfie atIndex:0];
            }
            [self addMissingObjects];
            childCollectionViewController.filter = StatusAll;
            [childCollectionViewController.collectionView reloadData];
        }
    }];
}


- (IBAction)colorSwitch:(id)sender {
    NSLog(@"hit color switch");
    if([childCollectionViewController canReloadData]){
        if(self.colorControl.currentPage == 0){
            self.colorControl.currentPageIndicatorTintColor = [UIColor blueColor];
            childCollectionViewController.filter = StatusAll;
        }
        if(self.colorControl.currentPage == 1){
            self.colorControl.currentPageIndicatorTintColor =  [UIColor greenColor];
            childCollectionViewController.filter = StatusGreen;
        }
        if(self.colorControl.currentPage == 2){
            self.colorControl.currentPageIndicatorTintColor = [UIColor yellowColor];
            childCollectionViewController.filter = StatusYellow;
        }
        if(self.colorControl.currentPage == 3){
            self.colorControl.currentPageIndicatorTintColor =  [UIColor redColor];
            childCollectionViewController.filter = StatusRed;
        }
        if(self.colorControl.currentPage == 4){
            self.colorControl.currentPageIndicatorTintColor = [UIColor purpleColor];
            childCollectionViewController.filter = StatusPurple;
        }
        [childCollectionViewController.collectionView reloadData];
    }
}
- (IBAction)refreshStatus:(id)sender {
    [childCollectionViewController.selfies removeAllObjects];
    [self getRecentSelfies];
    self.colorControl.currentPage = 0;
    [self colorSwitch:sender];
}


/********************/
/**  PICKER View  **/
/*******************/

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-  (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return 2;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return @"as";
}

@end
