/*********************************************************************
 * @file	ecmalex.l
 * @brief	ECMA Script(ECMA-262) Lexical Parser.
 * 		License under NYSL Version 0.9982.
 * @author	ksworks
 * $Revision$
 * $Date$
 */
%{
#include "ecmayacc.h"
%}
%option nostdinit never-interactive noyywrap

WhiteSpace	[\t\v\f ]	/* ECMA-262 7.2 */
LineTerminator	[\r\n]		/* ECMA-262 7.3 */
%%

 /* EMCA-262 7.6.1.1 */
<INITIAL>"break"	return EK_BREAK;
<INITIAL>"case"		return EK_CASE;
<INITIAL>"catch"	return EK_CATCH;
<INITIAL>"continue"	return EK_CONTINUE;
<INITIAL>"debugger"	return EK_DEBUGGER;
<INITIAL>"default"	return EK_DEFAULT;
<INITIAL>"delete"	return EK_DELETE;
<INITIAL>"do"		return EK_DO;
<INITIAL>"else"		return EK_ELSE;
<INITIAL>"finally"	return EK_FINALLY;
<INITIAL>"for"		return EK_FOR;
<INITIAL>"function"	return EK_FUNCTION;
<INITIAL>"if"		return EK_IF;
<INITIAL>"in"		return EK_IN;
<INITIAL>"instanceof"	return EK_INSTANCEOF;
<INITIAL>"new"		return EK_NEW;
<INITIAL>"return"	return EK_RETURN;
<INITIAL>"switch"	return EK_SWITCH;
<INITIAL>"this"		return EK_THIS;
<INITIAL>"throw"	return EK_THROW;
<INITIAL>"try"		return EK_TYPEOF;
<INITIAL>"var"		return EK_VAR;
<INITIAL>"void"		return EK_VOID;
<INITIAL>"while"	return EK_WHILE;
<INITIAL>"with"		return EK_WITH;

 /* ECMA-262 7.7 */
<INITIAL>"<="		return EP_GTEQ;
<INITIAL>">="		return EP_LTEQ;
<INITIAL>"=="		return EP_EQUAL;
<INITIAL>"!="		return EP_NOTEQ;
<INITIAL>"==="		return EP_SEQUAL;
<INITIAL>"!=="		return EP_SNOTEQ;
<INITIAL>"++"		return EP_INCRE;
<INITIAL>"--"		return EP_DECRE;
<INITIAL>"<<"		return EP_LBS;
<INITIAL>">>"		return EP_RBS;
<INITIAL>">>>"		return EP_URBS;
<INITIAL>"&&"		return EP_AND;
<INITIAL>"||"		return EP_OR;
<INITIAL>"+="		return EP_ADDEQ;
<INITIAL>"-="		return EP_SUBEQ;
<INITIAL>"*="		return EP_MULEQ;
<INITIAL>"%="		return EP_MODEQ;
<INITIAL>"<<="		return EP_LBSEQ;
<INITIAL>">>="		return EP_RBSEQ;
<INITIAL>">>>="		return EP_URBSEQ;
<INITIAL>"&="		return EP_ANDEQ;
<INITIAL>"|="		return EP_OREQ;
<INITIAL>"^="		return EP_XOREQ;
<INITIAL>"/="		return EP_DIVEQ;

<INITIAL>"="		|
<INITIAL>"?"		|
<INITIAL>":"		|
<INITIAL>"|"		|
<INITIAL>"^"		|
<INITIAL>"&"		|
<INITIAL>"<"		|
<INITIAL>">"		|
<INITIAL>"+"		|
<INITIAL>"-"		|
<INITIAL>"*"		|
<INITIAL>"/"		|
<INITIAL>"%"		|
<INITIAL>"~"		|
<INITIAL>"!"		|
<INITIAL>"("		|
<INITIAL>")"		|
<INITIAL>","		return yytext[0];

 /* ECMA-262 7.8.1 */
<INITIAL>"null"		return NullLiteral;

 /* ECMA-262 7.8.2 */
<INITIAL>"true"		return BooleanLiteral;
<INITIAL>"false"	return BooleanLiteral;

 /* ECMA-262 7.8.3 */
<INITIAL>[1-9][0-9]* {
	return NumericLiteral;
 }


%%
