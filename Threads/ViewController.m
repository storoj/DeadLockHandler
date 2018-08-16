#import "ViewController.h"

@interface ViewController ()
@property (nonatomic, strong, readonly) UILabel *label;
@end

@implementation ViewController

- (void)loadView {
    _label = [[UILabel alloc] initWithFrame:CGRectZero];
    self.view = _label;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    UILabel *label = self.label;
    label.font = [UIFont systemFontOfSize:34];
    label.text = @"Threads Demo";
    label.textAlignment = NSTextAlignmentCenter;
}

@end
