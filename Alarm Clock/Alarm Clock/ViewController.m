//
//  ViewController.m
//  Alarm Clock
//
//  Created by mymac on 16/9/30.
//  Copyright © 2016年 XiaoLM. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <CoreData/CoreData.h>
#import "SetViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "TimeModel.h"
#import "AlarmCell.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,AVAudioPlayerDelegate>{
    
    __weak IBOutlet UITableView *_tableView;
    AVAudioPlayer *audioPlayer;
}

@end

@implementation ViewController

static NSInteger i = -1;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(startAction:) userInfo:nil repeats:YES];
    [t fire];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)addClock:(UIBarButtonItem *)sender {
    SetViewController *set = [self.storyboard instantiateViewControllerWithIdentifier:@"SetViewController"];
    
    [self.navigationController pushViewController:set animated:YES];
}

-(void)startAction:(NSTimer *)timer{
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置格式化的字符串样式（英文字符是固定的，其他随便修改，HH表示24小时）
    [formatter setDateFormat:@"yyyy-MM-dd    HH:mm:ss"];
    NSString *dateStr1 = [formatter stringFromDate:now];

    for (int n = 0; n < i ; n++) {
        NSString *d = [self fetchUser:n+1];

        if ([dateStr1 isEqualToString:d]) {
            NSLog(@"闹钟响");
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"bass" ofType:@"caf"];
            //构造URL
            NSURL * fileUrl = [NSURL fileURLWithPath:filePath];
            //创建AVAudioPlayer
            audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileUrl error:nil];
            
            [audioPlayer prepareToPlay];
            [audioPlayer play];
            audioPlayer.delegate = self;
            audioPlayer.currentTime = 30;
            
            //sharedInstance 单例
            AVAudioSession * session = [AVAudioSession sharedInstance];
            //设置会话类型支持后台
            [session setCategory:AVAudioSessionCategoryPlayback error:NULL];
            
            //激活音频会话
            [session setActive:YES error:NULL];
            

        }
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    i++;
    [_tableView reloadData];
}

#pragma mark - delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return i;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmCell *cell = [_tableView dequeueReusableCellWithIdentifier:@"AlarmCell" forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[AlarmCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AlarmCell"];
    }
    cell.date.text = [self fetchUser:indexPath.row+1];
    return cell;
}

- (NSString *)fetchUser:(NSInteger)index
{
    NSString *dateStr = [[NSString alloc]init];
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //context
    NSManagedObjectContext * context = [delegate managedObjectContext];
    
    
    //1:创建查询请求对象
    NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"TimeModel"];
    //2:设置查询条件
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"number == %li",index];
    request.predicate = predicate;
    //3:执行查询请求
    //所有的执行都在context
    NSError * error = nil;
    NSArray * result = [context executeFetchRequest:request error:&error];
    //4:处理查询结果
    if (error)
    {
        NSLog(@"失败%@",error);
    }else
    {
        //处理查询结果
        //遍历结果
        for (TimeModel *timeModel  in result)
        {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd    HH:mm:ss"];
            dateStr = [formatter stringFromDate:timeModel.time];
            
        }
    }
    return dateStr;
}
@end
