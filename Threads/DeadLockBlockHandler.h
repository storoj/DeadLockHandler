#import "DeadLockHandlerProtocol.h"

@interface DeadLockBlockHandler : NSObject <DeadLockHandler>
@property (nonatomic, copy, readonly) void(^block)(DeadLockInfo *);

- (instancetype)initWithBlock:(void(^)(DeadLockInfo *))block;
+ (instancetype)block:(void(^)(DeadLockInfo *))block;
@end
