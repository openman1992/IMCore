//
//  DNS.h
//  IMCore
//
//  Created by yubing.li on 2020/5/6.
//  Copyright © 2020 SJYT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DNS : NSObject

+ (NSArray<NSString *> *)getIpByHost: (NSString *)host;

@end

NS_ASSUME_NONNULL_END
