//
//  CCHeader.h
//  PeytonA
//
//  Created by Peyton on 2019/9/4.
//  Copyright © 2019 乐培培. All rights reserved.
//

#ifndef CCHeader_h
#define CCHeader_h

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

#endif /* CCHeader_h */
