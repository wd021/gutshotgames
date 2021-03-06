//
//  CharacterViewController.h
//  sumosmash
//
//  Created by Eric Zhang on 4/17/13.
//  Copyright (c) 2013 gutshotgames. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Character.h"
#import "MoveMenu.h"

@protocol CharacterDelegate<NSObject>
-(BOOL) onMoveSelect:(Move*) move;
-(void) onPressSelect:(NSString*) playerId;
-(void) showCharacterHistory:(NSString*) playerId;
-(void) removeCharacterHistory:(NSString*) playerId;
@end

@interface CharacterViewController : UIViewController<MoveMenuDelegate>
{
    Character* _character;
    
    UILabel* _pointDisplay;
    UILabel* _lifeDisplay;
    UILabel* _charDisplay;
    UIImage* _characterPic;
    
    BOOL _isShowingMenu;
    BOOL _isSelf;
    
    id<CharacterDelegate> _delegate;
    
    UIViewController* _menuController;
}

- (id) initWithId:(NSString*) targetId name:(NSString*)name selfId:(NSString*)selfId
     delegate:(id<CharacterDelegate>)target;
- (void) setUserPic:(NSString*) path;
- (void) setCharacterImage:(int) type path:(NSString*) path;


@property (readonly, nonatomic) UILabel* Display;
@property (readonly, nonatomic) Character* Char;

@end
