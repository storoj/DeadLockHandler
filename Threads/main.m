@import UIKit;
#import "AppDelegate.h"
#import "DeadLockDetector.h"
#import "BadClass.h"
#import "DeadLockBlockHandler.h"
#import "DeadLockHandlerGroup.h"
#import "DeadLockInfo.h"

__attribute__((constructor))
static void __before_main(void) {
    id <DeadLockHandler> logger = [DeadLockBlockHandler block:^(DeadLockInfo *info) {
        NSLog(@"%@", info.callStack);
    }];

    id <DeadLockHandler> fileWriter = [DeadLockBlockHandler block:^(DeadLockInfo *info) {
        NSURL *documentsUrl = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                     inDomain:NSUserDomainMask
                                                            appropriateForURL:nil
                                                                       create:NO
                                                                        error:nil];

        NSURL *fileUrl = [documentsUrl URLByAppendingPathComponent:@"deadlock.latest"];

        NSData *data = [NSStringFromDeadLockCallStack(info.callStack) dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToURL:fileUrl atomically:YES];
    }];

    id <DeadLockHandler> handler = [DeadLockHandlerGroup handlers:@[logger, fileWriter]];

    DeadLockDetector *detector = [DeadLockDetector detectorWithCurrentThread:handler];
    [detector start];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [BadClass semaphore];
    });
}

int main(int argc, char * argv[]) {
    @autoreleasepool {
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
