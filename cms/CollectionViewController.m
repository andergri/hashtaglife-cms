//
//  CollectionViewController.m
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionViewCell.h"
#import "SelfieObject.h"
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "InfoViewController.h"

@interface CollectionViewController ()

@property InfoViewController *infoViewController;

@end

@implementation CollectionViewController

@synthesize infoViewController;
@synthesize selfies;

- (void)loadView{
    [super loadView];
    self.collectionView.frame = [[UIScreen mainScreen] bounds];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    infoViewController = [[InfoViewController alloc] init];
    infoViewController.view.frame = CGRectMake((self.view.frame.size.width - infoViewController.view.frame.size.width) / 2.0, (self.view.frame.size.height - infoViewController.view.frame.size.height) / 2.0, infoViewController.view.frame.size.width, infoViewController.view.frame.size.height);
    [self.view addSubview:infoViewController.view];
    [self addChildViewController:infoViewController];
    [infoViewController didMoveToParentViewController:self];
    infoViewController.view.hidden = YES;
    
    
    selfies = [[NSMutableArray alloc] init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:[NSBundle mainBundle]]
        forCellWithReuseIdentifier:@"CollectionViewCell"];
    self.view.frame = [[UIScreen mainScreen] bounds];
    //self.collectionView.frame = [[UIScreen mainScreen] bounds];
    [self.collectionView.collectionViewLayout invalidateLayout];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"frame %f %f", self.collectionView.frame.size.width, self.collectionView.frame.size.height);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section{
    return selfies.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCell" forIndexPath:indexPath];
    if ([[selfies objectAtIndex:indexPath.item] class] != [SelfieObject class]) {
        cell.imageView.image = nil;
        cell.hashtag1.text = @"";
        cell.hashtag2.text = @"";
        cell.hashtag3.text = @"";
        cell.hashtag4.text = @"";
        cell.hashtag5.text = @"";
        cell.signal.backgroundColor = [UIColor clearColor];
        cell.shadow.hidden = YES;
        return cell;
    }
    SelfieObject *aselfie = [selfies objectAtIndex:indexPath.item];
    cell.hashtag1.text = [aselfie.hashtags objectAtIndex:0];
    cell.hashtag2.text = [aselfie.hashtags objectAtIndex:1];
    cell.hashtag3.text = [aselfie.hashtags objectAtIndex:2];
    cell.hashtag4.text = [aselfie.hashtags objectAtIndex:3];
    cell.hashtag5.text = [aselfie.hashtags objectAtIndex:4];
    cell.signal.backgroundColor = [aselfie getStatusColor];
    [cell.signal.layer setCornerRadius:5.0f];
    cell.shadow.hidden = NO;
    [cell.imageView setImageWithURL:[NSURL URLWithString:aselfie.image]];
    
    return cell;
}

// I implemented didSelectItemAtIndexPath:, but you could use willSelectItemAtIndexPath: depending on what you intend to do. See the docs of these two methods for the differences.
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
     if ([[selfies objectAtIndex:indexPath.item] class] != [SelfieObject class]) {
         return;
     }
    [infoViewController setSelfie:[selfies objectAtIndex:indexPath.item]];
    infoViewController.view.hidden = NO;
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
