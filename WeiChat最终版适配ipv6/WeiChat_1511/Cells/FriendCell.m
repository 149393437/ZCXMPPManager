//
//  FriendCell.m
//  WeiChat_1511
//
//  Created by zhangcheng on 16/3/11.
//  Copyright © 2016年 zhangcheng. All rights reserved.
//

#import "FriendCell.h"
#import "ThemeManager.h"
@implementation FriendCell

- (void)awakeFromNib {
    // Initialization code
    _headerImage.layer.cornerRadius=22;
    _headerImage.layer.masksToBounds=YES;
    _qmd.editable=NO;
    
}
-(void)configOfFriendModel:(XMPPUserCoreDataStorageObject *)object
{
    //设置颜色
    _nickName.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    _qmd.mmTextColor=[ThemeManager themeColorStrToColor:kTableViewCellDetailTextLabelTextColorNormal];
    
    self.jidStr=[[object.jidStr componentsSeparatedByString:@"@"] firstObject];
    
    //给默认头像
    _headerImage.image=[UIImage imageNamed:@"logo_2"];
    //给默认账号显示
    _nickName.text=self.jidStr;
    //给默认签名
    _qmd.mmText=@"这家伙很懒,没有签名";
    
    //获取头像,昵称,签名
   ZCXMPPManager*manager= [ZCXMPPManager sharedInstance];
    [manager friendsVcard:object.jidStr Block:^(BOOL isVard, XMPPvCardTemp *friend) {
        //判断当前cell的用户名是否是和我通过block返回的是一致的
        if ([self.jidStr isEqualToString:friend.jid.user]) {
            //可以进行赋值
            //头像
            if (friend.photo) {
                _headerImage.image=[UIImage imageWithData:friend.photo];
            }
            if (friend.nickname) {
                _nickName.text=UNCODE(friend.nickname);
            }
            NSString*qmd=[[friend elementForName:QMD]stringValue];
            if (qmd) {
                _qmd.mmText=UNCODE(qmd);
            }
            
        }else{
            //否则抛弃
            
        }
        
    }];



}

-(void)configOfRecent:(NSArray *)array
{
    //设置颜色
    _nickName.textColor=[ThemeManager themeColorStrToColor:kTableViewCellTextLabelTextColorNormal];
    _qmd.mmTextColor=[ThemeManager themeColorStrToColor:kTableViewCellDetailTextLabelTextColorNormal];
    self.jidStr=array[2];
    /*
     (
     [1]W,
     2016-03-11 03:51:19 +0000,
     53276888,
     [1]
     )
     */
    _headerImage.image=[UIImage imageNamed:@"logo_2"];
    _nickName.text=array[2];
    _qmd.mmText=[array firstObject];
    
    NSString*type=[[array firstObject] substringToIndex:3];
    
    if ([type isEqualToString:MESSAGE_STR]) {
        _qmd.mmText=[[array firstObject]substringFromIndex:3];
    }else{
        if ([type isEqualToString:MESSAGE_VOICE]) {
            _qmd.mmText=@"[语音]";
        }else{
            if ([type isEqualToString:MESSAGE_IMAGESTR]) {
                _qmd.mmText=@"[图片]";
            }else if ([type isEqualToString:MESSAGE_BIGIMAGESTR]){
                _qmd.mmText=@"[表情]";
            }else{
                if ([type isEqualToString:MESSAGE_LOCATION]) {
                    _qmd.mmText=@"[位置]";
                }else{
                    _qmd.mmText=@"[其他]";
                }
            
            }
        }
    
    }
    
    
    
    if ([[array lastObject]isEqualToString:GROUPCHAT]) {
        //群聊
        
    }else{
        //单聊
      ZCXMPPManager*manager=[ZCXMPPManager sharedInstance];
        [manager friendsVcard:self.jidStr Block:^(BOOL isOK, XMPPvCardTemp *Friend) {
            if (Friend.photo) {
                _headerImage.image=[UIImage imageWithData:Friend.photo];
            }
            if (Friend.nickname) {
                _nickName.text=UNCODE(Friend.nickname);
            }
            
        }];
    
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
