//
//  CocosExperimental
//
//  Created by Eric Zhang on 11/12/12.
//
//

#import "GamePlayer.h"
#import "GameLayer.h"

#define DEFAULT_DENSITY 1.0f
#define DEFAULT_FRICTION 0.1f
#define DEFAULT_RESTITUTION 0.01f

#define MAX_LINEAR_VELOCITY 10.0f
#define MAX_ANGULAR_VELOCITY 1.0f
#define STUN_CHANCE 5.0f
#define MAX_FORCE 1.0f
#define MAX_TORQUE 30.0f

#define SPIN_INTERVAL 1.5f


@implementation GamePlayer : CCNode

@synthesize Body = _playerBody;
@synthesize Fixture = _playerFixture;
@synthesize IsStunned = _isStunned;
    
-(id) initWithWorld:(b2World *)world WinSize:(CGSize) winSize RelativeSize:(float) relativeSize
{
    if (self = [super init])
    {
        PhysicsSprite* playerSprite = [PhysicsSprite spriteWithFile:@"Icon-Small-50.png"
                                           rect:CGRectMake(0, 0, 52, 52)];
        
        [playerSprite setPosition:ccp(WORLD_TO_SCREEN(winSize.width/(2*relativeSize/5)),
                                      WORLD_TO_SCREEN(winSize.height/(2*relativeSize/5)))];
        [self addChild:playerSprite];
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.linearDamping = DEFAULT_FRICTION * relativeSize;
        ballBodyDef.angularDamping = 0;
        ballBodyDef.position.Set(WORLD_TO_SCREEN(winSize.width/(2*relativeSize)),
                                 WORLD_TO_SCREEN(winSize.height/(2*relativeSize)));
        ballBodyDef.fixedRotation = false;
        ballBodyDef.userData = self;
        
        _playerBody = world->CreateBody(&ballBodyDef);
        [playerSprite setPhysicsBody:_playerBody];
        
        b2CircleShape circle;
        circle.m_radius = 26.0/PTM_RATIO;
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        
        //default properties
        ballShapeDef.density = DEFAULT_DENSITY*relativeSize;
        ballShapeDef.friction = DEFAULT_FRICTION*relativeSize;
        ballShapeDef.restitution = DEFAULT_RESTITUTION*relativeSize;
        _playerFixture = _playerBody->CreateFixture(&ballShapeDef);
        
        _isStunned = false;
        _stunChance = STUN_CHANCE;
        _maxLinearVelocity = MAX_LINEAR_VELOCITY;
        _maxAngularVelocity = MAX_ANGULAR_VELOCITY;
        _torque = MAX_TORQUE;
        
        
        NSTimer* spinTimer = [NSTimer scheduledTimerWithTimeInterval:SPIN_INTERVAL
                              target:self
                              selector:@selector(OnSpin:)
                              userInfo:nil
                              repeats:YES];
    }
    
    return self;
}


-(void) dealloc
{
    [_stunTimer release];
    _stunTimer = nil;
    
    [super dealloc];
}

-(void) OnSpin:(NSTimer *)timer
{
    if (_isStunned) return;
    
    float speed = _playerBody->GetAngularVelocity();
   
    float torque = _torque;
    
    if (speed > _maxAngularVelocity)
    {
         torque = _maxAngularVelocity /(1/60.0f);
    }
    
     _playerBody->ApplyTorque(torque);
}

-(void) MoveToTouchLocation:(b2Vec2*)location TimeStep:(float)dt
{
    *location -= _playerBody->GetWorldCenter();
    
    float speed = _playerBody->GetLinearVelocity().Length();
    float force = (_maxLinearVelocity - speed) / dt;
    
    if (speed > _maxLinearVelocity)
    {
        force = _maxLinearVelocity / dt;
    }

    
    location->Normalize();
    *location *= force;
    
    _playerBody->ApplyForceToCenter(*location);
}


-(b2Vec2) GetPosition
{
    return _playerBody->GetPosition();
}

-(void) SetStunFromEnergy:(float)energy
{
    if (_isStunned || _stunTimer != nil) return;
    
    u_int32_t isStun = arc4random() % ((u_int32_t)energy+1);
    if (isStun > _stunChance)
    {
        _isStunned =  YES;
    }
    else
    {
        _isStunned = NO;
    }
}

-(void) BeginStun
{
    if(_isStunned)
    {
        _stunTimer = [NSTimer scheduledTimerWithTimeInterval:3.0
                              target:self
                              selector:@selector(OnStunTimeout:)
                              userInfo:nil
                              repeats:NO];
        _playerBody->SetAngularDamping(DEFAULT_FRICTION*100.0f);
        _playerBody->SetFixedRotation(true);
    }
}


-(void) OnStunTimeout:(NSTimer *)timer
{
    _isStunned = NO;
    _stunTimer = nil;
    _playerBody->SetAngularDamping(0);
    _playerBody->SetFixedRotation(false);
}

@end

/* original c++ impl */
//
//namespace GutShotGames {
//namespace Characters {
//
//    Player::Player(b2World* world, CGSize winSize, float relativeSize)
//    {
//        _playerSprite = [CCSprite spriteWithFile:@"Icon-Small-50.png"
//                                  rect:CGRectMake(0, 0, 52, 52)];
//        _playerSprite.position = ccp(WORLD_TO_SCREEN(winSize.width/2*relativeSize),WORLD_TO_SCREEN(winSize.height/2*relativeSize) );
//        
//        // Create ball body and shape
//        b2BodyDef ballBodyDef;
//        ballBodyDef.type = b2_dynamicBody;
//        ballBodyDef.linearDamping = 1.0f;
//        ballBodyDef.angularDamping = 0.01f;
//        ballBodyDef.position.Set(WORLD_TO_SCREEN(winSize.width/2), WORLD_TO_SCREEN(winSize.height/2));
//        ballBodyDef.userData = this;
//        _playerBody = world->CreateBody(&ballBodyDef);
//        
//        b2CircleShape circle;
//        circle.m_radius = 26.0/PTM_RATIO;
//        
//        b2FixtureDef ballShapeDef;
//        ballShapeDef.shape = &circle;
//        
//        //default properties
//        ballShapeDef.density = DEFAULT_DENSITY*relativeSize;
//        ballShapeDef.friction = 1.0f*relativeSize;
//        ballShapeDef.restitution = 0.1f*relativeSize;
//        
//        _playerFixture = _playerBody->CreateFixture(&ballShapeDef);
//        
//        _isStunned = false;
//        _stunChance = 10;
//    }
//    
//    Player::~Player()
//    {
//        delete _playerFixture;
//        
//        _playerFixture = NULL;
//        _playerBody = NULL;
//        _playerSprite = NULL;
//        
//    }
//    
//    
//    void Player::UpdatePosition()
//    {
//        _playerSprite.position = ccp(_playerBody->GetPosition().x * PTM_RATIO,
//                                     _playerBody->GetPosition().y * PTM_RATIO);
//    }
//    
//    void Player::UpdateRotation()
//    {
//        _playerSprite.rotation =
//            -1 * CC_RADIANS_TO_DEGREES(_playerBody->GetAngle());
//    }
//    
//    void Player::HandleCollision(Player* player)
//    {
//        
//    }
//    
//    
//    void Player::SetStun()
//    {
//        u_int32_t isStun = arc4random() % _stunChance;
//        if (isStun == 1)
//        {
//            if (!_isStunned && _stunTimer==NULL)
//            {
//                _isStunned = true;
//                _stunTimer = [NSTimer scheduledTimerWithInterval: 1.0
//                                       target:this
//                                       selector:@selector(OnStunTimer))
//                                       userInfo:nil repeats: NO];
//            }
//        }
//    }
//
//
//
//                              
//
//}
//}