//
//  CGITask.m
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import "CGITask.h"

@implementation CGITask

- (id)init {

    if (self = [super init]) {
        self.channel_select = ChannelType_All;   
    }
    
    return self;
}

- (id)initAll:(ChannelType)ChannelType AndCmdId:(int32_t)cmdId AndCGIUri:(NSString *)cgiUri AndHost:(NSString *)host AndBody:(NSData *)body {
    
    if (self = [super init]) {
        self.channel_select = ChannelType;
        self.cmdid = cmdId;
        self.cgi = cgiUri;
        self.host = host;
        self.body = body;
        self.headers = [NSMutableDictionary dictionary];
    }
    
    return self;
}

@end
