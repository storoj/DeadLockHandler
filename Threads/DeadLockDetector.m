#import "DeadLockDetector.h"
#import <pthread.h>
#import <mach/mach_time.h>
#import "CallStackHelper.h"
#import "DeadLockInfo.h"

@implementation DeadLockDetector {
    uint64_t _lastTime;
    mach_timebase_info_data_t _timebaseInfo;
}

+ (void)initialize {
    [super initialize];
    
    if (self == [DeadLockDetector class]) {
        CallStackHelperInit();
    }
}

- (void)dealloc {
    CallStackHelperDeinit();
}

- (instancetype)initWithTargetThread:(pthread_t)target handler:(id<DeadLockHandler>)handler {
    self = [super init];
    if (self) {
        _target = target;
        _handler = handler;

        _interval = 0.1;
        _threshold = 3.;

        self.name = @"DeadlocksDetector";
    }
    return self;
}

+ (instancetype)detectorWithCurrentThread:(id<DeadLockHandler>)handler {
    return [[self alloc] initWithTargetThread:pthread_self() handler:handler];
}

+ (instancetype)detectorWithTargetThread:(pthread_t)target handler:(id<DeadLockHandler>)handler {
    return [[self alloc] initWithTargetThread:target handler:handler];
}

#pragma mark Lifecycle

- (void)start {
    [self updateLastTime];
    mach_timebase_info(&_timebaseInfo);

    [super start];
}

- (void)main {
    @autoreleasepool {
        const NSTimeInterval dt = self.interval;
        const NSTimeInterval detectionDuration = self.detectionDuration;

        NSTimer *mainThreadTimer = [NSTimer timerWithTimeInterval:dt target:self selector:@selector(timerMainThread:) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:mainThreadTimer forMode:NSDefaultRunLoopMode];

        NSTimer *watchdogTimer = [NSTimer scheduledTimerWithTimeInterval:dt target:self selector:@selector(timerWatchdog:) userInfo:nil repeats:YES];

        NSTimer *killTimer = nil;
        if (detectionDuration > 0) {
            killTimer = [NSTimer scheduledTimerWithTimeInterval:detectionDuration target:self selector:@selector(timerKill:) userInfo:nil repeats:NO];
        }

        while (![self isCancelled] && [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

        [mainThreadTimer invalidate];
        [watchdogTimer invalidate];
        [killTimer invalidate];
    }
}

- (void)cancel {
    [super cancel];

    CFRunLoopStop([[NSRunLoop currentRunLoop] getCFRunLoop]);
}

#pragma mark Time

- (void)updateLastTime {
    _lastTime = mach_absolute_time();
}

- (uint64_t)nanosecondsFromLastTime {
    return (mach_absolute_time() - _lastTime) * _timebaseInfo.numer / _timebaseInfo.denom;
}

#pragma mark Timer Handlers

- (void)timerMainThread:(id)sender {
    [self performSelector:@selector(updateLastTime) onThread:self withObject:nil waitUntilDone:NO];
}

- (void)timerWatchdog:(NSTimer *)sender {
    if ([self isCancelled]) {
        return;
    }

    const uint64_t nanoseconds = [self nanosecondsFromLastTime];
    const NSTimeInterval seconds = (NSTimeInterval)nanoseconds / NSEC_PER_SEC;

    if (seconds > self.threshold) {
        NSArray <NSString *> *callStack = [self callStackOfTargetThread];

        DeadLockInfo *info = [[DeadLockInfo alloc] initWithCallStack:callStack];
        [self.handler handleDeadLock:info];

        [self cancel];
    }
}

- (void)timerKill:(NSTimer *)sender {
    [self cancel];
}

#pragma mark CallStack

- (NSArray<NSString *> *)callStackOfTargetThread {
    return GetCallStack(_target);
}

@end
