
id [\u0900-\u097Fa-zA-Z][\u0900-\u097Fa-zA-Z0-9]*
digit [0-9]
EXP	([Ee][-+]?[0-9]+)
\s*

spc			[\t \u00a0\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u200b\u2028\u2029\u3000]

esc \\

%%

"//".*                          /* ignore comment*/
"/*".*                          /* ignore c-style comment*/
\s+                             /* skip whitespace */

"शून्य"                          return 'NULLTOKEN'
"सत्य"                          return 'TRUETOKEN'
"असत्य"                         return 'FALSETOKEN'
"यह"                          return 'THISTOKEN'
"रिक्त"                          return 'VOIDTOKEN'
"मिटाना"                        return 'DELETETOKEN'
"प्रकार"                        return 'TYPEOF'
"नया"                           return 'NEW'
"मान"                           return 'VAR'
"होने"							              return 'LET'
"लगातार"							            return 'CONSTTOKEN'
"करना"                            return 'DO'
"चक्रम्"                           return 'FOR'
"पर्यन्तम्"                         return 'WHILE'
"साथ"                          return 'WITH'
"यदि"                            return 'IF'
"अथ"                            return 'ELSE'
"निर्देश"                        return 'SWITCH'
"यद"                        	return 'CASE'
"यदभावे"                       return 'DEFAULT'
"फेंकना"                        	return 'THROW'
"प्रयत्न"                         	return 'TRY'
"पकड़"                        	return 'CATCH'
"आखिरकार"                       return 'FINALLY'
"जारी_रखें"						          return 'CONTINUE'
"विराम्"							            return 'BREAK'
"फल"						            return 'RETURN'
"सूत्र"                      return 'FUNCTION'
"डिबगर"                      return 'DEBUGGER'

{id}                            return 'IDENT'
[0-9][0-9]*                     return 'NUMBER'
[0-9]+"."[0-9]*{EXP}?                        return 'NUMBER'
"."[0-9]+{EXP}?                        return 'NUMBER'

'>>='                           return 'RSHIFTEQUAL'
'<<='                           return 'LSHIFTEQUAL'

"+="							              return 'PLUSEQUAL'
"-="					                  return 'MINUSEQUAL'
"*="							              return 'MULTEQUAL'
"/="							              return 'DIVEQUAL'
"%="							              return 'MODEQUAL'
'&='							              return 'ANDEQUAL'
'^='							              return 'XOREQUAL'
'|='							              return 'OREQUAL'

'>>'                            return 'RSHIFT'
'<<'                            return 'LSHIFT'
'>>>'                            return 'URSHIFT'


"++"                            return 'PLUSPLUS'
"--"                            return 'MINUSMINUS'

"&&"                             return '&&'
"||"                             return '||'

'<='							              return 'LE'
'>='							              return 'GE'
'=='							              return 'EQEQ'
'==='							              return 'STREQ'
'!=='							              return 'STRNEQ'

':'								              return 'INTOKEN'

';'                             return 'SEMICOLON'

'{'                             return 'OPENBRACE'
'}'                             return 'CLOSEBRACE'

'='                             return '='
'('                             return '('
')'                             return ')'

'['                             return '['
']'                             return ']'
'.'                             return '.'
','                             return ','
"&"                             return '&'
"!"                             return '!'
'~'                             return '~'

"-"                             return '-'
"+"                             return '+'
"*"                             return '*'
'/'                             return '/'
"%"                             return '%'
'<'                             return '<'
'>'                             return '>'
"^"                             return '^'

"|"                             return '|'
"?"                             return '?'

// "PI"                            return 'PI'
// "E"                             return 'E'
<<EOF>>                         return 'EOF'


%%