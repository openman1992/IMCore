//
//  UINotifyDelegate.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#ifndef UINotifyDelegate_h
#define UINotifyDelegate_h

@protocol UINotifyDelegate <NSObject>

@required - (NSData *)requestSendDataWithTid:(uint32_t)tid;
@required - (int)onPostDecode:(NSData *)responseData tid:(uint32_t)tid cmdid:(int32_t)cmdid;
@required - (int)onTaskEnd:(uint32_t)tid errType:(uint32_t)errtype errCode:(uint32_t)errcode;

@end

#endif
