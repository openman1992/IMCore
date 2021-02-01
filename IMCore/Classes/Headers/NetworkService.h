//
//  NetworkService.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NetworkDelegate.h"
#import "NetworkStatus.h"
#import "PushNotifyDelegate.h"

@class CGITask;

NS_ASSUME_NONNULL_BEGIN

@interface NetworkService : NSObject<NetworkStatusDelegate>

@property(nonatomic, weak) id<NetworkDelegate> delegate;

+ (NetworkService *)sharedInstance;

- (void)setCallBack;
- (void)createMars;

- (void)setClientVersion:(UInt32)clientVersion;
- (void)setShortLinkDebugIP:(NSString *)IP port:(const unsigned short)port;
- (void)setShortLinkPort:(const unsigned short)port;
- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port debugIP:(NSString *)IP;
- (void)setLongLinkAddress:(NSString *)string port:(const unsigned short)port;
- (void)makesureLongLinkConnect;
- (void)destroyMars;

- (void)addPushObserver:(id<PushNotifyDelegate>)observer withCmdId:(int)cmdId;
- (uint32_t)generateTask:(CGITask *)task ForUI:(id<UINotifyDelegate>)delegateUI;
- (void)excuteCTask:(uint32_t)taskId;
- (void)stopTask:(NSInteger)taskID;

// event reporting
- (void)reportEvent_OnForeground:(BOOL)isForeground;
- (void)reportEvent_OnNetworkChange;

// callbacks
- (BOOL)isAuthed;
- (NSArray *)OnNewDns:(NSString *)address;
- (void)OnPushWithCmd:(NSInteger)cid data:(NSData *)data;
- (NSData *)Request2BufferWithTaskID:(uint32_t)tid userContext:(const void *)context;
- (NSInteger)Buffer2ResponseWithTaskID:(uint32_t)tid ResponseData:(NSData *)data userContext:(const void *)context;
- (NSInteger)OnTaskEndWithTaskID:(uint32_t)tid userContext:(const void *)context errType:(uint32_t)errtype errCode:(uint32_t)errcode;
- (void)OnConnectionStatusChange:(int32_t)status longConnStatus:(int32_t)longConnStatus;

// xlog
- (void)createXlogWithIdentifier:(NSString *)identifier;
- (void)logDebug:(NSString *)tag content:(NSString *)content;
- (void)logInfo:(NSString *)tag content:(NSString *)content;
- (void)logWarning:(NSString *)tag content:(NSString *)content;
- (void)logError:(NSString *)tag content:(NSString *)content;
- (void)flushXlog;
- (void)closeXlog;

// DNS
- (NSArray<NSString *> *)getIps: (NSString *)host;

@end

NS_ASSUME_NONNULL_END
