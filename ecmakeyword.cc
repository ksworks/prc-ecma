/*********************************************************************
 * @file	ecmakeyword.cc
 * @brief	ECMA Script(ECMA-262) Keyword utility.
 * 		License under NYSL Version 0.9982.
 * @author	ksworks
 * $Revision$
 * $Date$
 */
#include <string.h>

#include "comutil.h"
#include "ecmacontext.h"
#include "ecmakeyword.h"

/* ECMA-262 7.6.1.2 Future Reserved Words */
static const char *future_reserved[] = 
{
  "class", "enum", "extends", "super",
  "const", "export", "import",
};

/* The following tokens are also considered to be
   FutureReservedWords when they occur within strict
   mode code (see 10.1.1). */
static const char *strict_reserved[] =
{
  "implements", "let", "private", "public", "yield",
  "interface", "package", "protected", "static",
};


/**
 *
 *
 *
 *
 *
 */
int
LGK_isReserved (ECMACTX *ctx, const char *identifier)
{
  /* Keyword, NullLiteral, BooleanLiteral are
     avoided by Lexer's pre-processing.
     so, check only FutureReserved words. */

  for (int i=0; i<countof(future_reserved); ++i)
    if (::strcmp (future_reserved[i], identifier))
      return 1;

  /* only strict mode's reserved word. */
  if (ctx->strict)
    for (int i=0; i<countof(strict_reserved); ++i)
      if (::strcmp (strict_reserved[i], identifier))
	return 2;
  return 0;
}
