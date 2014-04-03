// -*- mode:objc;coding:utf-8 -*-
//****************************************************************************
//FILE:               HangmanController.h
//LANGUAGE:           Objective-C
//SYSTEM:             Linux
//USER-INTERFACE:     GNUstep
//DESCRIPTION
//    
//    The hangman game controller.
//    
//AUTHORS
//    <PJB> Pascal J. Bourguignon <pjb@informatimago.com>
//MODIFICATIONS
//    2014-04-03 <PJB> Created.
//BUGS
//LEGAL
//    AGPL3
//    
//    Copyright Pascal J. Bourguignon 2014 - 2014
//    
//    This program is free software: you can redistribute it and/or modify
//    it under the terms of the GNU Affero General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//    
//    This program is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU Affero General Public License for more details.
//    
//    You should have received a copy of the GNU Affero General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
//****************************************************************************
#ifndef HangmanController_h
#define HangmanController_h
#include <AppKit/AppKit.h>
#include "Hangman.h"

@interface HangmanController:NSView
{
    // outlets:
    IBOutlet NSImageView* image;
    IBOutlet NSView* letters;
    IBOutlet NSTextField* message;
    IBOutlet NSTextField* guessed;

    // private:
    Hangman* hangman;
    NSArray* words;
    NSArray* loadedWords;
    BOOL finished;
}

-(void)awakeFromNib;

// actions:

-(IBAction)selectLetter:(id)sender;
-(IBAction)newGame:(id)sender;


// application delegate methods:

-(void)applicationDidFinishLaunching:(NSNotification*)aNotification;
-(BOOL)applicationShouldTerminate:(id)sender;
-(void)applicationWillTerminate:(NSNotification*)aNotification;

// NSResponder methods:

-(void)keyDown:(NSEvent*)event;

// game methods:

-(void)connectUI;
-(void)initializeGame;
-(void)finalizeGame;


@end
#endif
//// THE END ////
