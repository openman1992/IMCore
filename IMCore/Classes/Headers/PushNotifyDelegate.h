//
//  PushNotifyDelegate.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#ifndef PushNotifyDelegate_h
#define PushNotifyDelegate_h

@protocol PushNotifyDelegate <NSObject>

@required - (void)notifyPushMessage:(NSData *)pushData withCmdId:(int)cmdId;

@end

#endif
