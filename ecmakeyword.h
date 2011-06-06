/*********************************************************************
 * @file	ecmakeyword.h
 * @brief	ECMA Script(ECMA-262) Keyword utility.
 *		Internal(lex/yacc) Interface Define [LGK].
 * 		License under NYSL Version 0.9982.
 * @author	ksworks
 * $Revision$
 * $Date$
 */
#if !defined ECMAKEYWORD_H_DECLARED
#define ECMAKEYWORD_H_DECLARED

#if defined __cplusplus
extern "C" {
#endif // defined __cplusplus

int LGK_isReserved (ECMACTX *ctx, const char *identifier);

#if defined __cplusplus
}
#endif // defined __cplusplus

#endif // !defined ECMAKEYWORD_H_DECLARED
