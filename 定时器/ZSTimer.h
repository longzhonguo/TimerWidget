//
//  ZSTimer.h
//  定时器
//
//  Created by Zions Jen.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZSTimer : NSObject

+ (NSString *)execTask:(void(^)(void))task start:(NSTimeInterval)start interval:(NSTimeInterval)interval repeats:(BOOL)repeats async:(BOOL)async;
+ (void)cancelTask:(NSString *)timerId;

@end

NS_ASSUME_NONNULL_END
