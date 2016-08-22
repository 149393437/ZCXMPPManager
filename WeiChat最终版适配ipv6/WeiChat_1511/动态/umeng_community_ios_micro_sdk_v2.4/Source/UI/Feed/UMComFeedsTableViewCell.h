//
//  UMComFeedsTableViewCell.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/27/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMComFeedStyle,UMComFeed,UMComMutiStyleTextView, UMComImageView,UMComGridView;

@protocol UMComClickActionDelegate;

@interface UMComFeedsTableViewCell : UITableViewCell

@property (nonatomic, strong) UMComFeed *feed;

@property (weak, nonatomic) IBOutlet UIView *feedBgView;

@property (weak, nonatomic) IBOutlet UIImageView *topImage;
@property (weak, nonatomic) IBOutlet UIImageView *eletImage;

@property (weak, nonatomic) IBOutlet UIImageView *publicImage;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong)  UMComImageView *portrait;

@property (nonatomic, weak) IBOutlet UMComMutiStyleTextView *feedStyleView;

@property (nonatomic, weak) IBOutlet UIImageView *originFeedBackgroundView;

@property (nonatomic, weak) IBOutlet UMComMutiStyleTextView *originFeedStyleView;

@property (nonatomic, weak) IBOutlet UILabel *locationLabel;

@property (nonatomic, weak) IBOutlet UIView *locationBgView;

@property (nonatomic, weak) IBOutlet UILabel *locationDistance;

@property (weak, nonatomic) IBOutlet UMComGridView *imageGridView;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

//
@property (weak, nonatomic) IBOutlet UIView *bottomMenuBgView;

@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (nonatomic, assign) CGFloat cellBgViewTopEdge;

@property (nonatomic, weak) id<UMComClickActionDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)reloadFeedWithfeedStyle:(UMComFeedStyle *)feedStyle tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

- (IBAction)onClickOnMoreButton:(UIButton *)sender;

- (IBAction)didClickOnForwardButton:(id)sender;

- (IBAction)didClickOnLikeButton:(id)sender;

- (IBAction)didClickOnCommentButton:(id)sender;

@end
