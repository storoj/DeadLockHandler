#import "DeadLockHandlerGroup.h"

@implementation DeadLockHandlerGroup

- (instancetype)initWithHandlers:(NSArray <id<DeadLockHandler>> *)handlers {
    self = [super init];
    if (self) {
        _handlers = handlers;
    }
    return self;
}

+ (instancetype)handlers:(NSArray <id<DeadLockHandler>> *)handlers {
    return [[self alloc] initWithHandlers:handlers];
}

- (void)handleDeadLock:(DeadLockInfo *)info {
    for (id<DeadLockHandler> handler in self.handlers) {
        [handler handleDeadLock:info];
    }
}

@end
