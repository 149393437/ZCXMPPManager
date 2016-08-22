//
//  GroupCreateViewController.h
//  weiChat
//
//  Created by ZhangCheng on 14/7/3.
//  Copyright (c) 2014年 张诚. All rights reserved.
//

#import "RootViewController.h"

@interface GroupCreateViewController : RootViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    UITextField*nikeName;
    UILabel*useName;
    UITextField*desName;
    UIButton*maxButton;
    UIPickerView*maxPicker;
    
    int isOpen;
    //记录人数
    int num;

}
@end
