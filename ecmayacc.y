/*********************************************************************
 * @file	ecmayacc.y
 * @brief	ECMA Script(ECMA-262) Grammer Parser.
 * 		License under NYSL Version 0.9982.
 * @author	ksworks
 * $Revision$
 * $Date$
 */
%{
#include "ecmacontext.h"
#include "ecmakeyword.h"
%}
%union {
  void *ident;
  void *literal;
  void *expr;
  void *array;
  void *elemlist;
  void *elision;
  void *objects;
  void *property;
  void *args;
  int oper;
  void *stmt;
  void *vardecl;
  void *cases;
}
%token	EK_THIS EK_GET EK_SET EK_NEW EK_DELETE EK_VOID
	EK_TYPEOF EK_INSTANCEOF EK_IN EK_VAR EK_IF EK_ELSE
	EK_DO EK_WHILE EK_FOR EK_CONTINUE EK_BREAK EK_RETURN
	EK_WITH EK_SWITCH EK_CASE EK_DEFAULT EK_THROW EK_TRY
	EK_CATCH EK_FINALLY EK_DEBUGGER EK_FUNCTION
	EP_INCRE EP_DECRE EP_LBS EP_RBS EP_URBS EP_GTEQ EP_LTEQ
	EP_EQUAL EP_NOTEQ EP_SEQUAL EP_SNOTEQ EP_AND EP_OR
%token <oper> EP_MULEQ EP_DIVEQ EP_MODEQ EP_ADDEQ EP_SUBEQ
	EP_LBSEQ EP_RBSEQ EP_URBSEQ EP_ANDEQ EP_OREQ EP_XOREQ
%token <ident> IdentifierName
%token <literal> NullLiteral BooleanLiteral NumericLiteral StringLiteral

%type <ident> Identifier Identifieropt
%type <expr> PrimaryExpression MemberExpression NewExpression
	CallExpression LeftHandSideExpression PostfixExpression
	UnaryExpression MultiplicativeExpression AdditiveExpression
	ShiftExpression RelationalExpression RelationalExpressionNoIn
	EqualityExpression EqualityExpressionNoIn BitwiseANDExpression
	BitwiseANDExpressionNoIn BitwiseXORExpression BitwiseXORExpressionNoIn
	BitwiseORExpression BitwiseORExpressionNoIn LogicalANDExpression
	LogicalANDExpressionNoIn LogicalORExpression LogicalORExpressionNoIn
	ConditionalExpression ConditionalExpressionNoIn AssignmentExpression
	AssignmentExpressionNoIn Expression ExpressionNoIn FunctionExpression
	Expressionopt ExpressionNoInopt
%type <array> ArrayLiteral
%type <elemlist> ElementList
%type <elision> Elision Elisionopt
%type <objects> ObjectLiteral
%type <property> PropertyNameAndValueList PropertyAssignment PropertyName
      PropertySetParameterList
%type <args> Arguments ArgumentList FormalParameterListopt FormalParameterList
%type <oper> AssignmentOperator
%type <stmt> Statement Block StatementList StatementListopt VariableStatement
	Initialiser Initialiseropt InitialiserNoIn InitialiserNoInopt
	EmptyStatement ExpressionStatement IfStatement IterationStatement
	ContinueStatement BreakStatement ReturnStatement WithStatement
	SwitchStatement LabelledStatement ThrowStatement TryStatement
	Catch Finally DebuggerStatement FunctionDeclaration FunctionBody
	Program SourceElements SourceElement
%type <vardecl> VariableDeclarationList VariableDeclarationListNoIn
	VariableDeclaration VariableDeclarationNoIn
%type <cases> CaseBlock CaseClauses CaseClausesopt CaseClause DefaultClause

%%

/* ECMA-262 A.1 Lexical Grammar (part) */
Identifier
	: IdentifierName
	{
	  /* [but not ReservedWord] */
	  if (LGK_isReserved (TODO, $1))
	    YYABORT;
	  $$ = $1;
	}
	;
Literal
	: NullLiteral
	{}
	| BooleanLiteral
	{}
	| NumericLiteral
	{}
	| StringLiteral
	{}
	;

/* ECMA-262 A.3 Expressions */
PrimaryExpression
	: EK_THIS
	{}
	| Identifier
	{}
	| Literal
	{}
	| ArrayLiteral
	{}
	| ObjectLiteral
	{}
	| '(' Expression ')'
	{ $$ = $2; }
	;
ArrayLiteral
	: '[' Elisionopt ']'
	{}
	| '[' ElementList ']'
	{}
	| '[' ElementList ',' Elisionopt ']'
	{}
	;
ElementList
	: Elisionopt AssignmentExpression
	{}
	| ElementList ',' Elisionopt AssignmentExpression
	{}
	;
Elisionopt
	:
	{ $$ = NULL; }
	| Elision
	{}
	;
Elision
	: ','
	{}
	| Elision ','
	{}
	;
ObjectLiteral
	: '{' '}'
	{}
	| '{' PropertyNameAndValueList '}'
	{}
	| '{' PropertyNameAndValueList ',' '}'
	{}
	;
PropertyNameAndValueList
	: PropertyAssignment
	{}
	| PropertyNameAndValueList ',' PropertyAssignment
	{}
	;
PropertyAssignment
	: PropertyName ':' AssignmentExpression
	{}
	| EK_GET PropertyName '(' ')' '{' FunctionBody '}'
	{}
	| EK_SET PropertyName '(' PropertySetParameterList ')' '{' FunctionBody '}'
	{}
	;
PropertyName
	: IdentifierName
	{}
	| StringLiteral
	{}
	| NumericLiteral
	{}
	;
PropertySetParameterList
	: Identifier
	{}
	;
MemberExpression
	: PrimaryExpression
	| FunctionExpression
	| MemberExpression '[' Expression ']'
	{}
	| MemberExpression '.' IdentifierName
	{}
	| EK_NEW MemberExpression Arguments
	{}
	;
NewExpression
	: MemberExpression
	| EK_NEW NewExpression
	{}
	;
CallExpression
	: MemberExpression Arguments
	{}
	| CallExpression Arguments
	{}
	| CallExpression '[' Expression ']'
	{}
	| CallExpression '.' IdentifierName
	{}
	;
Arguments
	: '(' ')'
	{ $$ = NULL; }
	| '(' ArgumentList ')'
	{ $$ = $2; }
	;
ArgumentList
	: AssignmentExpression
	{}
	| ArgumentList ',' AssignmentExpression
	{}
	;
LeftHandSideExpression
	: NewExpression
	| CallExpression
	;
PostfixExpression
	: LeftHandSideExpression
	| LeftHandSideExpression EP_INCRE
	{ /* [no LineTerminator here] */ }
	| LeftHandSideExpression EP_DECRE
	{ /* [no LineTerminator here] */ }
	;
UnaryExpression
	: PostfixExpression
	| EK_DELETE UnaryExpression
	{}
	| EK_VOID UnaryExpression
	{}
	| EK_TYPEOF UnaryExpression
	{}
	| EP_INCRE UnaryExpression
	{}
	| EP_DECRE UnaryExpression
	{}
	| '+' UnaryExpression
	{}
	| '-' UnaryExpression
	{}
	| '~' UnaryExpression
	{}
	| '!' UnaryExpression
	{}
	;
MultiplicativeExpression
	: UnaryExpression
	| MultiplicativeExpression '*' UnaryExpression
	{}
	| MultiplicativeExpression '/' UnaryExpression
	{}
	| MultiplicativeExpression '%' UnaryExpression
	{}
AdditiveExpression
	: MultiplicativeExpression
	| AdditiveExpression '+' MultiplicativeExpression
	{}
	| AdditiveExpression '-' MultiplicativeExpression
	{}
	;
ShiftExpression
	: AdditiveExpression
	| ShiftExpression EP_LBS AdditiveExpression
	{}
	| ShiftExpression EP_RBS AdditiveExpression
	{}
	| ShiftExpression EP_URBS AdditiveExpression
	{}
	;
RelationalExpression
	: ShiftExpression
	| RelationalExpression '<' ShiftExpression
	{}
	| RelationalExpression '>' ShiftExpression
	{}
	| RelationalExpression EP_GTEQ ShiftExpression
	{}
	| RelationalExpression EP_LTEQ ShiftExpression
	{}
	| RelationalExpression EK_INSTANCEOF ShiftExpression
	{}
	| RelationalExpression EK_IN ShiftExpression
	;
RelationalExpressionNoIn
	 : ShiftExpression
	 | RelationalExpressionNoIn '<' ShiftExpression
	{}
	 | RelationalExpressionNoIn '>' ShiftExpression
	{}
	 | RelationalExpressionNoIn EP_GTEQ ShiftExpression
	{}
	 | RelationalExpressionNoIn EP_LTEQ ShiftExpression
	{}
	 | RelationalExpressionNoIn EK_INSTANCEOF ShiftExpression
	{}
	 ;
EqualityExpression
	: RelationalExpression
	| EqualityExpression EP_EQUAL RelationalExpression
	{}
	| EqualityExpression EP_NOTEQ RelationalExpression
	{}
	| EqualityExpression EP_SEQUAL RelationalExpression
	{}
	| EqualityExpression EP_SNOTEQ RelationalExpression
	{}
	;
EqualityExpressionNoIn
	: RelationalExpressionNoIn
	| EqualityExpressionNoIn EP_EQUAL RelationalExpressionNoIn
	{}
	| EqualityExpressionNoIn EP_NOTEQ RelationalExpressionNoIn
	{}
	| EqualityExpressionNoIn EP_SEQUAL RelationalExpressionNoIn
	{}
	| EqualityExpressionNoIn EP_SNOTEQ RelationalExpressionNoIn
	{}
	;
BitwiseANDExpression
	: EqualityExpression
	| BitwiseANDExpression '&' EqualityExpression
	{}
	;
BitwiseANDExpressionNoIn
	: EqualityExpressionNoIn
	| BitwiseANDExpressionNoIn '&' EqualityExpressionNoIn
	{}
	;
BitwiseXORExpression
	: BitwiseANDExpression
	| BitwiseXORExpression '^' BitwiseANDExpression
	{}
	;
BitwiseXORExpressionNoIn
	: BitwiseANDExpressionNoIn
	| BitwiseXORExpressionNoIn '^' BitwiseANDExpressionNoIn
	{}
	;
BitwiseORExpression
	: BitwiseXORExpression
	| BitwiseORExpression '|' BitwiseXORExpression
	{}
	;
BitwiseORExpressionNoIn
	: BitwiseXORExpressionNoIn
	| BitwiseORExpressionNoIn '|' BitwiseXORExpressionNoIn
	{}
	;
LogicalANDExpression
	: BitwiseORExpression
	| LogicalANDExpression EP_AND BitwiseORExpression
	{}
	;
LogicalANDExpressionNoIn
	: BitwiseORExpressionNoIn
	| LogicalANDExpressionNoIn EP_AND BitwiseORExpressionNoIn
	{}
	;
LogicalORExpression
	: LogicalANDExpression
	| LogicalORExpression EP_OR LogicalANDExpression
	{}
	;
LogicalORExpressionNoIn
	: LogicalANDExpressionNoIn
	| LogicalORExpressionNoIn EP_OR LogicalANDExpressionNoIn
	{}
	;
ConditionalExpression
	: LogicalORExpression
	| LogicalORExpression '?' AssignmentExpression ':' AssignmentExpression
	{}
	;
ConditionalExpressionNoIn
	: LogicalORExpressionNoIn
	| LogicalORExpressionNoIn '?' AssignmentExpressionNoIn ':' AssignmentExpressionNoIn
	{}
	;
AssignmentExpression
	: ConditionalExpression
	| LeftHandSideExpression AssignmentOperator AssignmentExpression
	{}
	;
AssignmentExpressionNoIn
	: ConditionalExpressionNoIn
	| LeftHandSideExpression AssignmentOperator AssignmentExpressionNoIn
	{}
	;
AssignmentOperator
	: '='
	{}
	| EP_MULEQ
	| EP_DIVEQ
	| EP_MODEQ
	| EP_ADDEQ
	| EP_SUBEQ
	| EP_LBSEQ
	| EP_RBSEQ
	| EP_URBSEQ
	| EP_ANDEQ
	| EP_OREQ
	| EP_XOREQ
	;
Expression
	: AssignmentExpression
	| Expression ',' AssignmentExpression
	{}
	;
ExpressionNoIn
	: AssignmentExpressionNoIn
	| ExpressionNoIn ',' AssignmentExpressionNoIn
	{}
	;


/* ECMA-262 A.4 Statements */
Statement
	: Block
	| VariableStatement
	| EmptyStatement
	| ExpressionStatement
	{ /* [[lookahead ∉ {{, function}] */ }
	| IfStatement
	| IterationStatement
	| ContinueStatement
	| BreakStatement
	| ReturnStatement
	| WithStatement
	| LabelledStatement
	| SwitchStatement
	| ThrowStatement
	| TryStatement
	| DebuggerStatement
	;
Block
	: '{' StatementListopt '}'
	{}
	;
StatementListopt
	:
	{ $$ = NULL; }
	| StatementList
	;
StatementList
	: Statement
	| StatementList Statement
	{}
	;
VariableStatement
	: EK_VAR VariableDeclarationList ';'
	{}
	;
VariableDeclarationList
	: VariableDeclaration
	| VariableDeclarationList ',' VariableDeclaration
	{}
	;
VariableDeclarationListNoIn
	: VariableDeclarationNoIn
	| VariableDeclarationListNoIn ',' VariableDeclarationNoIn
	;
VariableDeclaration
	: Identifier Initialiseropt
	{}
	;
VariableDeclarationNoIn
	: Identifier InitialiserNoInopt
	{}
	;
Initialiseropt
	:
	{ $$ = NULL; }
	| Initialiser
	;
Initialiser
	: '=' AssignmentExpression
	{}
	;
InitialiserNoInopt
	:
	{ $$ = NULL; }
	| InitialiserNoIn
	;
InitialiserNoIn
	: '=' AssignmentExpressionNoIn
	{}
	;
EmptyStatement
	: ';'
	{ $$ = NULL; }
	;
ExpressionStatement
	: Expression ';'
	{}
	;
IfStatement
	: EK_IF '(' Expression ')' Statement EK_ELSE Statement
	{}
	| EK_IF '(' Expression ')' Statement
	{}
	;
IterationStatement
	: EK_DO Statement EK_WHILE '(' Expression ')' ';'
	{}
	| EK_WHILE '(' Expression ')' Statement
	{}
	| EK_FOR '(' ExpressionNoInopt ';' Expressionopt ';' Expressionopt ')' Statement
	{}
	| EK_FOR '(' EK_VAR VariableDeclarationListNoIn ';' Expressionopt ';' Expressionopt ')' Statement
	{}
	| EK_FOR '(' LeftHandSideExpression EK_IN Expression ')' Statement
	{}
	| EK_FOR '(' EK_VAR VariableDeclarationNoIn EK_IN Expression ')' Statement
	{}
	;
Expressionopt
	:
	{ $$ = NULL; }
	| Expression
	;
ExpressionNoInopt
	:
	{ $$ = NULL; }
	| ExpressionNoIn
	;
Identifieropt
	:
	{ $$ = NULL; }
	| Identifier
	;
ContinueStatement
	: EK_CONTINUE Identifieropt ';'
	{ /* [no LineTerminator here] */ }
	;
BreakStatement
	: EK_BREAK Identifieropt ';'
	{ /* [no LineTerminator here] */ }
	;
ReturnStatement
	: EK_RETURN Expressionopt ';'
	{ /* [no LineTerminator here] */ }
	;
WithStatement
	: EK_WITH '(' Expression ')' Statement
	{}
	;
SwitchStatement
	: EK_SWITCH '(' Expression ')' CaseBlock
	{}
	;
CaseBlock
	: '{' CaseClausesopt '}'
	{}
	| '{' CaseClausesopt DefaultClause CaseClausesopt '}'
	{}
	;
CaseClausesopt
	:
	{ $$ = NULL; }
	| CaseClauses
	;
CaseClauses
	: CaseClause
	{}
	| CaseClauses CaseClause
	{}
	;
CaseClause
	: EK_CASE Expression ':' StatementListopt
	{}
	;
DefaultClause
	: EK_DEFAULT ':' StatementListopt
	{}
	;
LabelledStatement
	: Identifier ':' Statement
	{}
	;
ThrowStatement
	: EK_THROW Expression ';'
	{ /* [no LineTerminator here] */ }
	;
TryStatement
	: EK_TRY Block Catch
	{}
	| EK_TRY Block Finally
	{}
	| EK_TRY Block Catch Finally
	{}
	;
Catch
	: EK_CATCH '(' Identifier ')' Block
	{}
	;
Finally
	: EK_FINALLY Block
	{}
	;
DebuggerStatement
	: EK_DEBUGGER ';'
	{}
	;

/* ECMA-262 A.5 Functions and Programs */
FunctionDeclaration
	: EK_FUNCTION Identifier FormalParameterListopt '{' FunctionBody '}'
	{}
	;
FunctionExpression
	: EK_FUNCTION FormalParameterListopt '{' FunctionBody '}'
	{}
	| EK_FUNCTION Identifier FormalParameterListopt '{' FunctionBody '}'
	{}
	;
FormalParameterListopt
	: '(' ')'
	{ $$ = NULL; }
	| '(' FormalParameterList ')'
	{}
	;
FormalParameterList
	: Identifier
	{}
	| FormalParameterList ',' Identifier
	{}
	;
FunctionBody
	:
	{ $$ = NULL; }
	| SourceElements
	{}
	;
Program
	: 
	{ $$ = NULL; }
	| SourceElements
	{}
	;
SourceElements
	: SourceElement
	{}
	| SourceElements SourceElement
	{}
	;
SourceElement
	: Statement
	{}
	| FunctionDeclaration
	;
