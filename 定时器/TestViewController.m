//
//  TestViewController.m
//  定时器
//
//  Created by Jared on 2022/6/23.
//

#import "TestViewController.h"
#import "MiddleObject.h"
#import "TimerProxy.h"
#import "ZSTimer.h"
#import "YYWeakProxy.h"

@interface TestViewController ()

@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, strong) NSTimer *timer2;
@property (nonatomic, strong) NSTimer *timer3;
@property (nonatomic, strong) dispatch_source_t timer4;

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.greenColor;
    
    /**
     * 方案1
     *
     * NSTimer的block方式
     * 注意：
     * 1.__weak防止循环引用
     * 2.手动添加runloop
     */
    /*
    __weak typeof(self) weakSelf = self;
    self.timer1 = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf timerAction];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer1 forMode:NSRunLoopCommonModes];
    */
    
    /**
     * 方案2
     *
     * 借助中间对象，传入target，结合forwardingTargetForSelector：消息发送机制
     */
    /*
    self.timer2 = [NSTimer scheduledTimerWithTimeInterval:1 target:[MiddleObject callWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
     */
    
    /**
     * 方案3
     *
     * 该方案比方案2速度快
     * 借助NSProxy，传入target，结合methodSignatureForSelector：和forwardInvocation：消息转发机制
     */
    /*
    self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1 target:[TimerProxy callWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
     */
    
    /**
     * YYKit库中的YYWeakProxy方案
     *
     */
    self.timer3 = [NSTimer scheduledTimerWithTimeInterval:1 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(timerAction) userInfo:nil repeats:YES];
    
    /**
     * 方案4
     *
     * GCDTimer
     * 比NSTimer和CADisplayLink精准
     * 注意timer需要强引用，否则会提前释放导致不执行
     */
    /*
    // 1. 创建 dispatch source，指定检测事件为定时
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    // 2. 设置定时器启动时间、间隔
    /// dispatch_source_set_timer 中第二个参数，当我们使用dispatch_time 或者 DISPATCH_TIME_NOW 时，系统会使用默认时钟来进行计时。然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止。
    /// 使用 dispatch_walltime 可以让计时器按照真实时间间隔进行计时。
//    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC,  0 * NSEC_PER_SEC);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0); //每秒执行
    // 3. 设置callback
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(timer, ^{
        [weakSelf timerAction];
    });
    dispatch_source_set_cancel_handler(timer, ^{
        //取消定时器时一些操作
        NSLog(@"取消了定时器");
    });
    // 4. 启动定时器（刚创建的source处于被挂起状态）
    dispatch_resume(timer);
    //    // 5. 暂停定时器
    //    dispatch_suspend(timer);
    //    // 6. 取消定时器
    //    dispatch_source_cancel(timer);
    //    timer = nil;
    self.timer4 = timer;
     */
    
    /**
     * 方案5
     *
     * GCDTimer的封装，自命名ZSTimer，推荐使用
     */
    /*
    NSString *timerId = [ZSTimer execTask:^{
        [self timerAction];
    } start:0 interval:1 repeats:YES async:NO];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [ZSTimer cancelTask:timerId];
    });
    */
}

- (void)timerAction {
    NSLog(@"timer 执行中 。。。");
}

- (void)dealloc {
    NSLog(@"♻️ dealloc - %@",NSStringFromClass(self.class));
    [self.timer1 invalidate];
    self.timer1 = nil;
    [self.timer2 invalidate];
    self.timer2 = nil;
    [self.timer3 invalidate];
    self.timer3 = nil;
}
@end
