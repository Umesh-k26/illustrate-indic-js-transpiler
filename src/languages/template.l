
id [{{regexStart}}-{{regexEnd}}a-zA-Z][{{regexStart}}-{{regexEnd}}a-zA-Z0-9]*
digit [0-9]
EXP	([Ee][-+]?[0-9]+)
\s*

spc			[\t \u00a0\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u200b\u2028\u2029\u3000]

esc \\

%%

"//".*                              /* ignore comment*/
"/*".*                              /* ignore c-style comment*/
\s+								    /* skip whitespace */

"{{null}}"                          return 'NULLTOKEN'
"{{true}}"                          return 'TRUETOKEN'
"{{false}}"                         return 'FALSETOKEN'
"{{this}}"                          return 'THISTOKEN'
"{{void}}"                          return 'VOIDTOKEN'
"{{delete}}"                        return 'DELETETOKEN'
"{{typeof}}"                        return 'TYPEOF'
"{{new}}"                           return 'NEW'
"{{var}}"                           return 'VAR'
"{{let}}"							return 'LET'
"{{const}}"							return 'CONSTTOKEN'
"{{do}}"                            return 'DO'
"{{for}}"                           return 'FOR'
"{{while}}"                         return 'WHILE'
"{{with}}"                          return 'WITH'
"{{if}}"                            return 'IF'
"{{else}}"                          return 'ELSE'
"{{switch}}"                        return 'SWITCH'
"{{case}}"                        	return 'CASE'
"{{default}}"                       return 'DEFAULT'
"{{throw}}"                        	return 'THROW'
"{{try}}"                         	return 'TRY'
"{{catch}}"                        	return 'CATCH'
"{{finally}}"                       return 'FINALLY'
"{{continue}}"						return 'CONTINUE'
"{{break}}"							return 'BREAK'
"{{return}}"						return 'RETURN'
"{{function}}"                      return 'FUNCTION'
"{{debugger}}"                      return 'DEBUGGER'

{id}                                return 'IDENT'
[0-9][0-9]*                         return 'NUMBER'
[0-9]+"."[0-9]*{EXP}?               return 'NUMBER'
"."[0-9]+{EXP}?                     return 'NUMBER'

'>>='                               return 'RSHIFTEQUAL'
'<<='                               return 'LSHIFTEQUAL'

"+="							    return 'PLUSEQUAL'
"-="					            return 'MINUSEQUAL'
"*="							    return 'MULTEQUAL'
"/="							    return 'DIVEQUAL'
"%="							    return 'MODEQUAL'
'&='							    return 'ANDEQUAL'
'^='							    return 'XOREQUAL'
'|='							    return 'OREQUAL'

'>>'                                return 'RSHIFT'
'<<'                                return 'LSHIFT'
'>>>'                               return 'URSHIFT'


"++"                                return 'PLUSPLUS'
"--"                                return 'MINUSMINUS'

"&&"                                return '&&'
"||"                                return '||'

'<='							    return 'LE'
'>='							    return 'GE'
'=='							    return 'EQEQ'
'==='							    return 'STREQ'
'!=='							    return 'STRNEQ'

':'								    return 'INTOKEN'

';'                                 return 'SEMICOLON'

'{'								    return 'OPENBRACE'
'}'								    return 'CLOSEBRACE'

'='								    return '='
'('								    return '('
')'								    return ')'

'['								    return '['
']'								    return ']'
'.'								    return '.'
','								    return ','
"&"								    return '&'
"!"								    return '!'
'~'								    return '~'

"-"								    return '-'
"+"								    return '+'
"*"								    return '*'
'/'								    return '/'
"%"								    return '%'
'<'								    return '<'
'>'								    return '>'
"^"								    return '^'

"|"								    return '|'
"?"								    return '?'

// "PI"                            return 'PI'
// "E"                             return 'E'
<<EOF>>                            return 'EOF'


%%
