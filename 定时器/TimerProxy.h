//
//  TimerProxy.h
//  定时器
//
//  Created by Jared on 2022/6/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TimerProxy : NSProxy

@property (nonatomic, weak) id target;

+ (instancetype)callWithTarget:(id)target;

@end

NS_ASSUME_NONNULL_END
