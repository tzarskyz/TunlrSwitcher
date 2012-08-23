//
//  tunlrSwitcherAppDelegate.m
//  TunlrSwitcher
//
//  Created by Lewis Pollard on 22/08/2012.
//  Copyright (c) 2012 Lewis Pollard. All rights reserved.
//

#import "tunlrSwitcherAppDelegate.h"

@implementation tunlrSwitcherAppDelegate

bool toggled = NO;

NSImage *tunlrOffImage;
NSImage *tunlrOnImage;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Reset DNS across the board to keep consistency */
    [self executeShellScriptFromResourcesFolderAndReturnSuccess:@"reset.sh"];
    
    /* Load images for menubar icon */
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOn.png" ofType:nil inDirectory:@"Resources"];
    tunlrOnImage = [[NSImage alloc] initWithContentsOfFile:fullPath];
    
    fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
    tunlrOffImage = [[NSImage alloc] initWithContentsOfFile:fullPath];
}

-(bool)executeShellScriptFromResourcesFolderAndReturnSuccess:(NSString *) scriptName {
    /* Load path to script */
    NSString *scriptPath = [[NSBundle mainBundle] pathForResource:scriptName ofType:nil inDirectory:@"Resources"];
    /* Create AppleScript to run script */
    NSString *scriptSource = [NSString stringWithFormat:@"do shell script \"%@\" with administrator privileges", scriptPath];
    
    /* Init applescript and execute, returns false if error occurs */
    NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:scriptSource];
    NSDictionary *scriptError = [[NSDictionary alloc] init];
    return [appleScript executeAndReturnError:&scriptError];
}

-(void)awakeFromNib{

    statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    [statusItem setMenu:statusMenu];
    
    NSString *fullPath = [[NSBundle mainBundle] pathForResource:@"tunlrOff.png" ofType:nil inDirectory:@"Resources"];
    NSImage *image = [[NSImage alloc] initWithContentsOfFile:fullPath];
    [statusItem setImage: image];
    [statusItem setHighlightMode:YES];
}

-(IBAction)switch:(id)sender {
    if ([self executeShellScriptFromResourcesFolderAndReturnSuccess:@"switch.sh"]) {
        if (toggled == NO) {
            [statusItem setImage: tunlrOnImage];
            toggled = YES;
        } else {
            [statusItem setImage: tunlrOffImage];
        }
    } else {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Could not set DNS."];
        [alert runModal];
    }
}

@end
