//
//  DNS.m
//  IMCore
//
//  Created by yubing.li on 2020/5/6.
//  Copyright © 2020 SJYT. All rights reserved.
//

#import "DNS.h"
#import <arpa/inet.h>
#import <resolv.h>
#import <netdb.h>

@implementation DNS

+ (NSArray<NSString *> *)getIpByHost: (NSString *)host {
    Boolean result,bResolved;
    CFHostRef hostRef;
    CFArrayRef addresses = NULL;
    NSMutableArray * ipsArr = [[NSMutableArray alloc] init];

    CFStringRef hostNameRef = CFStringCreateWithCString(kCFAllocatorDefault, [host UTF8String], kCFStringEncodingASCII);
    
    hostRef = CFHostCreateWithName(kCFAllocatorDefault, hostNameRef);
    CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
    result = CFHostStartInfoResolution(hostRef, kCFHostAddresses, NULL);
    if (result == TRUE) {
        addresses = CFHostGetAddressing(hostRef, &result);
    }
    bResolved = result == TRUE ? true : false;
    
    if(bResolved)
    {
        struct sockaddr_in* remoteAddr;
        for(int i = 0; i < CFArrayGetCount(addresses); i++)
        {
            CFDataRef saData = (CFDataRef)CFArrayGetValueAtIndex(addresses, i);
            remoteAddr = (struct sockaddr_in*)CFDataGetBytePtr(saData);
            
            if(remoteAddr != NULL)
            {
                char ip[16];
                strcpy(ip, inet_ntoa(remoteAddr->sin_addr));
                NSString * ipStr = [NSString stringWithCString:ip encoding:NSUTF8StringEncoding];
                [ipsArr addObject:ipStr];
            }
        }
    }
    CFAbsoluteTime end = CFAbsoluteTimeGetCurrent();
    NSLog(@"=== ip === %@ === time cost: %0.3fs", ipsArr,end - start);
    CFRelease(hostNameRef);
    CFRelease(hostRef);
    return ipsArr;
}

@end
