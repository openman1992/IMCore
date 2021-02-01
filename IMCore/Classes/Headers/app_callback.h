//
//  app_callback.h
//  IMCore
//
//  Created by yubing.li on 2019/10/8.
//  Copyright © 2019 bm. All rights reserved.
//

#ifndef appcomm_callback_h
#define appcomm_callback_h

#import <mars/app/app.h>
#import <mars/app/app_logic.h>

namespace mars {
    namespace app {


class AppCallBack : public Callback {
    
private:
    AppCallBack() {}
    ~AppCallBack() {}
    AppCallBack(AppCallBack&);
    AppCallBack& operator = (AppCallBack&);
    
    
public:
    static AppCallBack* Instance();
    static void Release();
    
    virtual std::string GetAppFilePath();
    
    virtual AccountInfo GetAccountInfo();
    
    virtual unsigned int GetClientVersion();
    
    virtual DeviceInfo GetDeviceInfo();
    
private:
    static AppCallBack* instance_;
};
        
}}

#endif /* appcomm_callback_h */
