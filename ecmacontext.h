/*********************************************************************
 * @file	ecmacontext.h
 * @brief	ECMA Script(ECMA-262) Parser context Define.
 * 		License under NYSL Version 0.9982.
 * @author	ksworks
 * $Revision$
 * $Date$
 */
#if !defined ECMACONTEXT_H_DECLARED
#define ECMACONTEXT_H_DECLARED

#if defined __cplusplus
extern "C" {
#endif // defined __cplusplus

/**
 *
 */
typedef struct ECMACTX
{
  int		strict; //!< parser setting [strict mode].
} ECMACTX;


  // とりあえず
#define TODO NULL
#define NULL 0


#if defined __cplusplus
}
#endif // defined __cplusplus

#endif // !defined ECMACONTEXT_H_DECLARED
