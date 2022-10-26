/* http://www.opensource.apple.com/source/JavaScriptCore/ */
/* https://zditect.com/blog/31273085.html */
/* https://stackoverflow.com/questions/26661565/adding-functions-to-bison-jison-calculator-language
https://github.com/nolanlawson/jison-debugger 
https://github.com/benjaminjackman/jison-typescript-compiler/blob/master/src/main/jison/js-lex.jisonlex
https://stackoverflow.com/questions/22994440/converting-context-free-grammar-into-regular-expression
https://www.youtube.com/watch?v=_H0TeJek3GI
https://pegjs.org/
https://hepunx.rl.ac.uk/~adye/jsspec11/llr.htm
https://github.com/zaach/jison/issues/379
https://tomassetti.me/parsing-in-javascript/

Astadhyai:
https://www.indica.today/research/paninis-grammar-computer-science/
https://www.researchgate.net/publication/221145943_On_the_Architecture_of_Panini's_Grammar

Panini: https://www.youtube.com/watch?v=b317zJ4JeZY&list=PLmozlYyYE-ERwN1bzzIDN9kvvb5Ooen_7&index=3
https://www.youtube.com/watch?v=bxkp_fuZkks
*/

/* lexical grammar */
%lex

id [a-zA-Z][a-zA-Z0-9]*
digit [0-9]
EXP	([Ee][-+]?[0-9]+)
\s*

spc			[\t \u00a0\u2000\u2001\u2002\u2003\u2004\u2005\u2006\u2007\u2008\u2009\u200a\u200b\u2028\u2029\u3000]

esc \\

%%

"//".*                          /* ignore comment*/
"/*".*                          /* ignore c-style comment*/
\s+                             /* skip whitespace */

"null"                          return 'NULLTOKEN'
"true"                          return 'TRUETOKEN'
"false"                         return 'FALSETOKEN'
"this"                          return 'THISTOKEN'
"void"                          return 'VOIDTOKEN'
"delete"                        return 'DELETETOKEN'
"typeof"                        return 'TYPEOF'
"new"                           return 'NEW'

"var"                           return 'VAR'
"let"							              return 'LET'
"const"							            return 'CONSTTOKEN'
"do"                            return 'DO'
"for"                           return 'FOR'
"while"                         return 'WHILE'
"with"                          return 'WITH'

"switch"                        return 'SWITCH'
"case"                        	return 'CASE'
"default"                       return 'DEFAULT'
"throw"                        	return 'THROW'
"try"                         	return 'TRY'
"catch"                        	return 'CATCH'
"finally"                       return 'FINALLY'


"continue"						          return 'CONTINUE'
"break"							            return 'BREAK'
"return"						            return 'RETURN'

"function"                      return 'FUNCTION'
"debugger"                      return 'DEBUGGER'

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


/lex

%{
/* unary exp node */
function unaryNode(type, identifier)
{
    return {
        type: type,
        identifier: identifier
    }
}

/* assignment, binary, logical, shift exp, relational exp */
function expNode(a, b, type, operator)
{
	return {
		type: type,
		left: a,
		right: b,
		operator: operator 
	}
}

/* ternary exp */
function ternaryNode(type, a, b, c)
{
  return {
    type: type,
    exp1: a,
    exp2: b,
    exp3: c
  }
}
/* call expression */
function callNode(type, identifier, argument)
{
	return {
		type: type,
		identifier: identifier,
		argument: argument
	}
}

/* loop statement node */
function loopNode(type, init, update, test, body)
{
	return {
		type: type,
		init: init,
		update: update,
		test: test,
		body: body
	}
}

/* range-based loop */
function rangeloopNode(type, lhs, rhs, body)
{
	return {
		type: type,
		lhs: lhs,
		rhs: rhs,
		body: body
	}
}

/* identifier node */
function newId(identifier, value)
{
	return {
		identifier: identifier,
		value: value | null
	}
}

/* function node */
function funcNode(identifier, body, arguments)
{
	return {
		identifier: identifier,
		body: body,
		arguments: arguments
	}
}
%}
%start Program

%nonassoc IF_WITHOUT_ELSE
%nonassoc ELSE

%left '+' '-'
%left '*' '/'
%left '^'
%right '!'
%right '%'
%left UMINUS


%%

// expressions
//     : e EOF
//         {return $1;}
//     ;

// e
//     : e '+' e
//         {$$ = $1+$3;}
//     | e '-' e
//         {$$ = $1-$3;}
//     | e '*' e
//         {$$ = $1*$3;}
//     | e '/' e
//         {$$ = $1/$3;}
//     | e '^' e
//         {$$ = Math.pow($1, $3);}
//     | e '!'
//         {{
//           $$ = (function fact (n) { return n==0 ? 1 : fact(n-1) * n })($1);
//         }}
//     | e '%'
//         {$$ = $1/100;}
//     | '-' e %prec UMINUS
//         {$$ = -$2;}
//     | '(' e ')'
//         {$$ = $2;}
//     | NUMBER
//         {$$ = Number(yytext);}
//     | E
//         {$$ = Math.E;}
//     | PI
//         {$$ = Math.PI;}
//     ;

Literal
    : NULLTOKEN
    | TRUETOKEN
    | FALSETOKEN
    | NUMBER { $$ = Number($1) }
    | STRING { $$ = $1 }
    | '/'
    // | DIVEQUAL
    ;

Property
    : IDENT ':' AssignmentExpr
    | STRING ':' AssignmentExpr
    | NUMBER ':' AssignmentExpr
    | IDENT IDENT '(' ')' OPENBRACE FunctionBody CLOSEBRACE
    | IDENT IDENT '(' FormalParameterList ')' OPENBRACE FunctionBody CLOSEBRACE
    ;

PropertyList
    : Property
    | PropertyList ',' Property
    ;

PrimaryExpr
    : PrimaryExprNoBrace
    | OPENBRACE CLOSEBRACE
    | OPENBRACE PropertyList CLOSEBRACE
    | OPENBRACE PropertyList ',' CLOSEBRACE
    ;

PrimaryExprNoBrace
    : THISTOKEN
    | Literal
    | ArrayLiteral
    | IDENT
    | '(' Expr ')'
    ;

ArrayLiteral
    : '[' ElisionOpt ']'
    | '[' ElementList ']'
    | '[' ElementList ',' ElisionOpt ']'
    ;

ElementList
    : ElisionOpt AssignmentExpr
    | ElementList ',' ElisionOpt AssignmentExpr
    ;

ElisionOpt
    : 
    | Elision
    ;

Elision
    : ','
    | Elision ','
    ;

MemberExpr
    : PrimaryExpr
    | FunctionExpr
    | MemberExpr '[' Expr ']'
    | MemberExpr '.' IDENT
    | NEW MemberExpr Arguments
    ;

MemberExprNoBF
    : PrimaryExprNoBrace
    | MemberExprNoBF '[' Expr ']'
    | MemberExprNoBF '.' IDENT
    | NEW MemberExpr Arguments
    ;

NewExpr
    : MemberExpr
    | NEW NewExpr
    ;

NewExprNoBF
    : MemberExprNoBF
    | NEW NewExpr
    ;

CallExpr
    : MemberExpr Arguments
    | CallExpr Arguments
    | CallExpr '[' Expr ']'
    | CallExpr '.' IDENT
    ;

CallExprNoBF
    : MemberExprNoBF Arguments
    | CallExprNoBF Arguments
    | CallExprNoBF '[' Expr ']'
    | CallExprNoBF '.' IDENT
    ;

Arguments
    : '(' ')'
    | '(' ArgumentList ')'
    ;

ArgumentList
    : AssignmentExpr
    | ArgumentList ',' AssignmentExpr
    ;

LeftHandSideExpr
    : NewExpr
    | CallExpr
    ;

LeftHandSideExprNoBF
    : NewExprNoBF
    | CallExprNoBF
    ;

PostfixExpr
    : LeftHandSideExpr
    | LeftHandSideExpr PLUSPLUS
    | LeftHandSideExpr MINUSMINUS
    ;

PostfixExprNoBF
    : LeftHandSideExprNoBF { $$ = $1 }
    | LeftHandSideExprNoBF PLUSPLUS { $$ = 'a'}
    | LeftHandSideExprNoBF MINUSMINUS { $$ = 'b'}
    ;

UnaryExprCommon
    : DELETETOKEN UnaryExpr 
    { $$ = unaryNode('delete', $2) }
    | VOIDTOKEN UnaryExpr 
    { $$ = unaryNode('void', $2) }
    | TYPEOF UnaryExpr 
    { $$ = unaryNode('typeof', $2) }
    | PLUSPLUS UnaryExpr 
    { $$ = unaryNode('++', $2) }
    | AUTOPLUSPLUS UnaryExpr 
    { $$ = unaryNode('++', $2) }
    | MINUSMINUS UnaryExpr 
    { $$ = unaryNode('--', $2) }
    | AUTOMINUSMINUS UnaryExpr 
    { $$ = unaryNode('--', $2) }
    | '+' UnaryExpr 
    { $$ = unaryNode('+', $2) }
    | '-' UnaryExpr 
    { $$ = unaryNode('-', $2) }
    | '~' UnaryExpr 
    { $$ = unaryNode('~', $2) }
    | '!' UnaryExpr 
    { $$ = unaryNode('!', $2) }
    ;

UnaryExpr
    : PostfixExpr { $$ = $1 }
    | UnaryExprCommon { $$ = $1 }
    ;

UnaryExprNoBF
    : PostfixExprNoBF
    | UnaryExprCommon
    ;

MultiplicativeExpr
    : UnaryExpr { $$ = $1 }
    | MultiplicativeExpr '*' UnaryExpr { $$ = expNode($1, $3, 'logical_exp', '*') }
    | MultiplicativeExpr '/' UnaryExpr { $$ = expNode($1, $3, 'logical_exp', '/') }
    | MultiplicativeExpr '%' UnaryExpr { $$ = expNode($1, $3, 'logical_exp', '%') }
    ;

MultiplicativeExprNoBF
    : UnaryExprNoBF { $$ = $1 }
    | MultiplicativeExprNoBF '*' UnaryExpr { $$ = expNode($1, $3, 'logical_exp', '*') }
    | MultiplicativeExprNoBF '/' UnaryExpr { $$ = expNode($1, $3, 'logical_exp', '/') }
    | MultiplicativeExprNoBF '%' UnaryExpr { $$ = expNode($1, $3, 'logical_exp', '%') }
    ;

AdditiveExpr
    : MultiplicativeExpr { $$ = $1 }
    | AdditiveExpr '+' MultiplicativeExpr { $$ = expNode($1, $3, 'logical_exp', '+') }
    | AdditiveExpr '-' MultiplicativeExpr { $$ = expNode($1, $3, 'logical_exp', '-') }
    ;

AdditiveExprNoBF
    : MultiplicativeExprNoBF { $$ = $1 }
    | AdditiveExprNoBF '+' MultiplicativeExpr { $$ = expNode($1, $3, 'logical_exp', '+') }
    | AdditiveExprNoBF '-' MultiplicativeExpr { $$ = expNode($1, $3, 'logical_exp', '-')}
    ;

ShiftExpr
    : AdditiveExpr { $$ = $1 }
    | ShiftExpr LSHIFT AdditiveExpr { $$ = expNode($1, $3, 'shift_exp', '<<') }
    | ShiftExpr RSHIFT AdditiveExpr { $$ = expNode($1, $3, 'shift_exp', '>>') }
    | ShiftExpr URSHIFT AdditiveExpr
    ;

ShiftExprNoBF
    : AdditiveExprNoBF { $$ = $1 }
    | ShiftExprNoBF LSHIFT AdditiveExpr { $$ = expNode($1, $3, 'shift_exp', '<<') }
    | ShiftExprNoBF RSHIFT AdditiveExpr { $$ = expNode($1, $3, 'shift_exp', '>>') }
    | ShiftExprNoBF URSHIFT AdditiveExpr
    ;

RelationalExpr
    : ShiftExpr { $$ = $1 }
    | RelationalExpr '<' ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '<') }
    | RelationalExpr '>' ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '>') }
    | RelationalExpr LE ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '<=') }
    | RelationalExpr GE ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '>=') }
    | RelationalExpr INSTANCEOF ShiftExpr
    | RelationalExpr INTOKEN ShiftExpr
    ;

RelationalExprNoIn
    : ShiftExpr { $$ = $1 }
    | RelationalExprNoIn '<' ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '<') }
    | RelationalExprNoIn '>' ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '>') }
    | RelationalExprNoIn LE ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '<=') }
    | RelationalExprNoIn GE ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '>=') }
    | RelationalExprNoIn INSTANCEOF ShiftExpr
    ;

RelationalExprNoBF
    : ShiftExprNoBF { $$ = $1 }
    | RelationalExprNoBF '<' ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '<') }
    | RelationalExprNoBF '>' ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '>') }
    | RelationalExprNoBF LE ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '<=') }
    | RelationalExprNoBF GE ShiftExpr { $$ = expNode($1, $3, 'relational_exp', '>=') }
    | RelationalExprNoBF INSTANCEOF ShiftExpr
    | RelationalExprNoBF INTOKEN ShiftExpr
    ;

EqualityExpr
    : RelationalExpr { $$ = $1 }
    | EqualityExpr EQEQ RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '==') }
    | EqualityExpr NE RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '!=') }
    | EqualityExpr STREQ RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '===') }
    | EqualityExpr STRNEQ RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '!==') }
    ;

EqualityExprNoIn
    : RelationalExprNoIn { $$ = $1 }
    | EqualityExprNoIn EQEQ RelationalExprNoIn { $$ = expNode($1, $3, 'relational_exp', '==') }
    | EqualityExprNoIn NE RelationalExprNoIn { $$ = expNode($1, $3, 'relational_exp', '!=') }
    | EqualityExprNoIn STREQ RelationalExprNoIn { $$ = expNode($1, $3, 'relational_exp', '===') }
    | EqualityExprNoIn STRNEQ RelationalExprNoIn { $$ = expNode($1, $3, 'relational_exp', '!==') }
    ;

EqualityExprNoBF
    : RelationalExprNoBF { $$ = $1 }
    | EqualityExprNoBF EQEQ RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '==') }
    | EqualityExprNoBF NE RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '!=') }
    | EqualityExprNoBF STREQ RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '===') }
    | EqualityExprNoBF STRNEQ RelationalExpr { $$ = expNode($1, $3, 'relational_exp', '!==') }
    ;

BitwiseANDExpr
    : EqualityExpr { $$ = $1 }
    | BitwiseANDExpr '&' EqualityExpr { $$ = expNode($1, $3, 'bitwise_exp', '&') }
    ;

BitwiseANDExprNoIn
    : EqualityExprNoIn { $$ = $1 }
    | BitwiseANDExprNoIn '&' EqualityExprNoIn { $$ = expNode($1, $3, 'bitwise_exp', '&') }
    ;

BitwiseANDExprNoBF
    : EqualityExprNoBF { $$ = $1 }
    | BitwiseANDExprNoBF '&' EqualityExpr { $$ = expNode($1, $3, 'bitwise_exp', '&') }
    ;

BitwiseXORExpr
    : BitwiseANDExpr { $$ = $1 }
    | BitwiseXORExpr '^' BitwiseANDExpr { $$ = expNode($1, $3, 'bitwise_exp', '^') }
    ;

BitwiseXORExprNoIn
    : BitwiseANDExprNoIn { $$ = $1 }
    | BitwiseXORExprNoIn '^' BitwiseANDExprNoIn { $$ = expNode($1, $3, 'bitwise_exp', '^') }
    ;

BitwiseXORExprNoBF
    : BitwiseANDExprNoBF { $$ = $1 }
    | BitwiseXORExprNoBF '^' BitwiseANDExpr { $$ = expNode($1, $3, 'bitwise_exp', '^') }
    ;

BitwiseORExpr
    : BitwiseXORExpr { $$ = $1 }
    | BitwiseORExpr '|' BitwiseXORExpr { $$ = expNode($1, $3, 'bitwise_exp', '|') }
    ;

BitwiseORExprNoIn
    : BitwiseXORExprNoIn { $$ = $1 }
    | BitwiseORExprNoIn '|' BitwiseXORExprNoIn { $$ = expNode($1, $3, 'bitwise_exp', '|') }
    ;

BitwiseORExprNoBF
    : BitwiseXORExprNoBF { $$ = $1 }
    | BitwiseORExprNoBF '|' BitwiseXORExpr { $$ = expNode($1, $3, 'bitwise_exp', '|') }
    ;

LogicalANDExpr
    : BitwiseORExpr { $$ = $1 }
    | LogicalANDExpr '&&' BitwiseORExpr { $$ = expNode($1, $3, 'logical_exp', '&&') }
    ;

LogicalANDExprNoIn
    : BitwiseORExprNoIn { $$ = $1 }
    | LogicalANDExprNoIn '&&' BitwiseORExprNoIn { $$ = expNode($1, $3, 'logical_exp', '&&') }
    ;

LogicalANDExprNoBF
    : BitwiseORExprNoBF { $$ = $1 }
    | LogicalANDExprNoBF '&&' BitwiseORExpr { $$ = expNode($1, $3, 'logical_exp', '&&') }
    ;

LogicalORExpr 
    : LogicalANDExpr { $$ = $1 }
    | LogicalORExpr '||' LogicalANDExpr { $$ = expNode($1, $3, 'logical_exp', '||') }
    ;

LogicalORExprNoIn
    : LogicalANDExprNoIn { $$ = $1 }
    | LogicalORExprNoIn '||' LogicalANDExprNoIn { $$ = expNode($1, $3, 'logical_exp', '||') }
    ;

LogicalORExprNoBF
    : LogicalANDExprNoBF { $$ = $1 }
    | LogicalORExprNoBF '||' LogicalANDExpr { $$ = expNode($1, $3, 'logical_exp', '||') }
    ;

ConditionalExpr
    : LogicalORExpr { $$ = $1 }
    | LogicalORExpr '?' AssignmentExpr ':' AssignmentExpr 
    { $$ = ternaryNode('ternary_exp', $1, $3, $5) }
    ;

ConditionalExprNoIn
    : LogicalORExprNoIn { $$ = $1 }
    | LogicalORExprNoIn '?' AssignmentExprNoIn ':' AssignmentExprNoIn 
    { $$ = ternaryNode('ternary_exp', $1, $3, $5) }
    ;

ConditionalExprNoBF
    : LogicalORExprNoBF { $$ = $1 }
    | LogicalORExprNoBF '?' AssignmentExpr ':' AssignmentExpr 
    { $$ = ternaryNode('ternary_exp', $1, $3, $5) }
    ;

AssignmentExpr
    : ConditionalExpr { $$ = $1 }
    | LeftHandSideExpr AssignmentOperator AssignmentExpr { $$ = expNode($1, $3, 'assign_exp', '=') }
    ;

AssignmentExprNoIn
    : ConditionalExprNoIn { $$ = $1 }
    | LeftHandSideExpr AssignmentOperator AssignmentExprNoIn { $$ = expNode($1, $3, 'assign_exp', '=') }
    ;

AssignmentExprNoBF
    : ConditionalExprNoBF { $$ = $1 }
    | LeftHandSideExprNoBF AssignmentOperator AssignmentExpr { $$ = expNode($1, $3, 'assign_exp', '=') }
    ;

AssignmentOperator
    : '='
    | PLUSEQUAL
    | MINUSEQUAL
    | MULTEQUAL
    | DIVEQUAL
    | LSHIFTEQUAL
    | RSHIFTEQUAL
    | URSHIFTEQUAL
    | ANDEQUAL
    | XOREQUAL
    | OREQUAL
    | MODEQUAL
    ;

Expr
    : AssignmentExpr { $$ = $1 }
    | Expr ',' AssignmentExpr { $$ = $1; $$.push($3); }
    ;

ExprNoIn
    : AssignmentExprNoIn { $$ = $1 }
    | ExprNoIn ',' AssignmentExprNoIn { $$ = $1; $$.push($3); }
    ;

ExprNoBF
    : AssignmentExprNoBF { $$ = $1 }
    | ExprNoBF ',' AssignmentExpr { $$ = $1; $$.push($3); }
    ;

Statement
    : Block
    | VariableStatement { $$ = ["varStmt", $1 ] } //done
    | ConstStatement { $$ = ["constStmt", $1 ] } // done
    | FunctionDeclaration { $$ = ["functionStmt", $1 ] } //done
    | EmptyStatement { $$ = ["emptyStmt"] } //done
    | ExprStatement { $$ = ["exprStmt", $1 ] }
    | IfStatement { $$ = ["ifStmt", $1 ] }
    | IterationStatement { $$ = ["iterStmt", $1 ] } // done
    | ContinueStatement { $$ = ["continueStmt"] } //done
    | BreakStatement { $$ = ["breakStmt"] } //done
    | ReturnStatement { $$ = ["returnStmt", $1 ] } // done
    | WithStatement { $$ = ["withStmt", $1 ] }
    | SwitchStatement { $$ = ["switchStmt", $1 ] }
    | LabelledStatement { $$ = ["labelledStmt", $1 ] }
    | ThrowStatement { $$ = ["throwStmt", $1 ] }
    | TryStatement { $$ = ["tryStmt", $1 ] }
    | DebuggerStatement { $$ = ["debuggerStmt", $1 ] }
    ;

Block
    : OPENBRACE CLOSEBRACE { $$ = null }
    | OPENBRACE SourceElements CLOSEBRACE { $$ = $2; }
    ;

VariableStatement
    : VAR VariableDeclarationList SEMICOLON %{ $$ = $2; %}
    | VAR VariableDeclarationList error 
    ;

VariableDeclarationList
    : IDENT 
	{ 
		$$ = [newId($IDENT)]; 
	}
    | IDENT Initializer  
	{ 
		$$ = [newId($IDENT, $Initializer)]; 
	}
    | VariableDeclarationList ',' IDENT 
	{ 
		$$ = $VariableDeclarationList;
		$$.push(newId($IDENT))
	}
    | VariableDeclarationList ',' IDENT Initializer
	{
		$$ = $VariableDeclarationList;
		$$.push(newId($IDENT, $Initializer));
	}
    ;

VariableDeclarationListNoIn
    : IDENT
    { 
		$$ = [newId($IDENT)]; 
	}
    | IDENT InitializerNoIn
    { 
		$$ = [newId($IDENT, $InitializerNoIn)]; 
	}
    | VariableDeclarationListNoIn ',' IDENT
    { 
		$$ = $VariableDeclarationListNoIn;
		$$.push(newId($IDENT))
	}
    | VariableDeclarationListNoIn ',' IDENT InitializerNoIn
    {
		$$ = $VariableDeclarationListNoIn;
		$$.push(newId($IDENT, $InitializerNoIn));
	}
    ;

ConstStatement
    : CONSTTOKEN ConstDeclarationList SEMICOLON { $$ = $ConstDeclarationList }
    | CONSTTOKEN ConstDeclarationList error { $$ = 'yeah bro' }
    ;

ConstDeclarationList
    : ConstDeclaration { $$ = [$ConstDeclaration] }
    | ConstDeclarationList ',' ConstDeclaration
	{
		$$ = $ConstDeclarationList;
		$$.push($ConstDeclaration)
	}
    ;

ConstDeclaration
    // : IDENT
    // | IDENT Initializer
    : IDENT Initializer
	{ 
		$$ = newId($IDENT, $Initializer)
	}
    ;

Initializer
    : '=' AssignmentExpr { $$ = $2 }
    ;

InitializerNoIn
    : '=' AssignmentExprNoIn { $$ = $2 }
    ;

EmptyStatement
    : SEMICOLON
    ;

ExprStatement
    : ExprNoBF SEMICOLON { $$ = $1 }
    | ExprNoBF error
    ;

IfStatement
    : IF '(' Expr ')' Statement %prec IF_WITHOUT_ELSE
    | IF '(' Expr ')' Statement ELSE Statement
    ;

IterationStatement
    : DO Statement WHILE '(' Expr ')' SEMICOLON 
	{ $$ = loopNode('do_while', null, null, $Expr, $Statement) }
    | DO Statement WHILE '(' Expr ')' error
    | WHILE '(' Expr ')' Statement 
	{ $$ = loopNode('while', null, null, $Expr, $Statement) }
    | FOR '(' ExprNoInOpt SEMICOLON ExprOpt SEMICOLON ExprOpt ')' Statement 
	{ $$ = loopNode('for', $3, $5, $7, $9) }
    | FOR '(' VAR VariableDeclarationListNoIn SEMICOLON ExprOpt SEMICOLON ExprOpt ')' Statement 
    | FOR '(' LeftHandSideExpr INTOKEN Expr ')' Statement 
	{ $$ = rangeloopNode('rangeloop', $3, $5, $7) }
    | FOR '(' VAR IDENT INTOKEN Expr ')' Statement 
	{ $$ = rangeloopNode('rangeloop', newId($IDENT, null), $Expr, $Statement) }
    | FOR '(' VAR IDENT InitializerNoIn INTOKEN Expr ')' Statement 
	{ $$ = rangeloopNode('rangeloop', newId($IDENT, $5), $Expr, $Statement) }
    ;

ExprOpt
    : 
    | Expr
    ;

ExprNoInOpt
    : 
    | ExprNoIn
    ;

ContinueStatement
    : CONTINUE SEMICOLON { $$ = $1 }
    | CONTINUE error
    | CONTINUE IDENT SEMICOLON
    | CONTINUE IDENT error
    ;

BreakStatement
    : BREAK SEMICOLON { $$ = $1 }
    | BREAK error
    | BREAK IDENT SEMICOLON
    | BREAK IDENT error
    ;

ReturnStatement
    : RETURN SEMICOLON { $$ = null }
    | RETURN error
    | RETURN Expr SEMICOLON { $$ = $Expr } // pending
    | RETURN Expr error
    ;

WithStatement
    : WITH '(' Expr ')' Statement
    ;

SwitchStatement
    : SWITCH '(' Expr ')' CaseBlock
    ;

CaseBlock
    : OPENBRACE CaseClausesOpt CLOSEBRACE
    | OPENBRACE CaseClausesOpt DefaultClause CaseClausesOpt CLOSEBRACE
    ;

CaseClausesOpt
    : 
    | CaseClauses
    ;

CaseClauses
    : CaseClause
    | CaseClauses CaseClause
    ;

CaseClause
    : CASE Expr ':'
    | CASE Expr ':' SourceElements
    ;

DefaultClause
    : DEFAULT ':'
    | DEFAULT ':' SourceElements
    ;

LabelledStatement
    : IDENT ':' Statement
    ;

ThrowStatement
    : THROW Expr SEMICOLON
    | THROW Expr error
    ;

TryStatement
    : TRY Block FINALLY Block
    | TRY Block CATCH '(' IDENT ')' Block
    | TRY Block CATCH '(' IDENT ')' Block FINALLY Block
    ;

DebuggerStatement
    : DEBUGGER SEMICOLON
    | DEBUGGER error
    ;

FunctionDeclaration
    : FUNCTION IDENT '(' ')' OPENBRACE FunctionBody CLOSEBRACE
	{ $$ = funcNode($IDENT, $FunctionBody, null) }
    | FUNCTION IDENT '(' FormalParameterList ')' OPENBRACE FunctionBody CLOSEBRACE
	{ $$ = funcNode($IDENT, $FunctionBody, $FormalParameterList) }
    ;

FunctionExpr
    : FUNCTION '(' ')' OPENBRACE FunctionBody CLOSEBRACE
    | FUNCTION '(' FormalParameterList ')' OPENBRACE FunctionBody CLOSEBRACE
    | FUNCTION IDENT '(' ')' OPENBRACE FunctionBody CLOSEBRACE
    | FUNCTION IDENT '(' FormalParameterList ')' OPENBRACE FunctionBody CLOSEBRACE
    ;

FormalParameterList
    : IDENT { $$ = [$IDENT] }
    | FormalParameterList ',' IDENT
	{ $$ = $FormalParameterList; $$.push($IDENT); }
    ;

FunctionBody
    : 
    | SourceElements
    ;

Program
    : 
    | SourceElements EOF { return $SourceElements; }
    ;

SourceElements
    : Statement { $$ = [$Statement]; }
    | SourceElements Statement { $$ = $SourceElements; $$.push($Statement); }
    ;