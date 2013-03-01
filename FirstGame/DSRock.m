#import "DSRock.h"
#import <QuartzCore/QuartzCore.h>

@interface DSRock ()
{
    DSRockType type;
}
@end

@implementation DSRock

@synthesize countBlocks = _countBlocks;
@synthesize positionOnField = _positionOnField;
@synthesize direction = _direction;

- (id)initWithBranchCount:(DSRockType)_type directionToDown:(BOOL)direction
{
    CGRect rect;
    switch (_type) {
        case DSRockTypeBorderBlocks:
            _countBlocks = 1;
            break;
        case DSRockTypeMainBlocks:
            _countBlocks = 2;
            break;
        case DSRockTypeElementDoubleBlocks:
            _countBlocks = 2;
            break;
        case DSRockTypeElementTripleBlocks:
            _countBlocks = 3;
            break;
    }
    
    if (direction)
        rect = CGRectMake(0, 0, kHeigthBranch, kHeigthBranch * _countBlocks);
    else
        rect = CGRectMake(0, 0, kHeigthBranch * _countBlocks, kHeigthBranch);
    
    if (self = [super initWithFrame:rect])
    {
        _direction = direction;
        type = _type;
        self.layer.cornerRadius = 25;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1;
        self.backgroundColor = [UIColor lightGrayColor];
    }
    
    return self;
}

- (void)moveCenterToIndexX:(int)i y:(int)j
{
    self.positionOnField = CGPointMake(i, j);
    
    CGPoint point;
    
    if (_direction) 
        point = CGPointMake(i * kHeigthBranch + kHeigthBranch / 2, j * kHeigthBranch + self.frame.size.height / 2);
    else
        point = CGPointMake(i * kHeigthBranch + self.frame.size.width / 2, j * kHeigthBranch + kHeigthBranch / 2);
    
    self.center = point;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image;
    switch (type) {
        case DSRockTypeBorderBlocks:
             image = [UIImage imageNamed:@"Default-Icon"];
            break;
        case DSRockTypeMainBlocks:
            image = [UIImage imageNamed:@"veronica144x144"];
            break;
        case DSRockTypeElementDoubleBlocks:
        case DSRockTypeElementTripleBlocks:
            image = [UIImage imageNamed:@"bg_calendar_cell_active"];
            break;
    }

	CGRect imageRect = CGRectMake(0, 0, kHeigthBranch,  kHeigthBranch);
	CGContextDrawTiledImage(context, imageRect, image.CGImage);
}

@end
