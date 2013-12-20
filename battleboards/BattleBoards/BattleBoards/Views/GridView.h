//
//  GridView.h
//  BattleBoards
//
//  Created by Eric Zhang on 12/7/13.
//  Copyright (c) 2013 GutShotGames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridModel.h"
#import "GridCell.h"


@interface GridView : UIView<GridCellDelegate, GridModelDelegate>
{
    int _size;
}

-(id) initWithFrame:(CGRect) frame withSize:(int)size andGridModel:(GridModel*)grid;

-(void) updateCell:(CoordPoint*)cell;

@end
