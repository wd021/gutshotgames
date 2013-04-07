//
//  Character.m
//  Take2PlaceHolder
//
//  Created by Eric Zhang on 2/19/13.
//
//

#import "Character.h"

@implementation Character

@synthesize NextMove = _nextMove, Display = _characterDisplay, name = _id;

-(id) initWithId:(NSString *)playerId
{
    _id = playerId;
    
    _life = 5;
    _points = 5;
    _lifeUpdate = 0;
    _pointsUpdate = 0;
    
    [self setUserDisplay];
    
    return self;
}

-(id) initWithId:(NSString *) playerId withLife:(int) life withPoints:(int) points
{
    _id = playerId;
    
    _life = life;
    _points = points;
    _lifeUpdate = 0;
    _pointsUpdate = 0;
    
    return self;
}

-(UIImage*) getUserPic:(NSString *)fbId
{
    NSString *path = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square",
                      fbId];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    _characterPic = [[UIImage alloc]initWithData:data];
    
    return _characterPic;
}

-(void) setUserDisplay
{
    _characterDisplay = [[UILabel alloc] init];
    _characterDisplay.textColor = [UIColor darkGrayColor];
    _characterDisplay.backgroundColor = [UIColor clearColor];
    _characterDisplay.text =[NSString stringWithFormat:@"%@: Lives-%d Points-%d", _id, _life, _points];
    
    _characterDisplay.font = [UIFont fontWithName:@"GillSans" size:14.0f];
}

-(BOOL) hasNextMove;
{
    return _nextMove == [Move GetDefaultMove];
}

-(BOOL) UpdateNextMove:(Move*)nextMove
{
    BOOL isValid = [self IsValidMove:nextMove];
    
    _nextMove = isValid ? nextMove : [Move GetDefaultMove];
    
    return isValid;
}

-(BOOL) IsValidMove:(Move*) move
{
    BOOL isValid = YES;
    if (move.Type == ATTACK || move.Type == SUPERATTACK)
    {
        isValid &= move.TargetId != nil;
    }
    
    isValid &= MovePointValues[move.Type] <= _points;
    
    return isValid;
}

-(Move*) RandomizeNextMove:(NSString *)target
{
    int nextType;
    do
    {
        nextType = (MoveType) arc4random() % (uint) MOVECOUNT;
    } while (MovePointValues[nextType] > _points);
    
    Move* nextMove = [[Move alloc] initWithTarget:target withType:nextType];
    [self UpdateNextMove:nextMove];
    
    return nextMove;
}

-(BOOL) IsDead
{
    return _life <= 0;
}

-(BOOL) OnAttack:(MoveType) move
{
    _pointsUpdate = _nextMove.Type == GETPOINTS ? -1 : 0;
    if(!(move == SUPERATTACK && _nextMove.Type == SUPERATTACK))
    {
        _lifeUpdate = MoveDamageValues[move] + (_nextMove.Type == DEFEND);
    }
    
    return _pointsUpdate < 0;
}

-(void) OnRebate
{
    _pointsUpdate = MovePointValues[_nextMove.Type] + REBATE_POINTS;
}

-(NSString*) CommitUpdates
{
    _points -=  _pointsUpdate < 0 ? 0 : MovePointValues[_nextMove.Type] - _pointsUpdate;
    _life += _lifeUpdate;
    
    _pointsUpdate = 0;
    _lifeUpdate = 0;
    
    _nextMove = [Move GetDefaultMove];
    
    return [NSString stringWithFormat:@" %@ used move: %@ \n" , _id, MoveStrings[self.NextMove.Type]];
}

@end