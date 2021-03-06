//
//  MoveMenu.m
//  sumosmash
//
//  Created by Eric Zhang on 4/15/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MoveMenu.h"

#define MENU_RADIUS 20

@implementation MoveMenu

- (id)initWithFrame:(CGRect)frame andDelegate:(id<MoveMenuDelegate>)delegate forPlayer:(NSString *)playerId isSelf:(BOOL)isSelf 
{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _target = playerId;
        _isSelf = isSelf;
        
        self.userInteractionEnabled = YES;
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    _container = [[UIView alloc] initWithFrame:self.frame];
    // 2
    CGFloat angleSize = M_PI/MOVECOUNT;
    // 3
    for (int i = 0; i < MOVECOUNT; i++) {
        // 4
        if(_isSelf && (i == ATTACK || i == SUPERATTACK)) continue;
        if(!_isSelf && (i == GETPOINTS || i == DEFEND || i == GETLIFE || i == ADDTEAM)) continue;
        UIButton *im = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 50, 50)];
      //  im.backgroundColor = [UIColor lightGrayColor];
      //  im.titleLabel.font = [UIFont systemFontOfSize:10.0];
      //  [im.titleLabel adjustsFontSizeToFitWidth];
     //   im.titleLabel.numberOfLines = 2;
      //  im.layer.anchorPoint = CGPointMake(1.0f, 0.5f);
        im.layer.zPosition = 100;

        switch(i)
        {
            case ATTACK:
                [im setBackgroundImage:[UIImage imageNamed:@"icon normal.png"] forState:UIControlStateNormal];
                im.layer.position = CGPointMake(25, 30);
                break;
            case SUPERATTACK:
                [im setBackgroundImage:[UIImage imageNamed:@"icon super.png"] forState:UIControlStateNormal];
                im.layer.position = CGPointMake(85, 30);
                break;
            case GETPOINTS:
                [im setBackgroundImage:[UIImage imageNamed:@"icon get 5 points.png"] forState:UIControlStateNormal];
                im.layer.position = CGPointMake(25, 30);
                break;
            case DEFEND:
                [im setBackgroundImage:[UIImage imageNamed:@"icon defend.png"] forState:UIControlStateNormal];
                im.layer.position = CGPointMake(85, 30);
                break;
            case GETLIFE:
                [im setTitle:@"GET LIFE" forState:UIControlStateNormal];
                im.layer.position = CGPointMake(145, 30);
                break;
        }
       // [im setTitle:MoveStrings[i] forState:UIControlStateNormal];
        // 5
       // double x = cos(M_PI + angleSize*i)*MENU_RADIUS + _container.bounds.size.width/2.0;
       // double y = sin(M_PI + angleSize*i)*MENU_RADIUS + _container.bounds.size.height - 20;
     //   im.transform = CGAffineTransformMakeRotation(angleSize * i);
        im.tag = i;
        // 6
        im.userInteractionEnabled = YES;
        [im addTarget:self action:@selector(moveSelected:) forControlEvents:UIControlEventTouchUpInside];
        [_container addSubview:im];
    }
    // 7
    _container.userInteractionEnabled = YES;
    [self addSubview:_container];
}


- (void) moveSelected:(UIButton*) sender
{
    Move* move = [[Move alloc] initWithTarget:_target withType:(MoveType) sender.tag];
    
    if(![_delegate selectedItemChanged:move]) return;
    
    if(_selectedMove)
    {
        [_selectedMove setSelected:NO];
        _selectedMove.backgroundColor = [UIColor clearColor];
    }
    _selectedMove = sender;
   

    [_selectedMove setSelected:YES];
    _selectedMove.backgroundColor = [UIColor blueColor];

}

-(void) clearMove
{
    [_selectedMove setSelected:NO];
    _selectedMove.backgroundColor = [UIColor clearColor];
    _selectedMove = nil;
}


@end
