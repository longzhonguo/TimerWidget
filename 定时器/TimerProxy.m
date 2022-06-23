//
//  TimerProxy.m
//  定时器
//
//  Created by Jared on 2022/6/23.
//

#import "TimerProxy.h"

@implementation TimerProxy

+ (instancetype)callWithTarget:(id)target {
    TimerProxy *mObject = [TimerProxy alloc];
    mObject.target = target;
    return mObject;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}
@end
