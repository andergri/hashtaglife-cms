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

@end

@implementation ViewController

@synthesize childCollectionViewController;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.frame = [[UIScreen mainScreen] bounds];
    self.containerView.frame = [[UIScreen mainScreen] bounds];
    NSString *notificationName = @"CMSPub";
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotification:)
     name:notificationName
     object:nil];
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
        [childCollectionViewController.selfies insertObject:selfie atIndex:0];
        [self addMissingObjects];
        [childCollectionViewController.collectionView reloadData];
    }
    
    // Status has changed
    PNSubscribeStatus *status = [dictionary valueForKey:keyStatus];
    if (status != nil && status.category == PNUnexpectedDisconnectCategory) {
        self.systemStatus.title = @"offline";
        self.systemStatus.tintColor = [UIColor redColor];
    } else if (status.category == PNConnectedCategory) {
        self.systemStatus.title = @"online";
        self.systemStatus.tintColor = [UIColor blueColor];
    }else if (status.category == PNReconnectedCategory) {
        self.systemStatus.title = @"online";
        self.systemStatus.tintColor = [UIColor blueColor];
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


@end
