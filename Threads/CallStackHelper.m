#import "CallStackHelper.h"
#import <pthread.h>

static pthread_t targetThread = 0;
static dispatch_semaphore_t sema;
static NSArray *callstack = nil;
static struct sigaction oldSignalHandler;
static BOOL init = NO;

__attribute__((noinline))
static void _callstack_signal_handler(int signr, siginfo_t *info, void *secret) {
    if (pthread_self() != targetThread) {
        return;
    }

    callstack = [NSThread callStackSymbols];

    dispatch_semaphore_signal(sema);
}

static void _setup_callstack_signal_handler() {
    struct sigaction sa;
    sigfillset(&sa.sa_mask);
    sa.sa_flags = SA_SIGINFO;
    sa.sa_sigaction = _callstack_signal_handler;
    sigaction(SIGUSR2, &sa, &oldSignalHandler);
}

void CallStackHelperInit(void) {
    sema = dispatch_semaphore_create(0);
    _setup_callstack_signal_handler();
    init = YES;
}

void CallStackHelperDeinit(void) {
    if (init) {
        sigaction(SIGUSR2, &oldSignalHandler, NULL);
    }
}

NSArray <NSString *> *GetCallStack(pthread_t threadId) {
    if (threadId == 0 || threadId == pthread_self()) {
        return [NSThread callStackSymbols];
    }

    targetThread = threadId;
    callstack = nil;

    if (pthread_kill(threadId, SIGUSR2) != 0) {
        return nil;
    }

    if (dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC)) != 0) {
        return nil;
    }

    return callstack;
}
