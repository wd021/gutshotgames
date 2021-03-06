//
//  GridView.m
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import "GridView.h"
#import "CoordPoint.h"
#import "GridModel.h"

@implementation GridView

- (id)initWithFrame:(CGRect)frame andGridSize:(int)size
{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _grid = [[GridModel alloc] initWithSize:size];
        //_grid.delegate = self;
        float width = frame.size.width / size;
        float height = frame.size.height / size;
        for(int r = 0; r < size; ++r)
        {
            for(int c = 0; c < size; ++c)
            {
                
                CoordPoint* cp = [[CoordPoint alloc] initWithX:r andY:c];
                
                GridCell* cell = [[GridCell alloc] initWithFrame:CGRectMake(c * width, r * height, width, height) andGrid:_grid andCoord:cp];
                cell.delegate = self;
                [self addSubview:cell];
            }
        }
    }
    return self;
}

- (void)cellTouched:(CoordPoint *)coord{
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{ow
    // Drawing code
}
*/

@end
