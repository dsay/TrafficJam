#import "DSGameView.h"
#import "DSRock.h"
#import "DSGameManager.h"

@interface DSGameView ()<UIAlertViewDelegate>
{
    int roundNumber;
}

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) NSMutableArray *rocks;
@property (nonatomic, strong) DSRock *baseRock;
@property (nonatomic, strong) DSRock *selectedView;

@end

@implementation DSGameView

@synthesize panGesture = _panGesture;
@synthesize rocks = _rocks;
@synthesize baseRock = _baseRock;
@synthesize newRound;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addGestureRecognizer:self.panGesture];
        self.backgroundColor = [UIColor lightGrayColor];
        roundNumber = 1;
        [self setupField];
    }
    return self;
}

- (void)cancelMove
{
    [[DSGameManager shared]cancelMove];
}

- (void)enewRound
{
    [self reloadView];
    [self setupField];
}

- (void)nextRound
{
    roundNumber ++;
    self.newRound(roundNumber);
    [self reloadView];
    [self setupField];
}

- (void)reloadView
{
    for (UIView *view in self.rocks) {
        [self.baseRock removeFromSuperview];
        _baseRock = nil;
        [view removeFromSuperview];
    }
    _rocks = nil;
    [[DSGameManager shared] reloadField];
}

- (NSDictionary *)currentRound
{
    NSArray *rounds = [[NSArray alloc] initWithContentsOfFile:[NSBundle.mainBundle pathForResource:@"Rounds" ofType: @"plist"]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"RoundNumber == %d" ,roundNumber];
    NSArray *round = [rounds filteredArrayUsingPredicate:predicate];
 
    return round.lastObject;
}


- (void)setupField
{
    [self addSubview:self.baseRock];

     NSArray *round = [[self currentRound]objectForKey:@"Elements"];
    
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
    static CGPoint oldLocation;
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        CGPoint locationPoint = [gesture locationInView:self];
        self.selectedView = [self isPositionOccupied:locationPoint];
        oldLocation = self.selectedView.center;
    }

    if (gesture.state == UIGestureRecognizerStateEnded)
    {
        CGPoint translationPoint = [gesture translationInView:self];
        CGPoint point = [[DSGameManager shared] isCanReplaceRock:self.selectedView point:translationPoint];
        CGPoint newCenter = CGPointAdd(oldLocation, point);
           
        [UIView animateWithDuration:.35f animations:^{
            self.selectedView.center = newCenter;
        } completion:^(BOOL finished) {
            if ((self.selectedView == self.baseRock) && (newCenter.x == kHeigthBranch * (kSize - 1) ))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You WON!!!" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                alert.delegate = self;
                [alert show];
                
                
            }
        }];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex  == 0) 
        [self nextRound];
}

- (void)addSubview:(UIView *)view
{
    [self.rocks addObject:view];
    [super addSubview:view];
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
    
   
    CGContextSetLineWidth(context, 4.0f);
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.0f, 0.0f, 1.0f, 1.0f};
    CGColorRef color = CGColorCreate(colorspace, components);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextMoveToPoint(context, 598.0f, 200.0f);
    CGContextAddLineToPoint(context, 598, 300.0f);
    CGContextStrokePath(context);
    CGColorSpaceRelease(colorspace);
    CGColorRelease(color);
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
