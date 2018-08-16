@import Foundation;
#import "DeadLockHandlerProtocol.h"

@interface DeadLockDetector: NSThread
@property (nonatomic, assign, readonly) pthread_t target;
@property (nonatomic, assign, readwrite) NSTimeInterval interval;
@property (nonatomic, assign, readwrite) NSTimeInterval threshold;
@property (nonatomic, assign, readwrite) NSTimeInterval detectionDuration;
@property (nonatomic, strong, readonly) id<DeadLockHandler> handler;

- (instancetype)initWithTargetThread:(pthread_t)target handler:(id<DeadLockHandler>)handler;

+ (instancetype)detectorWithCurrentThread:(id<DeadLockHandler>)handler;
+ (instancetype)detectorWithTargetThread:(pthread_t)target handler:(id<DeadLockHandler>)handler;
@end
