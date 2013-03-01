#import "DSGameManager.h"
#import "DSRock.h"

#define kSize 6

@interface DSGameManager ()
{
  int  position[kSize][kSize];
}
@end

@implementation DSGameManager

+(DSGameManager *)shared
{
    static DSGameManager *manager = nil;
    
    if (!manager) {
        manager = [DSGameManager new];
         
    }
    return manager;
}

- (void)addBlockToField:(DSRock *)rock
{
    for (int i = 0 ; i < rock.countBlocks; i++) {
        if (rock.direction) 
            position[(int)rock.positionOnField.x][(int)rock.positionOnField.y + i] = 1;
        else
            position[(int)rock.positionOnField.x + i][(int)rock.positionOnField.y ] = 1;
    }
    
}

- (CGPoint)isCanReplaceRock:(DSRock *)rock point:(CGPoint)point
{
    if (rock.countBlocks > 1)
    {
        int occupied;
        
        int oldX = rock.positionOnField.x;
        int oldY = rock.positionOnField.y;
        
        if (rock.direction){
            occupied = (point.y > 0) ? 1 : -1;
      
            if (occupied > 0) {
                if((position[oldX][oldY + rock.countBlocks ] == 0) && ((oldY + rock.countBlocks ) <= kSize - 1))
                {
                    position[oldX][oldY] = 0;
                    position[oldX][oldY + rock.countBlocks] = 1;
                    rock.positionOnField = CGPointMake(oldX , oldY + 1);
                     return CGPointMake(0, kHeigthBranch * occupied);
                }
            }else{
                if((position[oldX][oldY - 1] == 0)&&((oldY - 1) >= 0))
                {
                    position[oldX][oldY - 1] = 1;
                    position[oldX][oldY + rock.countBlocks - 1] = 0;
                    rock.positionOnField = CGPointMake(oldX, oldY - 1);
                     return CGPointMake(0, kHeigthBranch * occupied);
                }
            }
        }else
        {
            occupied = (point.x > 0) ? 1 : -1;
            
            if (occupied > 0) {
                if((position[oldX + rock.countBlocks ][oldY] == 0)&&((oldX + rock.countBlocks ) <= kSize - 1))
                {
                    position[oldX][oldY] = 0;
                    position[oldX + rock.countBlocks ][oldY] = 1;
                    rock.positionOnField = CGPointMake(oldX + 1, oldY);
                    return CGPointMake(kHeigthBranch * occupied, 0);
                }
            }else
                if((position[oldX - 1][oldY] == 0)&&((oldX - 1) >= 0))
                {
                    position[oldX - 1][oldY]= 1;
                    position[oldX + rock.countBlocks - 1][oldY] = 0;
                    rock.positionOnField = CGPointMake(oldX - 1, oldY);
                    return CGPointMake(kHeigthBranch * occupied, 0);
                }
            
        }
    
    }
   return CGPointZero; 
}

@end
