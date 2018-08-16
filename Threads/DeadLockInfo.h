#import <Foundation/Foundation.h>

typedef NSArray <NSString *> *DeadLockCallStack;
NSString *NSStringFromDeadLockCallStack(DeadLockCallStack callStack);

@interface DeadLockInfo: NSObject
@property (nonatomic, copy) DeadLockCallStack callStack;

- (instancetype)initWithCallStack:(DeadLockCallStack)callStack;
@end
