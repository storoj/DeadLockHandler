#import "DeadLockHandlerProtocol.h"

@interface DeadLockHandlerGroup : NSObject <DeadLockHandler>
@property (nonatomic, copy, readonly) NSArray <id<DeadLockHandler>> *handlers;

- (instancetype)initWithHandlers:(NSArray <id<DeadLockHandler>> *)handlers;
+ (instancetype)handlers:(NSArray <id<DeadLockHandler>> *)handlers;

@end
