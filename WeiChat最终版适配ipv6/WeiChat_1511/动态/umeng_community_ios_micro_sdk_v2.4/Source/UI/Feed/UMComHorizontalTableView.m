//
//  HorizontalTableView.m
//  TableViewHorizontalScroll
//
//  Created by Umeng on 14-6-16.
//  Copyright (c) 2014年 Umeng 董剑雄. All rights reserved.
//

#import "UMComHorizontalTableView.h"
#import "UMComShowToast.h"
#import "UMComImageView.h"
#import "UMComUser.h"
#import "UMComPullRequest.h"
#import "UMComUser+UMComManagedObject.h"
#import "UMComSession.h"


#define  USING_UMComHorizontalTableView_MORESHOW //用于显示用户大于4个的时候显示MORE
@interface UMComHorizontalTableView ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UILabel *titlelabel;
@property (nonatomic, strong) UILabel *nouserTip;

#ifdef USING_UMComHorizontalTableView_MORESHOW
@property (nonatomic, strong) NSArray *userListDisplay;
#endif


@end

@implementation UMComHorizontalTableView

#pragma mark - 初始化方法

- (void)initData
{
    self.delegate = self;
    self.dataSource = self;
    //tableview逆时针旋转90度。
    self.rowHeight = self.frame.size.height/4;
    self.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    self.showsHorizontalScrollIndicator = YES;
    self.scrollsToTop = NO;
    // scrollbar 不显示
    self.showsVerticalScrollIndicator = NO;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.userList = [NSArray array];
    
    self.titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 12)];
    self.titlelabel.backgroundColor = [UIColor clearColor];
    self.titlelabel.text = @"相关用户";
    self.titlelabel.textColor = [UMComTools colorWithHexString:FontColorGray];
    self.titlelabel.center = CGPointMake(90, 35);
    self.titlelabel.font = UMComFontNotoSansLightWithSafeSize(12);
    self.titlelabel.transform = CGAffineTransformMakeRotation(M_PI / 2);
    [self addSubview:self.titlelabel];
    [self creatNouserTipView];
    
}


- (void)creatNouserTipView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = UMComLocalizedString(@"no_related_user", @"没有找到相关用户");
    label.font = UMComFontNotoSansLightWithSafeSize(17);
    label.textColor = [UMComTools colorWithHexString:FontColorGray];
    label.transform = CGAffineTransformMakeRotation(M_PI / 2);
    label.center = CGPointMake(self.frame.size.height/2, self.frame.size.width/2);
    [self addSubview:label];
    label.hidden = YES;
    self.nouserTip = label;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        [self initData];
    }
    return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.userList.count == 0) {
        self.titlelabel.hidden = YES;
        return 0;
    }
    self.titlelabel.hidden = NO;
    
#ifdef USING_UMComHorizontalTableView_MORESHOW
    if (self.userList.count <= 4) {
        self.userListDisplay = self.userList;
        return self.userListDisplay.count;
    }
    else{
        self.userListDisplay = [self.userList subarrayWithRange:NSMakeRange(0,3)];
        return self.userListDisplay.count + 1;
    }
#else
    return self.userList.count + 1;
#endif
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString *cellId = @"cellId";
    HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[HorizontalTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                CGFloat imageHeight = tableView.frame.size.height/5*2;
        CGFloat titleBtHeight = imageHeight/2;
        CGFloat originY = titleBtHeight;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.userImageView.frame = CGRectMake(0, originY, imageHeight, imageHeight);
        cell.userImageView.center = CGPointMake(tableView.rowHeight/2, imageHeight/2+originY);
        cell.titleLabel.frame = CGRectMake(0, imageHeight+originY+2, tableView.rowHeight, titleBtHeight);
        cell.userImageView.clipsToBounds = YES;
        cell.userImageView.layer.cornerRadius = cell.userImageView.frame.size.width/2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelecteduser:)];
        [cell addGestureRecognizer:tap];
    }
#ifdef USING_UMComHorizontalTableView_MORESHOW
    if (indexPath.row < self.userListDisplay.count) {
        UMComUser *user = self.userListDisplay[indexPath.row];
#else
    if (indexPath.row < self.userList.count) {
        UMComUser *user = self.userList[indexPath.row];
#endif

        [cell setUser:user];
    }else{
        cell.userImageView.image = UMComImageWithImageName(@"all_more");
        cell.titleLabel.text = UMComLocalizedString(@"more", @"更多");
    }
    return cell;
}

- (void)didSelecteduser:(UITapGestureRecognizer *)tap
{
    if (self.didSelectedUser) {
        HorizontalTableViewCell *cell = (HorizontalTableViewCell *)tap.view;
        NSIndexPath *indexPath = [self indexPathForCell:cell];
#ifdef USING_UMComHorizontalTableView_MORESHOW
        if (indexPath.row < self.userListDisplay.count) {
            self.didSelectedUser(self.userListDisplay[indexPath.row]);
#else
        if (indexPath.row < self.userList.count) {
            self.didSelectedUser(self.userList[indexPath.row]);
#endif

        }else{
            self.didSelectedUser(nil);
        }
    }
}

- (void)searchUsersWithKeyWord:(NSString *)keyWord
{
    self.userFetchRequest = [[UMComSearchUserRequest alloc]initWithKeywords:keyWord count:BatchSize];
    __weak UMComHorizontalTableView *weakSelf = self;

    [self.userFetchRequest fetchRequestFromServer:^(NSArray *data, BOOL haveNextPage, NSError *error) {
        weakSelf.userList = data;
        if (error) {
            if([UMComSession sharedInstance].isLogin)
            {
                //登陆状态下，显示提示
                weakSelf.nouserTip.hidden = NO;
            }
            else
            {
                //未登陆状态下，隐藏提示
                weakSelf.nouserTip.hidden = YES;
            }
            
            [UMComShowToast showFetchResultTipWithError:error];
        }else{
            if (data.count == 0) {
                weakSelf.nouserTip.hidden = NO;
            }else{
                weakSelf.nouserTip.hidden = YES;
            }
        }
        [weakSelf reloadData];
    }];
}


@end


@implementation HorizontalTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.transform = CGAffineTransformMakeRotation(M_PI / 2);
        CGFloat imageHeight = self.frame.size.width *3/4;
        CGFloat titleBtHeight = imageHeight/3;
        self.userImageView = [[[UMComImageView imageViewClassName] alloc]initWithFrame:CGRectMake(0, 0, imageHeight, imageHeight)];
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, imageHeight, self.frame.size.height, titleBtHeight)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = UMComFontNotoSansLightWithSafeSize(14);
        [self.titleLabel setTextColor:[UIColor grayColor]];
        self.userImageView.userInteractionEnabled = YES;
        self.titleLabel.userInteractionEnabled = YES;
        [self addSubview:self.titleLabel];
        [self addSubview:self.userImageView];

    }
    return self;
}


- (void)setUser:(UMComUser *)user
{
    _user = user;
    self.titleLabel.text = user.name;
    NSString *iconUrl = [user iconUrlStrWithType:UMComIconSmallType];
    [self.userImageView setImageURL:iconUrl placeHolderImage:[UMComImageView placeHolderImageGender:user.gender.integerValue]];
}


- (void)awakeFromNib
{
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end




