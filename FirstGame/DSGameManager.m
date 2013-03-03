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

- (void)removeBlockToField:(DSRock *)rock
{
    for (int i = 0 ; i < rock.countBlocks; i++) {
        if (rock.direction)
            position[(int)rock.positionOnField.x][(int)rock.positionOnField.y + i] = 0;
        else
            position[(int)rock.positionOnField.x + i][(int)rock.positionOnField.y ] = 0;
    }
}
   
- (int)translationWithDistance:(float)distance
{
    int translation = abs(distance / kHeigthBranch);
    return (distance > 0) ? 1 * translation : -1 * translation;
}

- (CGPoint)isCanReplaceRock:(DSRock *)rock point:(CGPoint)point
{
    if (rock.countBlocks > 1)
    {
        int translation;
        int tempTranslation;
        
        int oldX = rock.positionOnField.x;
        int oldY = rock.positionOnField.y;
        
        if (rock.direction)
        {
            tempTranslation = [self translationWithDistance:point.y];
            translation = 0;
            
            for (int i = 0 ; i < abs(tempTranslation); i++) {
                if (tempTranslation > 0)
                {
                    if((position[oldX][oldY + rock.countBlocks + i] == 0) && ((oldY + rock.countBlocks + i) <= kSize - 1))
                        translation ++;
                    else
                        break;
                }else{
                    if((position[oldX][oldY - (1 + i)] == 0)&&((oldY - (1 + i)) >= 0))
                        translation --;
                    else
                        break;
                }
            }
            [self removeBlockToField:rock];
            rock.positionOnField = CGPointMake(oldX, oldY + translation);
            [self addBlockToField:rock];
            
            return CGPointMake(0, kHeigthBranch * translation);
        }else
        {
            tempTranslation = [self translationWithDistance:point.x];
            translation = 0;
            
            for (int i = 0 ; i < abs(tempTranslation); i++) {
                if (tempTranslation > 0)
                {
                    if((position[oldX + rock.countBlocks + i][oldY] == 0) && ((oldX + rock.countBlocks + i) <= kSize - 1))
                        translation ++;
                    else
                        break;
                }else{
                    if((position[oldX - (1 + i)][oldY] == 0)&&((oldX - (1 + i)) >= 0))
                        translation --;
                    else
                        break;
                }
            }
            [self removeBlockToField:rock];
            rock.positionOnField = CGPointMake(oldX + translation, oldY);
            [self addBlockToField:rock];
            
            return CGPointMake(kHeigthBranch * translation, 0);
        }
        
    }
    return CGPointZero;
}

//- (CGPoint)isCanReplaceRock:(DSRock *)rock point:(CGPoint)point
//{
//    if (rock.countBlocks > 1)
//    {
//        int occupied;
//        int translation;
//        
//        
//        int oldX = rock.positionOnField.x;
//        int oldY = rock.positionOnField.y;
//        
//        if (rock.direction){
//            occupied = (point.y > 0) ? 1 : -1;
//            translation = [self translationWithDistance:point.y];
//            
//            if (occupied > 0) {
//                if((position[oldX][oldY + rock.countBlocks ] == 0) && ((oldY + rock.countBlocks ) <= kSize - 1))
//                {
//                    position[oldX][oldY] = 0;
//                    position[oldX][oldY + rock.countBlocks] = 1;
//                    rock.positionOnField = CGPointMake(oldX , oldY + 1);
//                     return CGPointMake(0, kHeigthBranch * occupied);
//                }
//            }else{
//                if((position[oldX][oldY - 1] == 0)&&((oldY - 1) >= 0))
//                {
//                    position[oldX][oldY - 1] = 1;
//                    position[oldX][oldY + rock.countBlocks - 1] = 0;
//                    rock.positionOnField = CGPointMake(oldX, oldY - 1);
//                     return CGPointMake(0, kHeigthBranch * occupied);
//                }
//            }
//        }else
//        {
//            occupied = (point.x > 0) ? 1 : -1;
//            
//            if (occupied > 0) {
//                if((position[oldX + rock.countBlocks ][oldY] == 0)&&((oldX + rock.countBlocks ) <= kSize - 1))
//                {
//                    position[oldX][oldY] = 0;
//                    position[oldX + rock.countBlocks ][oldY] = 1;
//                    rock.positionOnField = CGPointMake(oldX + 1, oldY);
//                    return CGPointMake(kHeigthBranch * occupied, 0);
//                }
//            }else
//                if((position[oldX - 1][oldY] == 0)&&((oldX - 1) >= 0))
//                {
//                    position[oldX - 1][oldY]= 1;
//                    position[oldX + rock.countBlocks - 1][oldY] = 0;
//                    rock.positionOnField = CGPointMake(oldX - 1, oldY);
//                    return CGPointMake(kHeigthBranch * occupied, 0);
//                }
//            
//        }
//    
//    }
//   return CGPointZero; 
//}

@end
