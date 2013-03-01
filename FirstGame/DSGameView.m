#import "DSGameView.h"
#import "DSRock.h"
#import "DSGameManager.h"

#define kHeigthBranch 100

@interface DSGameView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSMutableArray *rocks;
@property (nonatomic, strong) DSRock *baseRock;
@property (nonatomic, strong) DSRock *selectedView;

@end

@implementation DSGameView

@synthesize panGesture = _panGesture;
@synthesize rocks = _rocks;
@synthesize baseRock = _baseRock;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:self.panGesture];
        self.backgroundColor = [UIColor lightGrayColor];

        [self setupField];
    }
    return self;
}

- (void)addSubview:(UIView *)view
{
    [self.rocks addObject:view];
    [super addSubview:view];
}

- (void)setupField
{
    [self addSubview:self.baseRock];

     NSArray *round = [[NSArray alloc] initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Round1" ofType: @"plist"]];
    
    for (NSDictionary *element in round) {
    
        int count = [[element objectForKey:@"count"] intValue];
        BOOL direction = [[element objectForKey:@"direction"] boolValue];
        int x = [[element objectForKey:@"x"] intValue];
        int y = [[element objectForKey:@"y"] intValue];
        
        DSRock *rock = [[DSRock alloc] initWithBranchCount:count directionToDown:direction];
        [rock moveCenterToIndexX:x y:y];
        [[DSGameManager shared] addBlockToField:rock];
        [self addSubview:rock];
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint locationPoint = [gesture locationInView:self];
        self.selectedView = [self isPositionOccupied:locationPoint];
    }
    
    
    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translationPoint = [gesture translationInView:self];
        CGPoint point = [[DSGameManager shared] isCanReplaceRock:self.selectedView point:translationPoint];
        CGPoint newCenter = CGPointAdd(self.selectedView.center, point);
        
        [UIView animateWithDuration:.25 animations:^{
            self.selectedView.center = newCenter; 
        }];
    }
}

- (DSRock *)isPositionOccupied:(CGPoint)point
{
    for (DSRock *view in self.rocks) 
         if (CGRectContainsPoint (view.frame, point))
             return view;
    
    return nil;
}

CGPoint CGPointAdd(CGPoint p1, CGPoint p2)
{
    return CGPointMake(p1.x + p2.x, p1.y + p2.y);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIImage *image = [UIImage imageNamed:@"bg_calendar_cell"];
	CGRect imageRect = CGRectMake(0, 0, kHeigthBranch,  kHeigthBranch);
	CGContextDrawTiledImage(context, imageRect, image.CGImage);
}

- (DSRock *)baseRock
{
    if (!_baseRock) {
           _baseRock= [[DSRock alloc] initWithBranchCount:DSRockTypeMainBlocks directionToDown:NO];
        [_baseRock moveCenterToIndexX:0 y:2];
        [[DSGameManager shared] addBlockToField:_baseRock];
    }
    return _baseRock;
}

- (UIPanGestureRecognizer *)panGesture
{
    if (!_panGesture)
        _panGesture = [[ UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] ;
    
    return _panGesture;
}

- (NSMutableArray *)rocks
{
    if (!_rocks)
        _rocks = [NSMutableArray new];
    
    return _rocks;
}

@end
