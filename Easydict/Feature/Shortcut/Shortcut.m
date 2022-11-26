//
//  Shortcut.m
//  Bob
//
//  Created by ripper on 2019/12/9.
//  Copyright © 2019 ripperhe. All rights reserved.
//

#import "Shortcut.h"
#import "EZWindowManager.h"


@implementation Shortcut

+ (void)setup {
    // Most apps need default shortcut, delete these lines if this is not your case
    MASShortcut *selectionShortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_D modifierFlags:NSEventModifierFlagOption];
//    NSData *selectionShortcutData = [NSKeyedArchiver archivedDataWithRootObject:selectionShortcut];
    NSData *selectionShortcutData = [NSKeyedArchiver archivedDataWithRootObject:selectionShortcut requiringSecureCoding:NO error:nil];

    MASShortcut *snipShortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_S modifierFlags:NSEventModifierFlagOption];
//    NSData *snipShortcutData = [NSKeyedArchiver archivedDataWithRootObject:snipShortcut];
    NSData *snipShortcutData = [NSKeyedArchiver archivedDataWithRootObject:snipShortcut requiringSecureCoding:NO error:nil];


    MASShortcut *inputShortcut = [MASShortcut shortcutWithKeyCode:kVK_ANSI_A modifierFlags:NSEventModifierFlagOption];
//    NSData *inputShortcutData = [NSKeyedArchiver archivedDataWithRootObject:inputShortcut];
    NSData *inputShortcutData = [NSKeyedArchiver archivedDataWithRootObject:inputShortcut requiringSecureCoding:NO error:nil];

//
//     Register default values to be used for the first app start
    [[NSUserDefaults standardUserDefaults] registerDefaults:@{
        EZSelectionShortcutKey : selectionShortcutData,
        EZSnipShortcutKey : snipShortcutData,
        EZInputShortcutKey : inputShortcutData,
    }];

    EZWindowManager *windowManager = [EZWindowManager shared];
 
    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:EZSelectionShortcutKey toAction:^{
        [windowManager selectionTranslate];
    }];

    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:EZSnipShortcutKey toAction:^{
        [windowManager snipTranslate];
    }];

    [[MASShortcutBinder sharedBinder] bindShortcutWithDefaultsKey:EZInputShortcutKey toAction:^{
        [windowManager inputTranslate];
    }];

    [[MASShortcutValidator sharedValidator] setAllowAnyShortcutWithOptionModifier:YES];
}

+ (void)readShortcutForKey:(NSString *)key completion:(void (^NS_NOESCAPE)(MASShortcut *_Nullable shorcut))completion {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if (data) {
//        MASShortcut *shortcut = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        MASShortcut *shortcut = [NSKeyedUnarchiver unarchivedObjectOfClass:MASShortcut.class fromData:data error:nil];

        if (shortcut && [shortcut isKindOfClass:MASShortcut.class]) {
            if (shortcut.keyCodeStringForKeyEquivalent.length || shortcut.modifierFlags) {
                completion(shortcut);
            } else {
                completion(nil);
            }
        } else {
            completion(nil);
        }
    } else {
        completion(nil);
    }
}

@end