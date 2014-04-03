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
#include "Hangman.h"
#include <AppKit/AppKit.h>

@interface HangmanController:NSView
{
    // outlets:
    id image;
    id letters;
    id message;
    id guessed;
}

// actions:

-(void)selectLetter:(id)sender;
-(void)newGame:(id)sender;


@end
#endif
//// THE END ////
