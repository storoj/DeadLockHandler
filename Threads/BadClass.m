#import "BadClass.h"

@implementation BadClass

+ (void)syncronousNetworkRequest {
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"https://mirror.switch.ch/ftp/mirror/gentoo//releases/amd64/20160704/livedvd-amd64-multilib-20160704.iso"]];
    NSLog(@"%lu", data.length);
}

+ (void)semaphore {
    dispatch_semaphore_wait(dispatch_semaphore_create(0), DISPATCH_TIME_FOREVER);
}

@end
