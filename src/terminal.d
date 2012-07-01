/*
 * Module for helping to nicely format output on POSIX compliant systems
 *
 * See this page on ANSI Terminal Escape Sequences:
 * http://www.termsys.demon.co.uk/vtansi.htm
 */

module terminal;

import std.string : format;

version(Posix) enum TERM_OS_Posix = true;
else enum TERM_OS_Posix = false;

enum TermDisp {
    RESET       = 0,
    BRIGHT      = 1,
    DIM         = 2,
    UNDERLINE   = 4,
    BLINK       = 5,
    REVERSE     = 7,
    HIDDEN      = 8,
    
    FG_BLACK    = 30,
    FG_RED      = 31,
    FG_GREEN    = 32,
    FG_YELLOW   = 33,
    FG_BLUE     = 34,
    FG_MAGENTA  = 35,
    FG_CYAN     = 36,
    FG_WHITE    = 37,
    
    BG_BLACK    = 40,
    BG_RED      = 41,
    BG_GREEN    = 42,
    BG_YELLOW   = 43,
    BG_BLUE     = 44,
    BG_MAGENTA  = 45,
    BG_CYAN     = 46,
    BG_WHITE    = 47
}

string esc(TermDisp[] attribs ...) {
    if(!TERM_OS_Posix) return "";
    
    string escape = "\033[";
    for (int i = 0; i < attribs.length; i++) {
        escape ~= format("%d", attribs[i]);
        
        if (i < attribs.length-1) escape ~= ";";
        else escape ~= "m";
    }
    return escape;
    
}
