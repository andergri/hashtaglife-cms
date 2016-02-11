//
//  CollectionViewController.m
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "InfoViewController.h"

@interface CollectionViewController ()

@property InfoViewController *infoViewController;
@property NSMutableArray *filterSelfies;

@end

@implementation CollectionViewController

@synthesize infoViewController;
@synthesize selfies;
@synthesize filter;
@synthesize filterSelfies;

- (void)loadView{
    [super loadView];
    self.collectionView.frame = [[UIScreen mainScreen] bounds];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    infoViewController = [[InfoViewController alloc] init];
    //infoViewController.view.frame = CGRectMake(0, 50, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    //[self.view addSubview:infoViewController.view];
    //[self addChildViewController:infoViewController];
    //[infoViewController didMoveToParentViewController:self];
    //[infoViewController.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    //infoViewController.view.hidden = YES;
    filter = StatusAll;
    
    selfies = [[NSMutableArray alloc] init];
    filterSelfies = [[NSMutableArray alloc] init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"CollectionViewCellIdentifier"];
    self.view.frame = [[UIScreen mainScreen] bounds];
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void) refreshAllData{
    NSLog(@"refresh all data");
    if (infoViewController.currentSelfie) {
        NSLog(@"has old selfie");
        for (int i = 0; i< selfies.count; i++) {
            SelfieObject *aobj = [selfies objectAtIndex:i];
            if ([aobj class] == [SelfieObject class]) {
                if ([infoViewController.currentSelfie.objectId isEqualToString:aobj.objectId]) {
                    [selfies replaceObjectAtIndex:i withObject:infoViewController.currentSelfie];
                }
            }
        }
        [self.collectionView reloadData];
        infoViewController.currentSelfie = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    // filter
    [filterSelfies removeAllObjects];
    for (int i = 0; i< selfies.count; i++) {
        SelfieObject *aobj = [selfies objectAtIndex:i];
        if ([aobj class] == [SelfieObject class]) {
            if (filter == aobj.status || filter == StatusAll) {
               [filterSelfies addObject:aobj];
            }
        }else{
            [filterSelfies addObject:aobj];
        }
    }
    
    return filterSelfies.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellIdentifier" forIndexPath:indexPath];
    if ([[filterSelfies objectAtIndex:indexPath.item] class] != [SelfieObject class]) {
        cell.imageView.image = nil;
        cell.hashtag1.text = @"";
        cell.hashtag2.text = @"";
        cell.hashtag3.text = @"";
        cell.hashtag4.text = @"";
        cell.hashtag5.text = @"";
        cell.signal.backgroundColor = [UIColor clearColor];
        cell.shadow.hidden = YES;
        cell.videoIcon.hidden = YES;
        return cell;
    }
    SelfieObject *aselfie = [filterSelfies objectAtIndex:indexPath.item];
    cell.imageView.image = nil;
    //[cell.imageView setImageWithURL:<#(NSURL *)#>];
    [cell.imageView setImageWithURL:[NSURL URLWithString:aselfie.image]];
    cell.hashtag1.attributedText = [aselfie getAtrributedHashtag:[aselfie.hashtags objectAtIndex:0]];
    cell.hashtag2.attributedText = [aselfie getAtrributedHashtag:[aselfie.hashtags objectAtIndex:1]];
    cell.hashtag3.attributedText = [aselfie getAtrributedHashtag:[aselfie.hashtags objectAtIndex:2]];
    cell.hashtag4.attributedText = [aselfie getAtrributedHashtag:[aselfie.hashtags objectAtIndex:3]];
    cell.hashtag5.attributedText = [aselfie getAtrributedHashtag:[aselfie.hashtags objectAtIndex:4]];
    cell.signal.backgroundColor = [aselfie getStatusColor];
    [cell.signal.layer setCornerRadius:5.0f];
    cell.shadow.hidden = NO;
    [cell.videoIcon.layer setCornerRadius:8.0f];
    if (aselfie.video != nil) {
        cell.videoIcon.hidden = NO;
    }else{
        cell.videoIcon.hidden = YES;
    }
    
    return cell;
}

// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     if ([[filterSelfies objectAtIndex:indexPath.item] class] != [SelfieObject class]) {
         return;
     }
    infoViewController = [[InfoViewController alloc] init];
    infoViewController.modalPresentationStyle=UIModalPresentationFormSheet;
    infoViewController.preferredContentSize = CGSizeMake(320, 480);
    infoViewController.collectionViewController = self;
    [infoViewController setSelfie:[filterSelfies objectAtIndex:indexPath.item]];
    [self presentViewController:infoViewController animated:YES completion:^{
        infoViewController.view.superview.center = self.view.center;
     }];
}

- (BOOL) shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (BOOL) canReloadData{
    return YES;
}

// MOVIE CONTROLLER
- (void) playMovie:(NSString*)url{

    NSURL *aurl = [NSURL URLWithString:url];
    MPMoviePlayerViewController *movieController = [[MPMoviePlayerViewController alloc] initWithContentURL:aurl];
    movieController.view.frame = self.view.bounds;
    movieController.moviePlayer.controlStyle = MPMovieControlStyleNone;
    movieController.moviePlayer.shouldAutoplay = YES;
    movieController.moviePlayer.repeatMode = MPMovieRepeatModeOne;
    movieController.moviePlayer.controlStyle=MPMovieControlStyleFullscreen;
    movieController.modalPresentationStyle=UIModalPresentationFormSheet;
    movieController.preferredContentSize = CGSizeMake(320, 480);
    [self presentViewController:movieController animated:YES completion:^{
        [movieController.moviePlayer prepareToPlay];
    }];
}

/**
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(106, 150);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}**/

@end
