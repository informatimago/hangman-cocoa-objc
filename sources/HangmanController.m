// -*- mode:objc;coding:utf-8 -*-
//****************************************************************************
//FILE:               HangmanController.m
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
#include "HangmanController.h"
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

@implementation HangmanController

-(id)initWithFrame:(NSRect)frame {
    if((self=[super initWithFrame:frame])){
        words=RETAIN(([NSArray arrayWithObjects:@"along", @"and", @"andor", @"any", @"buffer", @"but", @"can",
                               @"copy", @"create", @"details", @"distributed", @"either", @"enter",
                               @"evaluation", @"even", @"file", @"fitness", @"for", @"foundation",
                               @"free", @"general", @"gnu", @"have", @"hope", @"implied", @"later",
                               @"license", @"lisp", @"merchantability", @"modify", @"more", @"not",
                               @"notes", @"option", @"own", @"particular", @"program", @"public",
                               @"published", @"purpose", @"received", @"redistribute", @"save",
                               @"see", @"should", @"software", @"terms", @"text", @"that", @"the",
                               @"then", @"this", @"under", @"useful", @"version", @"visit", @"want",
                               @"warranty", @"will", @"with", @"without", @"you", @"your",nil]));
        loadedWords=nil;}
    return(self);}


-(void)initializeRandom{
    int fd=open("/dev/random",O_RDONLY,0);
    if(fd>=0){
        int seed;
        ssize_t res=read(fd,&seed,sizeof(seed));
        if(res==sizeof(seed)){
            srand(seed);}
        close(fd);}}


-(void)awakeFromNib{
    [self initializeRandom];
    [self connectUI];}


// Game methods:

-(void)connectUI{
    [[self window] makeKeyAndOrderFront:self];
    // // insert self between the window contentView and all the subviews.
    // NSWindow* window=[image window];
    // NSView* content=[window contentView];
    // [self setFrame:[content frame]];
    // NSArray* subviews=[content subviews];
    // [content setSubviews:[NSArray arrayWithObject:self]];
    // [self setSubviews:subviews];
    // when the letter buttons are not in matrix (but in a simple view), update their target/action.
    if(letters!=nil){
        NSArray* letterButtons=[letters subviews];
        NSInteger count=[letterButtons count];
        for(NSInteger i=0;i<count;i++){
            NSButton* button=[letterButtons objectAtIndex:i];
            [button setTarget:self];
            [button setAction:@selector(selectLetter:)];}}}   


-(NSArray*)words{
    if(loadedWords!=nil) {
        words=loadedWords;
        loadedWords=nil;}
    return(words);}


-(NSArray*)readLinesFromFileHandle:(NSFileHandle*)file{
    NSMutableArray* lines=[NSMutableArray array];
    NSData* data=[file readDataToEndOfFile];
    const char* text=[data bytes];
    NSInteger length=[data length];
    NSInteger start=0;
    while(start<length){
        NSInteger end=start;
        while((end<length)&&(text[end]!='\n')){
            end++;}
        [lines addObject:[NSString stringWithCString:text+start length:(end-start)]];
        start=end+1;
        assert(1<start);}
    return(lines);}


-(BOOL)letterIsInAlphabet:(NSString*)letter{
    NSString* alphabet=[hangman alphabet];
    NSRange p=[alphabet rangeOfString:letter];
    return(p.length!=0);}

-(BOOL)wordIsSatisfactory:(NSString*)word{
    NSString* alphabet=[hangman alphabet];
    NSInteger length=[word length];
    if(length<=2) {
        return(NO);}
    NSRange r=NSMakeRange(0,1);
    while(r.location<length){
        NSString* letter=[[word substringWithRange:r] lowercaseString];
        NSRange p=[alphabet rangeOfString:letter];
        if(p.length==0){
            return(NO);}
        r.location++;}
    return(YES);}


-(void)loadWords{
    NSFileHandle* wordsFile=[NSFileHandle fileHandleForReadingAtPath:@"/usr/share/dict/words"];
    if(nil==wordsFile){
        return;}
    NSArray* readWords=[self readLinesFromFileHandle:wordsFile];
    [wordsFile closeFile];
    NSInteger count=[readWords count];
    NSMutableArray* goodWords=[NSMutableArray arrayWithCapacity:count];
    for(NSInteger i=0;i<count;i++) {
        NSString* word=[readWords objectAtIndex:i];
        if([self wordIsSatisfactory:word]){
            [goodWords addObject:[word lowercaseString]];}}
    loadedWords=goodWords;}

-(NSString*)chooseRandomWord{
    NSArray* wordsToChoose=[self words];
    NSInteger count=[wordsToChoose count];
    NSInteger index=rand()%count;
    NSString* word=[wordsToChoose objectAtIndex:index];
    return(word);}


-(NSInteger)maximumErrorCount{
    // TODO: Count the images.
    return(11);}


-(void)setHangImage:(NSInteger)index{
    if((0<=index)&&(index<=[self maximumErrorCount])){
        NSImage* hungImage=[NSImage imageNamed:[NSString stringWithFormat:@"hung-%ld",(long)index]];
        NSLog(@"name=%@ hungImage=%@",[NSString stringWithFormat:@"hung-%ld",(long)index],hungImage);
        [image setImage:hungImage];}}


-(void)initializeGame{
    hangman=[[Hangman alloc] initWithWord:[self chooseRandomWord] maximumErrorCount:[self maximumErrorCount]];
    [self setHangImage:0];
    [guessed setStringValue:[hangman getFoundWord]];
    [message setStringValue:@""];
    [guessed setStringValue:[hangman getFoundWord]];
    finished=NO;}


-(void)finalizeGame{
    [message setStringValue:@"Good bye!"];}


// Actions:
    
-(IBAction)newGame:(id)sender{
    [self initializeGame];}


-(NSString*)getLetterFromSender:(id)sender{
    if([sender isKindOfClass:[NSMatrix class]]) {
        return [[sender selectedCell] title];
    }else{
        return [sender stringValue];}}


-(void)processLetter:(NSString*)letter{
    if(finished){
        return;}
    NSInteger result=[hangman tryLetter:letter];
    switch(result){
      case Hangman_wins:
          [guessed setStringValue:[hangman getWord]];
          [message setStringValue:@"You win!"];
          finished=YES;
          break;
      case Hangman_loses:
          [self setHangImage:[hangman errorCount]];
          [guessed setStringValue:[hangman getWord]];
          [message setStringValue:@"You lose!"];
          finished=YES;
          break;
      case Hangman_alreadyTried:
          [self setHangImage:[hangman errorCount]];
          [guessed setStringValue:[hangman getFoundWord]];
          [message setStringValue:@"You already tried this letter!"];
          break;
      case Hangman_badGuess:
          [self setHangImage:[hangman errorCount]];
          [guessed setStringValue:[hangman getFoundWord]];
          [message setStringValue:@"Bad guess!"];
          break;
      case Hangman_newGuessedWord:
          [self setHangImage:[hangman errorCount]];
          [guessed setStringValue:[hangman getFoundWord]];
          [message setStringValue:@"Good guess!"];
      default:
          break;}}


-(IBAction)selectLetter:(id)sender{
    NSString* letter=[self getLetterFromSender:sender];
    [self processLetter:letter];}
    
    
// application delegate methods:

-(void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    [self initializeGame];}


-(BOOL)applicationShouldTerminate:(id)sender{
  return YES;}


-(void)applicationWillTerminate:(NSNotification *)aNotif{
    [self finalizeGame];}


// NSResponder methods:

-(BOOL)acceptsFirstResponder{
    return YES;}

-(void)keyDown:(NSEvent*)event{
    NSString* letter=[[event characters] lowercaseString];
    if(([letter length]==1) && [self letterIsInAlphabet:letter]){
        [self processLetter:letter];
    }else if([letter isEqualToString:@"\n"]||[letter isEqualToString:@"\r"]){
        [self initializeGame];
    }else{
        [super keyDown:event];}}

@end
//// THE END ////
