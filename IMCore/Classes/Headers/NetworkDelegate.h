//
//  NetworkDelegate.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import "UINotifyDelegate.h"
#import "PushNotifyDelegate.h"

@class CGITask;

@protocol NetworkDelegate <NSObject>

@required - (void)addPushObserver:(id<PushNotifyDelegate>)observer withCmdId:(int)cmdId;
@required - (void)addObserver:(id<UINotifyDelegate>)observer forKey:(NSString *)key;
@required - (void)addCGITasks:(CGITask *)cgiTask forKey:(NSString *)key;

@required - (BOOL)isAuthed;
@optional - (NSArray *)OnNewDns:(NSString *)address;
@optional - (void)OnPushWithCmd:(NSInteger)cid data:(NSData *)data;

@required - (NSData*)Request2BufferWithTaskID:(uint32_t)tid task:(CGITask *)task;
@required - (NSInteger)Buffer2ResponseWithTaskID:(uint32_t)tid responseData:(NSData *)data task:(CGITask *)task;

@required - (NSInteger)OnTaskEndWithTaskID:(uint32_t)tid task:(CGITask *)task errType:(uint32_t)errtype errCode:(uint32_t)errcode;

@optional - (void)OnConnectionStatusChange:(int32_t)status longConnStatus:(int32_t)longConnStatus;

@end
