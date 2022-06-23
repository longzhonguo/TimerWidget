//
//  ZSTimer.m
//  定时器
//
//  Created by Zions Jen.
//

#import "ZSTimer.h"

@implementation ZSTimer

static NSMutableDictionary *timers;
dispatch_semaphore_t semaphore;

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers = [NSMutableDictionary dictionary];
        semaphore = dispatch_semaphore_create(1);
    });
}

+ (NSString *)execTask:(void(^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async {
    
    if (!task || start < 0 || (interval <= 0 && repeats)) return nil;
    //创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, async ? dispatch_queue_create("timer", DISPATCH_QUEUE_SERIAL) : dispatch_get_main_queue());
    //设置时间
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    //唯一标识
    NSString *name = [NSString stringWithFormat:@"%lf", [[NSDate now] timeIntervalSince1970]*1000];
    //存到字典
    timers[name] = timer;
    dispatch_semaphore_signal(semaphore);
    
    //设置回调
    dispatch_source_set_event_handler(timer, ^{
        task();
        if (!repeats) {
            [self cancelTask:name];
        }
    });
    //启动定时器
    dispatch_resume(timer);
    return name;
}

+ (void)cancelTask:(NSString *)timerId {
    if (!timerId.length || !timers[timerId]) return;
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_source_cancel(timers[timerId]);
    [timers removeObjectForKey:timerId];
    
    dispatch_semaphore_signal(semaphore);
}

@end
