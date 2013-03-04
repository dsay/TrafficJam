#import <Foundation/Foundation.h>

#define kSize 6

@class DSRock;

@interface DSGameManager : NSObject

+ (DSGameManager *)shared;
- (CGPoint)isCanReplaceRock:(DSRock *)rock point:(CGPoint)point;
- (void)addBlockToField:(DSRock *)rock;
- (void)cancelMove;
- (int)steps;
- (void)reloadField;

@end
