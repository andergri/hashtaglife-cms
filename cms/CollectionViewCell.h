//
//  CollectionViewCell.h
//  cms
//
//  Created by Griffin Anderson on 7/23/15.
//  Copyright (c) 2015 Griffin Anderson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UILabel *hashtag1;
@property (nonatomic, strong) IBOutlet UILabel *hashtag2;
@property (nonatomic, strong) IBOutlet UILabel *hashtag3;
@property (nonatomic, strong) IBOutlet UILabel *hashtag4;
@property (nonatomic, strong) IBOutlet UILabel *hashtag5;
@property (weak, nonatomic) IBOutlet UIView *signal;
@property (weak, nonatomic) IBOutlet UIView *shadow;


@end
