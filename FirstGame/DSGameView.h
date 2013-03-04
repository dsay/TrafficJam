#import <UIKit/UIKit.h>
typedef void (^NextRound)(int number);

@interface DSGameView : UIView

@property (nonatomic, copy)NextRound newRound;

- (void)cancelMove;
- (void)enewRound;

@end
