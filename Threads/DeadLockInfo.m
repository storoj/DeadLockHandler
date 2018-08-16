#import "DeadLockInfo.h"

NSString *NSStringFromDeadLockCallStack(DeadLockCallStack callStack) {
    return [callStack componentsJoinedByString:@"\n"];
}

@implementation DeadLockInfo

- (instancetype)initWithCallStack:(DeadLockCallStack)callStack {
    self = [super init];
    if (self) {
        _callStack = callStack;
    }
    return self;
}

@end
