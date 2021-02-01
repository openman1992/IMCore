//
//  CGITask.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : int32_t {
    ChannelType_ShortConn = 1,
    ChannelType_LongConn = 2,
    ChannelType_All = 3 //长链存在会优先走长链，否则尝试短链
} ChannelType;

@interface CGITask : NSObject

- (id)init;

- (id)initAll:(ChannelType)ChannelType AndCmdId:(int32_t)cmdId AndCGIUri:(NSString *)cgiUri AndHost:(NSString *)host AndBody:(NSData *)body;

@property(nonatomic, copy) NSString *requestName;
@property(nonatomic, assign) uint32_t taskid;
@property(nonatomic, assign) ChannelType channel_select;
@property(nonatomic, assign) int32_t cmdid;
@property(nonatomic, copy) NSString *cgi;
@property(nonatomic, copy) NSString *host;
@property(nonatomic, strong) NSData *body;
@property(nonatomic, strong) NSMutableDictionary *headers;

@end

NS_ASSUME_NONNULL_END
