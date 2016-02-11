//
//  CollectionViewController.h
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelfieObject.h"
#import <MediaPlayer/MediaPlayer.h>

@interface CollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSMutableArray *selfies;
@property SelfieStatus filter;
- (BOOL) canReloadData;
- (void) refreshAllData;
- (void) playMovie:(NSString*)url;
@end
