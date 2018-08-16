#import "DeadLockBlockHandler.h"

@implementation DeadLockBlockHandler

- (instancetype)initWithBlock:(void (^)(DeadLockInfo *))block {
    self = [super init];
    if (self) {
        _block = block;
    }
    return self;
}

+ (instancetype)block:(void (^)(DeadLockInfo *))block {
    return [[self alloc] initWithBlock:block];
}

- (void)handleDeadLock:(DeadLockInfo *)info {
    self.block(info);
}

@end
