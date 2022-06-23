//
//  MiddleObject.m
//  定时器
//
//  Created by Jared on 2022/6/23.
//

#import "MiddleObject.h"

@implementation MiddleObject

+ (instancetype)callWithTarget:(id)target {
    MiddleObject *mObject = [[MiddleObject alloc] init];
    mObject.target = target;
    return mObject;
}

// 消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector {
    return self.target;
}

@end
