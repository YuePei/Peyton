//
//  WDHeader.h
//  WebViewStructure
//
//  Created by Company on 2019/6/27.
//  Copyright © 2019 Company. All rights reserved.
//

#ifndef WDHeader_h
#define WDHeader_h

#ifndef BLOCK_SAFE_CALLS
#define BLOCK_SAFE_CALLS(block, ...) block ? block(__VA_ARGS__) : nil
#endif

#ifndef WEAKSELF
#define WEAK_OBJECT(obj, weakObj)       __weak typeof(obj) weakObj = obj;
#define WEAKSELF                     WEAK_OBJECT(self, weakSelf);
#endif

#ifndef STRONGSELF
#define STRONG_OBJECT(objc, strongObjc) __strong typeof(objc) strongObjc = objc;
#define STRONGSELF                   STRONG_OBJECT(weakSelf, self);
#endif

#endif /* WDHeader_h */
