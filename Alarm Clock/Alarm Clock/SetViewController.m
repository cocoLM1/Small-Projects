//
//  SetViewController.m
//  Alarm Clock
//
//  Created by mymac on 16/9/30.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import "SetViewController.h"
#import "AppDelegate.h"
#import "TimeModel.h"
@interface SetViewController (){

    
    __weak IBOutlet UITextField *month;
    __weak IBOutlet UITextField *day;
    __weak IBOutlet UITextField *hour;
    __weak IBOutlet UITextField *minute;
    
}

@end

@implementation SetViewController
static NSInteger i = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)add:(UIButton *)sender {
    if (month.text.integerValue > 12 || day.text.integerValue > 31 || hour.text.integerValue > 24 || minute.text.integerValue > 60) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"事件格式不标准" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
    }else{
    
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //context
    NSManagedObjectContext * context = [delegate managedObjectContext];
    
    TimeModel *timeModel = [NSEntityDescription insertNewObjectForEntityForName:@"TimeModel" inManagedObjectContext:context];
    
    //2.NSString 转换成NSDate
        
    //格式化的样式必须和待转换的日期字符一毛一样
    NSString *dateStr2 = [NSString stringWithFormat:@"2016-%2li-%2li    %2li:%2li:00",month.text.integerValue,day.text.integerValue, hour.text.integerValue,minute.text.integerValue];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式化的字符串样式（英文字符是固定的，其他随便修改，HH表示24小时）
    [formatter setDateFormat:@"yyyy-MM-dd    HH:mm:ss"];
    
    
    //完整的写法，带上locale
    [formatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    timeModel.time = [formatter dateFromString:dateStr2];
    NSLog(@"%@",timeModel.time);
    timeModel.number = @(++i);
    [delegate saveContext];
        
    }
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
