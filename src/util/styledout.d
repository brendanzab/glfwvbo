module glfwvbo.util.styledout;

import glfwvbo.util.terminal;


/** Returns an underlined heading string */
string headingString(string heading) {
    return esc(TermDisp.UNDERLINE) ~ heading ~ esc(TermDisp.RESET);
}

/** Returns a red error string */
string errorString(string message = "Error") {
    return esc(TermDisp.FG_RED) ~ message ~ esc(TermDisp.RESET);
}