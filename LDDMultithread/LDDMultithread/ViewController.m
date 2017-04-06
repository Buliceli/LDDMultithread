//
//  ViewController.m
//  LDDMultithread
//
//  Created by 李洞洞 on 6/4/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "ViewController.h"
#import "masonry.h"
#import "LDButton.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self groupQueue];
    //[self barrier];
    //[self after];
    //[self once];
    //[self apply];
    [self semaphore];
}
#pragma mark --- 信号量
//GCD让线程同步 目前有三种方式1.dispatch_group 2.dispatch_barrier 3.dispatch_semaphore
//dispatch_semaphore_signal是发送一个信号，自然会让信号总量加1，dispatch_semaphore_wait等待信号，当信号总量少于0的时候就会一直等待，否则就可以正常的执行，并让信号总量-1，
- (void)semaphore
{
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    // 创建信号量，并且设置值为10
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(10);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i < 100; i++)
    {   // 由于是异步执行的，所以每次循环Block里面的dispatch_semaphore_signal根本还没有执行就会执行dispatch_semaphore_wait，从而semaphore-1.当循环10此后，semaphore等于0，则会阻塞线程，直到执行了Block的dispatch_semaphore_signal 才会继续执行
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//执行完该行 信号量-1,
        NSLog(@"---%@----",[NSThread currentThread]);
        
        dispatch_group_async(group, queue, ^{
            NSLog(@"%i",i);
            sleep(4);
            // 每次发送信号则semaphore会+1，
            dispatch_semaphore_signal(semaphore);
        });
    }
    
}
#pragma mark --- 快速for循环
- (void)apply
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //dispatch_queue_t concurrentQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_apply(6, queue, ^(size_t i) {
        NSLog(@"%zu----%d",i,[NSThread isMainThread]);
    });
    
}
#pragma mark --- 单例中仅执行一次的代码
- (void)once
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"此处的代码只执行一次...该代码块和延时方法的代码块是存与代码块段的");
    });
}
#pragma mark -- 延时方法
- (void)after
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"两秒后异步执行的代码");
    });
}
#pragma mark -- 栅栏函数
//并发编程不可避免碰到资源争夺问题 解决问题有三种方式1.@synchronized(self)(相关操作) 2.异步串行队列 这样可以控制对象的操作顺序 3.dispatch_barrier;异步执行两组操作，而且第一组操作执行完之后，才能开始执行第二组操作。这样我们就需要一个相当于栅栏一样的一个方法将两组异步执行的操作组给分割起来，当然这里的操作组里可以包含一个或多个任务。这就需要用到dispatch_barrier_async方法在两个操作组间形成栅栏。
- (void)barrier
{
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_CONCURRENT);
    //dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);//栅栏函数不能用于全局队列
    dispatch_async(queue, ^{
        NSLog(@"第一个任务");
    });
    
    dispatch_async(queue, ^{
        NSLog(@"第二个任务");
    });
    dispatch_barrier_sync(queue, ^{
        NSLog(@"最后一个任务");
    });
}
#pragma mark -- 队列组
- (void)groupQueue
{
    dispatch_group_t myGroup = dispatch_group_create();
    dispatch_queue_t myQueue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
   //dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_async(myGroup, myQueue, ^{
        NSLog(@"第一个任务...");
    });
    dispatch_group_async(myGroup, myQueue, ^{
        NSLog(@"第二个任务...");
    });
    dispatch_group_async(myGroup, myQueue, ^{
        NSLog(@"第三个任务...");
    });
    dispatch_group_notify(myGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"以上三个任务都完成了");
    });
    
}
- (void)addBtn
{
    LDButton * btn1 = ({
        LDButton * btn = [[LDButton alloc]initWithFrame:CGRectMake(0, 20, 60, 40)];
        btn.backgroundColor = [UIColor purpleColor];
        btn.block = ^{
            self.view.backgroundColor = [UIColor lightGrayColor];
        };
        btn;
    });
    [self.view addSubview:btn1];
}

@end
