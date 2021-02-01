//
//  stn_callback.m
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "stn_callback.h"

#import <mars/comm/autobuffer.h>
#import <mars/xlog/xlogger.h>
#import <mars/stn/stn.h>

#import "NetworkService.h"

namespace mars {
    namespace stn {
        
StnCallBack* StnCallBack::instance_ = NULL;
        
StnCallBack* StnCallBack::Instance() {
    if(instance_ == NULL) {
        instance_ = new StnCallBack();
    }
    
    return instance_;
}
        
void StnCallBack::Release() {
    delete instance_;
    instance_ = NULL;
}
        
bool StnCallBack::MakesureAuthed(const std::string& host) {
    return true;
}

void StnCallBack::TrafficData(ssize_t _send, ssize_t _recv) {
    xdebug2(TSF"send:%_, recv:%_", _send, _recv);
}
        
std::vector<std::string> StnCallBack::OnNewDns(const std::string& _host) {
     NSString *host= [NSString stringWithCString:_host.c_str() encoding:[NSString defaultCStringEncoding]];
     std::vector<std::string> vector;
     NSArray *arr = [[NetworkService sharedInstance] OnNewDns: host];
     for (NSString *item in arr) {
         vector.push_back([item UTF8String]);
     }
     return vector;
}

void StnCallBack::OnPush(uint64_t _channel_id, uint32_t _cmdid, uint32_t _taskid, const AutoBuffer& _body, const AutoBuffer& _extend) {
    if (_body.Length() > 0) {
        NSData* recvData = [NSData dataWithBytes:(const void *) _body.Ptr() length:_body.Length()];
        [[NetworkService sharedInstance] OnPushWithCmd:_cmdid data:recvData];
    }
    
}

bool StnCallBack::Req2Buf(uint32_t _taskid, void* const _user_context, AutoBuffer& _outbuffer, AutoBuffer& _extend, int& _error_code, const int _channel_select, const std::string& host) {
    NSData* requestData =  [[NetworkService sharedInstance] Request2BufferWithTaskID:_taskid userContext:_user_context];
    if (requestData == nil) {
        requestData = [[NSData alloc] init];
    }
    _outbuffer.AllocWrite(requestData.length);
    _outbuffer.Write(requestData.bytes,requestData.length);
    return requestData.length > 0;
}

int StnCallBack::Buf2Resp(uint32_t _taskid, void* const _user_context, const AutoBuffer& _inbuffer, const AutoBuffer& _extend, int& _error_code, const int _channel_select) {
    int handle_type = mars::stn::kTaskFailHandleNormal;
    NSData* responseData = [NSData dataWithBytes:(const void *) _inbuffer.Ptr() length:_inbuffer.Length()];
    NSInteger errorCode = [[NetworkService sharedInstance] Buffer2ResponseWithTaskID:_taskid ResponseData:responseData userContext:_user_context];

    if (errorCode != 0) {
        handle_type = mars::stn::kTaskFailHandleDefault;
    }
    
    return handle_type;
}

int StnCallBack::OnTaskEnd(uint32_t _taskid, void* const _user_context, int _error_type, int _error_code) {
    return (int)[[NetworkService sharedInstance] OnTaskEndWithTaskID:_taskid userContext:_user_context errType:_error_type errCode:_error_code];
}

void StnCallBack::ReportConnectStatus(int _status, int longlink_status) {
    switch (longlink_status) {
        case mars::stn::kServerFailed:
        case mars::stn::kServerDown:
        case mars::stn::kGateWayFailed:
            break;
        case mars::stn::kConnecting:
            break;
        case mars::stn::kConnected:
            break;
        case mars::stn::kNetworkUnkown:
            return;
        default:
            return;
    }
    [[NetworkService sharedInstance] OnConnectionStatusChange:_status longConnStatus:longlink_status];
}

// synccheck：长链成功后由网络组件触发
// 需要组件组包，发送一个req过去，网络成功会有resp，但没有taskend，处理事务时要注意网络时序
// 不需组件组包，使用长链做一个sync，不用重试
int  StnCallBack::GetLonglinkIdentifyCheckBuffer(AutoBuffer& _identify_buffer, AutoBuffer& _buffer_hash, int32_t& _cmdid) {
    return IdentifyMode::kCheckNever;
}

bool StnCallBack::OnLonglinkIdentifyResponse(const AutoBuffer& _response_buffer, const AutoBuffer& _identify_buffer_hash) {
    return false;
}
    
//
void StnCallBack::RequestSync() {}
        
    }
}
