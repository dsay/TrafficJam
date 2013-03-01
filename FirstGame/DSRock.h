#import <Foundation/Foundation.h>

#define kHeigthBranch 100

typedef enum
{
    DSRockTypeBorderBlocks = 0,
    DSRockTypeMainBlocks,
    DSRockTypeElementDoubleBlocks,
    DSRockTypeElementTripleBlocks
    
}DSRockType;

@interface DSRock : UIView

@property (nonatomic, assign) CGPoint positionOnField;
@property (readonly, assign) int countBlocks;
@property (readonly, assign) BOOL direction;

- (id)initWithBranchCount:(DSRockType)type directionToDown:(BOOL)direction;
- (void)moveCenterToIndexX:(int)x y:(int)y;

@end
