#import "ViewController.h"
#import "SocketIO.h"
@implementation ViewController { SocketManager *manager; SocketIOClient *socket; }
- (void)viewDidLoad{
 [super viewDidLoad];
 manager = [[SocketManager alloc] initWithSocketURL:[NSURL URLWithString:@"http://localhost:8000"] config:@{@"log":@YES,@"reconnects":@YES}];
 socket = manager.defaultSocket;
 [socket on:@"connect" callback:^(NSArray *data, void (^ack)(NSArray*)) { NSLog(@"connected"); }];
 [socket on:@"disconnect" callback:^(NSArray *data, void (^ack)(NSArray*)) { NSLog(@"disconnected"); }];
 [socket on:@"message" callback:^(NSArray *data, void (^ack)(NSArray*)) { NSLog(@"message:%@", data.firstObject); }];
 [socket connect];
}
- (void)joinRoom:(NSString*)room{ [socket emit:@"join" with:@[@{@"room":room}]]; }
- (void)sendText:(NSString*)text room:(NSString*)room{ [socket emit:@"message" with:@[@{@"room":room,@"text":text}]]; }
@end
