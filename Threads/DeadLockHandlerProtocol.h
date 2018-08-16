@import Foundation;
@class DeadLockInfo;

@protocol DeadLockHandler <NSObject>
- (void)handleDeadLock:(DeadLockInfo *)info;
@end
