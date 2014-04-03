// -*- mode:objc;coding:utf-8 -*-
//****************************************************************************
//FILE:               Hangman.m
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
#include "Hangman.h"


@implementation Hangman

-(void)initializeFound{
    NSInteger length=[word length];
    found=[NSMutableArray arrayWithCapacity:length];
    for(NSInteger i=0;i<length;i++){
        [found addObject:no];
    }
    [found setObject:yes atIndexedSubscript:0];
    [found setObject:yes atIndexedSubscript:[found count]-1];
}

-(id)initWithWord:(NSString*)aWord maximumErrorCount:(NSInteger)aMaximumErrorCount
{
    if((self=[super init])) {
        missingLetter=@".";
        alphabet=@"abcdefghijklmnopqrstuvwxyz";
        yes=[NSNumber numberWithBool:YES];
        no=[NSNumber numberWithBool:NO];

        word=[aWord lowercaseString];
        [self initializeFound];
        triedLetters=[NSMutableString stringWithCapacity:[alphabet length]];
        currentErrorCount=0;
        maximumErrorCount=aMaximumErrorCount;
    }
    return(self);
}
        

-(NSString*)getWord
{
    return(word);
}

-(NSString*)getFoundWord
{
    NSMutableString* foundWord=[word mutableCopy];
    NSInteger length=[foundWord length];
    for(NSInteger i=0;i<length;i++){
        if(![[found objectAtIndex:i] boolValue]){
            [foundWord replaceCharactersInRange:NSMakeRange(i,1) withString:missingLetter];
        }
    }
    return(foundWord);
}
    
    
-(NSInteger)tryLetter:(NSString*)letter
{

    NSRange r=[triedLetters rangeOfString:letter];
    if(r.length!=0) {
        if(currentErrorCount<maximumErrorCount){
            currentErrorCount++;
        }
        if(currentErrorCount>=maximumErrorCount){
            return(Hangman_loses);
        }else{
            return(Hangman_alreadyTried);
        }
    }
    [triedLetters appendString:letter];

    NSInteger length=[word length];
    BOOL error=YES;
    r=[word rangeOfString:letter];
    while(r.length>0){
        error=NO;
        [found setObject:yes atIndexedSubscript:r.location];
        NSInteger start=r.location+r.length;
        NSRange searchRange=NSMakeRange(start,length-start);
        r=[word rangeOfString:letter options:NSCaseInsensitiveSearch range:searchRange];
    }
    if(error){
        if(currentErrorCount<maximumErrorCount){
            currentErrorCount++;
        }
    }
    if(currentErrorCount>=maximumErrorCount){
        return(Hangman_loses);
    }
    if(![found containsObject:no]){
        return(Hangman_wins);
    }
    if(error) {
        return(Hangman_badGuess);
    }else{
        return(Hangman_newGuessedWord);
    }
}

-(NSInteger)errorCount
{
    return(currentErrorCount);
}

-(NSString*)alphabet
{
    return(alphabet);
}

@end
//// THE END ////
