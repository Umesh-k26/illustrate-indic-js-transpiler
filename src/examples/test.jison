/* lexical grammar */
%lex

%%
\s*\@[^\n\r]*      /* skip line comments */
\s+                /* skip whitespace */

[A-G](\#|b)?[1-8]\/(128|64|32|16|8|4|2|1)(\.{0,3})  return 'NOTE';
rest\/(128|64|32|16|8|4|2|1)(\.{0,3})               return 'REST';

[0-9]+\b           return 'NUMBER';
\-{3,}             return 'BODY_SEPARATOR';
\"[^"\n]+\"        return 'STRING'

"section"          return 'SECTION';
"song"             return 'SONG';
"end"              return 'END';
"tempo"            return 'TEMPO';
"time_signature"   return 'TIME_SIGNATURE';
"measure"          return 'MEASURE';
"import"           return 'IMPORT';
"from"             return 'FROM';
"to"               return 'TO';
"bpm"              return 'BPM';
":"                return ':';
"/"                return '/';

/lex

/* operator associations and precedence */

%left ':'
%left '/'

%start expressions

%% /* language grammar */

expressions
    : song
        { return { song: $1 }; }
    ;

song
    : SONG STRING END
        { $$ = { name: $2 } }
    ;