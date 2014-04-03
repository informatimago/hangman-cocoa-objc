// -*- mode:objc;coding:utf-8 -*-
//****************************************************************************
//FILE:               Hangman.h
//LANGUAGE:           Objective-C
//SYSTEM:             POSIX
//USER-INTERFACE:     NONE
//DESCRIPTION
//    
//    The Hangman game model.
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
#ifndef Hangman_h
#define Hangman_h
#include <Foundation/Foundation.h>

#if __has_feature(objc_arc)
#define RETAIN(x) (x)
#define RELEASE(x) (x)
#define AUTORELEASE(x) (x)
#endif

typedef enum {
    Hangman_wins,
    Hangman_loses,
    Hangman_alreadyTried,
    Hangman_badGuess,
    Hangman_newGuessedWord
} Hangman_status;


@interface Hangman:NSObject
{
    NSString*        word; // the word to guess. Should only contain letters in the alphabet.
    NSMutableArray*  found; // array of yes|no one for each letter in word.
    NSMutableString* triedLetters; // array of letters tried so far.
    NSInteger        currentErrorCount;
    NSInteger        maximumErrorCount;
    // Constants:
    NSString*       missingLetter; // "."
    NSString*       alphabet; // abcdefghijklmnopqrstuvwxyz"
    NSNumber*       yes;
    NSNumber*       no;
}

-(id)initWithWord:(NSString*)aWord maximumErrorCount:(NSInteger)aMaximumErrorCount;

-(NSString*)getWord;
-(NSString*)getFoundWord;

-(NSInteger)tryLetter:(NSString*)letter;
// DO:         fill the word with the letter where it belongs.
// RETURN:     a Hangman_status code.

-(NSInteger)errorCount;
-(NSString*)alphabet;
@end
#endif
//// THE END ////
