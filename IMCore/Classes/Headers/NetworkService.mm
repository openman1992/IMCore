//
//  NetworkService.m
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import "NetworkService.h"

#import <SystemConfiguration/SCNetworkReachability.h>

#import "CGITask.h"

#import "stn_callback.h"
#import "app_callback.h"

#import <mars/app/app_logic.h>
#import <mars/stn/stn_logic.h>
#import <mars/baseevent/base_logic.h>
#import <mars/xlog/xlogger.h>
#import <mars/xlog/xloggerbase.h>
#import <mars/xlog/appender.h>
#import <sys/xattr.h>
#import "LogHelper.h"

#import "stnproto_logic.h"

#import "DNS.h"

using namespace mars::stn;

#define __FILENAME__ (strrchr(__FILE__,'/')+1)

/**
 *  Module Logging
 */
#define LOG_ERROR(module, format, ...) LogInternal(kLevelError, module, __FILENAME__, __LINE__, __FUNCTION__, @"Error:", format, ##__VA_ARGS__)
#define LOG_WARNING(module, format, ...) LogInternal(kLevelWarn, module, __FILENAME__, __LINE__, __FUNCTION__, @"Warning:", format, ##__VA_ARGS__)
#define LOG_INFO(module, format, ...) LogInternal(kLevelInfo, module, __FILENAME__, __LINE__, __FUNCTION__, @"Info:", format, ##__VA_ARGS__)
#define LOG_DEBUG(module, format, ...) LogInternal(kLevelDebug, module, __FILENAME__, __LINE__, __FUNCTION__, @"Debug:", format, ##__VA_ARGS__)

@interface NetworkService () {
    @private
    Task waitTask;
}

@end

@implementation NetworkService

static NetworkService * sharedSingleton = nil;


+ (NetworkService*)sharedInstance {
    @synchronized (self) {
        if (sharedSingleton == nil) {
            sharedSingleton = [[NetworkService alloc] init];
        }
    }
    
    return sharedSingleton;
}

- (void)setCallBack {
    mars::stn::SetCallback(mars::stn::StnCallBack::Instance());
    mars::app::SetCallback(mars::app::AppCallBack::Instance());
}

- (void) createMars {
    mars::baseevent::OnCreate();
}

- (void)setClientVersion:(UInt32)clientVersion {
    mars::stn::SetClientVersion(clientVersion);
}

- (void)setShortLinkDebugIP:(NSString *)IP port:(const unsigned short)port {
    std::string ipAddress([IP UTF8String]);
    mars::stn::SetShortlinkSvrAddr(port, ipAddress);
}

- (void)setShortLinkPort:(const unsigned short)port {
    mars::stn::SetShortlinkSvrAddr(port, "");
}

- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port debugIP:(NSString *)IP {
    std::string ipAddress([string UTF8String]);
    std::string debugIP([IP UTF8String]);
    std::vector<uint16_t> ports;
    ports.push_back(port);
    mars::stn::SetLonglinkSvrAddr(ipAddress,ports,debugIP);
}

- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port {
    std::string ipAddress([string UTF8String]);
    std::vector<uint16_t> ports;
    ports.push_back(port);
    mars::stn::SetLonglinkSvrAddr(ipAddress, ports, "");
}

- (void)makesureLongLinkConnect {
    mars::stn::MakesureLonglinkConnected();
}

- (void)destroyMars {
    mars::baseevent::OnDestroy();
}

- (void)addPushObserver:(id<PushNotifyDelegate>)observer withCmdId:(int)cmdId {
    [_delegate addPushObserver:observer withCmdId:cmdId];
}

- (uint32_t)generateTask:(CGITask *)task ForUI:(id<UINotifyDelegate>)delegateUI {
    Task ctask;
    ctask.cmdid = task.cmdid;
    ctask.channel_select = task.channel_select;
    ctask.cgi = std::string(task.cgi.UTF8String);
    ctask.shortlink_host_list.push_back(std::string(task.host.UTF8String));
    ctask.user_context = (__bridge void*)task;
    ctask.channel_strategy = mars::stn::Task::kChannelFastStrategy;
    ctask.server_process_cost = 15 * 1000;
    ctask.limit_frequency = false;
    ctask.limit_flow = false;
    
    std::map<std::string, std::string> headerMap;
    for (int i = 0; i < task.headers.allKeys.count; i++) {
        NSString *key = task.headers.allKeys[i];
        NSString *value = task.headers.allValues[i];
        headerMap[std::string(key.UTF8String)] = std::string(value.UTF8String);
    }
    ctask.headers = headerMap;
    NSString *taskIdKey = [NSString stringWithFormat:@"%d", ctask.taskid];
    [self.delegate addObserver:delegateUI forKey:taskIdKey];
    [self.delegate addCGITasks:task forKey:taskIdKey];
    
//    mars::stn::StartTask(ctask);
    waitTask = ctask;
    
    return ctask.taskid;
}

- (void)excuteCTask:(uint32_t)taskId {
    mars::stn::StartTask(waitTask);
}

- (void)stopTask:(NSInteger)taskID {
    mars::stn::StopTask((uint32_t)taskID);
}

// event reporting
- (void)reportEvent_OnForeground:(BOOL)isForeground {
    mars::baseevent::OnForeground(isForeground);
}

- (void)reportEvent_OnNetworkChange {
    mars::baseevent::OnNetworkChange();
}

// callbacks
- (BOOL)isAuthed {
    return [_delegate isAuthed];
}

- (NSArray *)OnNewDns:(NSString *)address {
    return [_delegate OnNewDns:address];
}

- (void)OnPushWithCmd:(NSInteger)cid data:(NSData *)data {
    return [_delegate OnPushWithCmd:cid data:data];
}

- (NSData*)Request2BufferWithTaskID:(uint32_t)tid userContext:(const void *)context {
    CGITask *task = (__bridge CGITask *)context;
    return [_delegate Request2BufferWithTaskID:tid task:task];
}

- (NSInteger)Buffer2ResponseWithTaskID:(uint32_t)tid ResponseData:(NSData *)data userContext:(const void *)context {
    CGITask *task = (__bridge CGITask *)context;
    return [_delegate Buffer2ResponseWithTaskID:tid responseData:data task:task];
}

- (NSInteger)OnTaskEndWithTaskID:(uint32_t)tid userContext:(const void *)context errType:(uint32_t)errtype errCode:(uint32_t)errcode; {
    CGITask *task = (__bridge CGITask *)context;
    return [_delegate OnTaskEndWithTaskID:tid task:task errType:errtype errCode:errcode];
}

- (void)OnConnectionStatusChange:(int32_t)status longConnStatus:(int32_t)longConnStatus {
    [_delegate OnConnectionStatusChange:status longConnStatus:longConnStatus];
}

- (void)createXlogWithIdentifier:(NSString *)identifier {
    NSString* logPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingString:@"/track/log"];
    const char* attrName = "com.apple.bm.log";
    u_int8_t attrValue = 1;
    setxattr([logPath UTF8String], attrName, &attrValue, sizeof(attrValue), 0, 0);
    xlogger_SetLevel(kLevelWarn);
    appender_set_console_log(false);
    appender_open(kAppednerAsync, [logPath UTF8String], [identifier UTF8String], "");
}

- (void)closeXlog {
    appender_close();
}

- (void)logDebug:(NSString *)tag content:(NSString *)content {
    LOG_DEBUG([tag UTF8String], content);
}

- (void)logInfo:(NSString *)tag content:(NSString *)content {
    LOG_INFO([tag UTF8String], content);
}

- (void)logWarning:(NSString *)tag content:(NSString *)content {
    LOG_WARNING([tag UTF8String], content);
}

- (void)logError:(NSString *)tag content:(NSString *)content {
    LOG_ERROR([tag UTF8String], content);
}

- (void)flushXlog {
    appender_flush();
}

- (NSArray<NSString *> *)getIps:(NSString *)host {
    return [DNS getIpByHost:host];
}

#pragma mark NetworkStatusDelegate
-(void) ReachabilityChange:(UInt32)uiFlags {
    
    if ((uiFlags & kSCNetworkReachabilityFlagsConnectionRequired) == 0) {
        mars::baseevent::OnNetworkChange();
    }
    
}

@end

