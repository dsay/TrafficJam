#import "DSGameManager.h"
#import "DSRock.h"

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
        BOOL incrementCoords;
        
        int oldX = rock.positionOnField.x;
        int oldY = rock.positionOnField.y;
        
        if (rock.direction){
            incrementCoords = (point.y > 0) ? YES : NO;
            int howMuchStepsToMove = [self coordsToSteps:point.y];
      
            if (incrementCoords == YES) {
                if((position[oldX][oldY + rock.countBlocks+howMuchStepsToMove-1] == 0) && ((oldY + rock.countBlocks+howMuchStepsToMove-1) <= kSize - 1))
                {
                    for (int yCounter = 0; yCounter < howMuchStepsToMove; yCounter++)
                    {
                        position[oldX][oldY+yCounter] = 0;
                    
                        position[oldX][oldY + rock.countBlocks+yCounter] = 1;
                    }
                    rock.positionOnField = CGPointMake(oldX , oldY + howMuchStepsToMove);
                    return CGPointMake(0, kHeigthBranch * howMuchStepsToMove);
                }
            }else
            {
                if((position[oldX][oldY - howMuchStepsToMove] == 0)&&((oldY - 1) >= 0))
                {
                    for (int yCounter = 0; yCounter < howMuchStepsToMove; yCounter++)
                    {
                        position[oldX][oldY - yCounter + rock.countBlocks-1] = 0;
                        
                        position[oldX][oldY - yCounter] = 1;
                    }
                    rock.positionOnField = CGPointMake(oldX, oldY - howMuchStepsToMove);
                    return CGPointMake(0, -kHeigthBranch * howMuchStepsToMove);
                }
            }
        }else
        {
            incrementCoords = (point.x > 0) ? YES : NO;
            int howMuchStepsToMove = [self coordsToSteps:point.x];
            
            if (incrementCoords == YES) {
                if((position[oldX + rock.countBlocks + howMuchStepsToMove -1][oldY] == 0)&&((oldX + rock.countBlocks +howMuchStepsToMove-1) <= kSize - 1))
                {
                    for (int xCounter = 0; xCounter < howMuchStepsToMove; xCounter++)
                    {
                        position[oldX+xCounter][oldY] = 0;
                        
                        position[oldX+rock.countBlocks+xCounter][oldY] = 1;
                    }
                    rock.positionOnField = CGPointMake(oldX + howMuchStepsToMove, oldY);
                    return CGPointMake(kHeigthBranch * howMuchStepsToMove, 0);
                }
            }else
            {
                if((position[oldX - howMuchStepsToMove][oldY] == 0)&&((oldX - howMuchStepsToMove) >= 0))
                {
                    for (int xCounter = 0; xCounter < howMuchStepsToMove; xCounter++)
                    {
                        position[oldX - xCounter + rock.countBlocks-1][oldY] = 0;
                        
                        position[oldX - xCounter][oldY] = 1;
                    }
                    rock.positionOnField = CGPointMake(oldX - howMuchStepsToMove, oldY);
                    return CGPointMake(-kHeigthBranch * howMuchStepsToMove, 0);
                }
            }
            
        }
    
    }
   return CGPointZero; 
}

- (int)coordsToSteps:(float)offset
{
    float rate = abs(offset/kHeigthBranch);
    if (rate < 1.0)
    {
        rate = 1.0;
    }
    if (rate > kSize - 2)
    {
        rate = kSize - 2;
    }
    return round(rate);
}

@end
