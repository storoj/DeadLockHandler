#import <Foundation/Foundation.h>

void CallStackHelperInit(void);
void CallStackHelperDeinit(void);
NSArray <NSString *> *GetCallStack(pthread_t threadId);
