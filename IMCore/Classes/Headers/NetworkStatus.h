//
//  NetworkStatus.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkStatusDelegate

- (void)ReachabilityChange:(UInt32)uiFlags;

@end

@interface NetworkStatus : NSObject {
    __unsafe_unretained id<NetworkStatusDelegate> m_delNetworkStatus;
}

+ (NetworkStatus*)sharedInstance;

- (void)Start:(__unsafe_unretained id<NetworkStatusDelegate>)delNetworkStatus;
- (void)Stop;
- (void)ChangeReach;

@end

NS_ASSUME_NONNULL_END
