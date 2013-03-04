#import "DSGameManager.h"
#import "DSRock.h"

@interface DSGameManager ()
{
  int  position[kSize][kSize];
}

@property (nonatomic, strong) NSMutableArray *historyMoves;

@end

@implementation DSGameManager

@synthesize historyMoves = _historyMoves;

+(DSGameManager *)shared
{
    static DSGameManager *manager = nil;
    
    if (!manager) {
        manager = [DSGameManager new];
         
    }
    return manager;
}

- (void)reloadField
{
    for (int i = 0; i < kSize; i ++) {
        for (int j = 0; j < kSize; j ++) {
            position[i][j] = 0;
        }
    }
    _historyMoves = nil;
}

- (void)addMoveWithObject:(DSRock *)rock translation:(int)translation
{
    if (translation == 0)
        return;
    
    NSNumber *number = [NSNumber numberWithInt:translation];
    [self.historyMoves addObject:@{@"Rock" : rock ,@"Translation" : number}];
}

- (void)cancelMove
{
    NSDictionary *move = self.historyMoves.lastObject;
    if (move) {
        DSRock *rock = [move objectForKey:@"Rock"];
        int translation = [[move objectForKey:@"Translation"] intValue];
        int oldX = rock.positionOnField.x;
        int oldY = rock.positionOnField.y;
        CGPoint newpoint;
        
        if (rock.direction) {
            [self removeBlockToField:rock];
            rock.positionOnField = CGPointMake(oldX , oldY + translation * (-1));
            [self addBlockToField:rock];
            newpoint = CGPointMake(0, kHeigthBranch * translation * (-1));
        }else{
            [self removeBlockToField:rock];
            rock.positionOnField = CGPointMake(oldX + translation * (-1), oldY);
            [self addBlockToField:rock];
            newpoint = CGPointMake(kHeigthBranch * translation * (-1), 0);
        }
        
        [self.historyMoves removeLastObject];
        [UIView animateWithDuration:.25 animations:^{
            rock.center = CGPointMake(rock.center.x + newpoint.x, rock.center.y + newpoint.y);
        }];
    }
}

- (int)steps
{
    return self.historyMoves.count;
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
    int translation = abs(distance / (kHeigthBranch / 2));
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
            [self addMoveWithObject:rock translation:translation];
            
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
            [self addMoveWithObject:rock translation:translation];
            
            return CGPointMake(kHeigthBranch * translation, 0);
        }
        
    }
    return CGPointZero;
}

- (NSMutableArray *)historyMoves
{
    if (!_historyMoves)
        _historyMoves = [NSMutableArray new];
    
    return _historyMoves;
}

@end
