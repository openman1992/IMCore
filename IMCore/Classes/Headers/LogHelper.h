//
//  LogHelper.h
//  IMCore
//
//  Created by yubing.li on 2020/4/15.
//  Copyright © 2020 SJYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mars/xlog/xloggerbase.h>

NS_ASSUME_NONNULL_BEGIN

@interface LogHelper : NSObject

+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName message:(NSString *)message;
+ (void)logWithLevel:(TLogLevel)logLevel moduleName:(const char*)moduleName fileName:(const char*)fileName lineNumber:(int)lineNumber funcName:(const char*)funcName format:(NSString *)format, ...;

+ (BOOL)shouldLog:(TLogLevel)level;

@end

#define LogInternal(level, module, file, line, func, prefix, format, ...) \
do { \
    if ([LogHelper shouldLog:level]) { \
        NSString *aMessage = [NSString stringWithFormat:@"%@%@", prefix, [NSString stringWithFormat:format, ##__VA_ARGS__, nil]]; \
        [LogHelper logWithLevel:level moduleName:module fileName:file lineNumber:line funcName:func message:aMessage]; \
    } \
} while(0)

NS_ASSUME_NONNULL_END
