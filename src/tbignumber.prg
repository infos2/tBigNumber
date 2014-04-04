/*                                                                         
 *  t    bbbb   iiiii  ggggg  n   n  u   u  mm mm  bbbb   eeeee  rrrr     
 * ttt   b   b    i    g      nn  n  u   u  mm mm  b   b  e      r   r    
 *  t    bbbb     i    g ggg  n n n  u   u  m m m  bbbb   eeee   rrrr     
 *  t t  b   b    i    g   g  n  nn  u   u  m m m  b   b  e      r   r    
 *  ttt  bbbbb  iiiii  ggggg  n   n  uuuuu  m   m  bbbbb  eeeee  r   r    
 *
 * Copyright 2013-2014 Marinaldo de Jesus <marinaldo\/.\/jesus\/@\/blacktdn\/.\/com\/.\/br>
 * www - http://www.blacktdn.com.br
 *
 * Harbour Project license:
 * www - http://harbour-project.org
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2, or (at your option)
 * any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this software; see the file COPYING.txt.  If not, write to
 * the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
 * Boston, MA 02111-1307 USA (or visit the web site http://www.gnu.org/).
 *
 * As a special exception, the Harbour Project gives permission for
 * additional uses of the text contained in its release of Harbour.
 *
 * The exception is that, if you link the Harbour libraries with other
 * files to produce an executable, this does not by itself cause the
 * resulting executable to be covered by the GNU General Public License.
 * Your use of that executable is in no way restricted on account of
 * linking the Harbour library code into it.
 *
 * This exception does not however invalidate any other reasons why
 * the executable file might be covered by the GNU General Public License.
 *
 * This exception applies only to the code released by the Harbour
 * Project under the name Harbour.  If you copy code from other
 * Harbour Project or Free Software Foundation releases into a copy of
 * Harbour, as the General Public License permits, the exception does
 * not apply to the code that you add in this way.  To avoid misleading
 * anyone as to the status of such modified files, you must delete
 * this exception notice from them.
 *
 * If you write modifications of your own for Harbour, it is your choice
 * whether to permit this exception to apply to your modifications.
 * If you do not wish that, delete this exception notice.
 *
 */
 
#include "tBigNumber.ch"

#ifdef __PROTHEUS__
    static __cEnvSrv
    #xtranslate hb_bLen([<prm,...>])    => Len([<prm>])
    #xtranslate tBIGNaLen([<prm,...>])  => Len([<prm>])
    #xtranslate hb_mutexCreate()        => ThreadID()
    #xtranslate hb_mutexLock(<p>)       => AllWaysTrue()
    #xtranslate hb_mutexUnLock(<p>)     => AllWaysTrue()
#else // __HARBOUR__
    /* Keeping it tidy */
    #pragma -w3
    #pragma -es2
    /* Optimizations */
    #pragma -km+
    #pragma -ko+
    /* Force HB_MT */
    #require "hbvmmt"
    request HB_MT
    #xtranslate PadL([<prm,...>])    => tBIGNPadL([<prm>])
    #xtranslate PadR([<prm,...>])    => tBIGNPadR([<prm>])
    #xtranslate SubStr([<prm,...>])  => hb_bSubStr([<prm>])
    #xtranslate AT([<prm,...>])      => hb_bAT([<prm>])
    #xtranslate Max([<prm,...>])     => tBIGNMax([<prm>])
    #xtranslate Min([<prm,...>])     => tBIGNMin([<prm>])
#endif //__PROTHEUS__

#xcommand IncZeros(<n>);
=>;
while <n> > thsnstcZ0;;
    thscstcZ0+=thscstcZ0;;
    thsnstcZ0+=thsnstcZ0;;
end while;;

#ifndef __DIVMETHOD__
    #define __DIVMETHOD__ 1
#endif

static __stkMutex:=hb_mutexCreate()

static __o0
static __o1
static __o2
static __o10
static __o20
static __od2
static __oMinFI
static __oMinGCD
static __nMinLCM
static __lstbNSet
static __nDivMeth
static __nthRootAcc
static __nDecimalSet

thread static thscstcZ0
thread static thsnstcZ0
thread static thscstcN9
thread static htsnstcN9

#ifdef TBN_ARRAY
    thread static thsaZAdd
    thread static thsaZSub
    thread static thsaZMult
#endif

#ifdef TBN_DBFILE
    thread static thsdFiles
#endif

thread static thseqN1
thread static thseqN2

thread static thsgtN1
thread static thsgtN2

thread static thsltN1
thread static thsltN2

thread static thscmpN1
thread static thscmpN2

thread static thsadNR
thread static thsadN1
thread static thsadN2

thread static thssbNR
thread static thssbN1
thread static thssbN2

thread static thsmtNR
thread static thsmtN1
thread static thsmtN2

thread static thsdvNR
thread static thsdvN1
thread static thsdvN2
thread static thsdvRDiv    

thread static thspwA
thread static thspwB
thread static thspwNP
thread static thspwNR
thread static thspwNT
thread static thspwGCD

#ifdef __PTCOMPAT__
thread static thseDivN
thread static thseDivD
#endif //__PTCOMPAT__
thread static thseDivR
thread static thseDivQ 
#ifdef __PTCOMPAT__
thread static thseDivDvQ
thread static thseDivDvR
#endif //__PTCOMPAT__

thread static thsSysSQRT

thread static thslsdSet

#define RANDOM_MAX_EXIT 5
#define EXIT_MAX_RANDOM 50

#define NTHROOT_EXIT    3
#define MAX_SYS_SQRT    "9999999999999999"
#define MAX_SYS_lMULT   "9999999999"
#define MAX_SYS_lADD    "99999999999999999"
#define MAX_SYS_lSUB    "99999999999999999"
#define MAX_SYS_iMULT   "999999999999999999"
#define MAX_SYS_GCD     MAX_SYS_iMULT
#define MAX_SYS_LCM     MAX_SYS_iMULT

#define MAX_SYS_FI      MAX_SYS_iMULT

/*
*    Alternative Compile Options: -d
*
*    #ifdef __PROTHEUS__
*        -dTBN_ARRAY
*        -dTBN_DBFILE 
*        -d__TBN_DYN_OBJ_SET__ 
*    #else //__HARBOUR__
*        -dTBN_ARRAY
*        -dTBN_DBFILE 
*        -dTBN_MEMIO 
*        -d__TBN_DYN_OBJ_SET__ 
*        -d__PTCOMPAT__
*    #endif
*/

/*
    Class       : tBigNumber
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Instancia um novo objeto do tipo BigNumber
    Sintaxe     : tBigNumber():New(uBigN) -> self
*/
CLASS tBigNumber

#ifndef __PROTHEUS__
    #ifndef __TBN_DYN_OBJ_SET__
        #ifndef __ALT_D__
            PROTECTED:
        #endif
    #endif
#endif
    /* Keep in alphabetical order */
    DATA cDec  AS CHARACTER INIT "0"
    DATA cInt  AS CHARACTER INIT "0"
    DATA cRDiv AS CHARACTER INIT "0"
    DATA cSig  AS CHARACTER INIT ""
    DATA lNeg  AS LOGICAL   INIT .F. 
    DATA nBase AS NUMERIC   INIT 10
    DATA nDec  AS NUMERIC   INIT 1
    DATA nInt  AS NUMERIC   INIT 1
    DATA nSize AS NUMERIC   INIT 2

#ifndef __PROTHEUS__
    EXPORTED:
#endif    
    
    method New(uBigN,nBase) CONSTRUCTOR /*( /!\ )*/

#ifndef __PROTHEUS__
    #ifdef TBN_DBFILE
        DESTRUCTOR tBigNGC
    #endif    
#endif    

    method Normalize(oBigN)

    method __cDec(cDec)   SETGET
    method __cInt(cInt)   SETGET
    method __cRDiv(cRDiv) SETGET
    method __cSig(cSig)   SETGET
    method __lNeg(lNeg)   SETGET
    method __nBase(nBase) SETGET
    method __nDec(nDec)   SETGET
    method __nInt(nInt)   SETGET 
    method __nSize(nSize) SETGET

    method Clone()
    method ClassName()

    method SetDecimals(nSet)

    method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc)
    method GetValue(lAbs,lObj)
    method ExactValue(lAbs,lObj)

    method Abs(lObj)
    
    method Int(lObj,lSig)
    method Dec(lObj,lSig,lNotZ)

    method eq(uBigN)
    method ne(uBigN)
    method gt(uBigN)
    method lt(uBigN)
    method gte(uBigN)
    method lte(uBigN)
    method cmp(uBigN)
    method btw(uBigS,uBigE)
    method ibtw(uiBigS,uiBigE)
    
    method Max(uBigN)
    method Min(uBigN)
    
    method Add(uBigN)
    method Plus(uBigN) INLINE self:Add(uBigN)    

    method Sub(uBigN)
    method Minus(uBigN) INLINE self:Sub(uBigN)
    
    method Mult(uBigN)
    method Multiply(uBigN) INLINE self:Mult(uBigN)
    
    method egMult(uBigN)
    method egMultiply(uBigN) INLINE self:egMult(uBigN)
    
    method Div(uBigN,lFloat)
    method Divide(uBigN,lFloat) INLINE self:Div(uBigN,lFloat)
    method Divmethod(nmethod)
    
    method Mod(uBigN)

    method Pow(uBigN)

    method OpInc()
    method OpDec()
    
    method e(lforce)
    
    method Exp(lforce)
    
    method PI(lforce)    //TODO: Implementar o calculo.
   
    method GCD(uBigN)
    method LCM(uBigN)
    
    method nthRoot(uBigN)
    method nthRootPF(uBigN)
    method nthRootAcc(nSet)

    method SQRT()
    method SysSQRT(uSet)

    method Log(uBigNB)    //TODO: Validar Calculo.
    method Log2()         //TODO: Validar Calculo.
    method Log10()        //TODO: Validar Calculo.
    method Ln()           //TODO: Validar Calculo.

    method aLog(uBigNB)   //TODO: Validar Calculo.
    method aLog2()        //TODO: Validar Calculo.
    method aLog10()       //TODO: Validar Calculo.
    method aLn()          //TODO: Validar Calculo.

    method MathC(uBigN1,cOperator,uBigN2)
    method MathN(uBigN1,cOperator,uBigN2)

    method Rnd(nAcc)
    method NoRnd(nAcc)
    method Truncate(nAcc)
    method Floor(nAcc)   //TODO: Verificar regra a partir de referencias bibliograficas.
    method Ceiling(nAcc) //TODO: Verificar regra a partir de referencias bibliograficas.

    method D2H(cHexB)
    method H2D()

    method H2B()
    method B2H(cHexB)

    method D2B(cHexB)
    method B2D(cHexB)

    method Randomize(uB,uE,nExit)

    method millerRabin(uI)
    
    method FI()
    
    method PFactors()
    method Factorial()    //TODO: Otimizar+
    
#ifndef __PROTHEUS__

         /* Operators Overloading:     
            "+"     = __OpPlus
             "-"     = __OpMinus
             "*"     = __OpMult
             "/"     = __OpDivide
             "%"     = __OpMod
             "^"     = __OpPower
             "**"    = __OpPower
             "++"    = __OpInc
             "--"    = __OpDec
             "=="    = __OpEqual
             "="     = __OpEqual (same as "==")
             "!="    = __OpNotEqual
             "<>"    = __OpNotEqual (same as "!=")
             "#"     = __OpNotEqual (same as "!=")
             "<"     = __OpLess
             "<="    = __OpLessEqual
             ">"     = __OpGreater
             ">="    = __OpGreaterEqual
             "$"     = __OpInstring
             "$$"    = __OpInclude
             "!"     = __OpNot
             ".not." = __OpNot (same as "!")
             ".and." = __OpAnd
             ".or."  = __OpOr
             ":="    = __OpAssign
             "[]"    = __OpArrayIndex
        */

/*(*)*/ /* OPERATORS NOT IMPLEMENTED: HB_APICLS.H, CLASSES.C AND HVM.C */

        OPERATOR "=="  ARG uBigN INLINE __OpEqual(self,uBigN)
        OPERATOR "="   ARG uBigN INLINE __OpEqual(self,uBigN)        //(same as "==")
        
        OPERATOR "!="  ARG uBigN INLINE __OpNotEqual(self,uBigN)
        OPERATOR "#"   ARG uBigN INLINE __OpNotEqual(self,uBigN)     //(same as "!=")
        OPERATOR "<>"  ARG uBigN INLINE __OpNotEqual(self,uBigN)     //(same as "!=")
        
        OPERATOR ">"   ARG uBigN INLINE __OpGreater(self,uBigN)
        OPERATOR ">="  ARG uBigN INLINE __OpGreaterEqual(self,uBigN)

        OPERATOR "<"   ARG uBigN INLINE __OpLess(self,uBigN)
        OPERATOR "<="  ARG uBigN INLINE __OpLessEqual(self,uBigN)

        OPERATOR "++"  INLINE __OpInc(self)
        OPERATOR "--"  INLINE __OpDec(self)
    
        OPERATOR "+"   ARG uBigN INLINE __OpPlus("+",self,uBigN)
/*(*)*/ OPERATOR "+="  ARG uBigN INLINE __OpPlus("+=",self,uBigN)

        OPERATOR "-"   ARG uBigN INLINE __OpMinus("-",self,uBigN)
/*(*)*/ OPERATOR "-="  ARG uBigN INLINE __OpMinus("-=",self,uBigN)
    
        OPERATOR "*"   ARG uBigN INLINE __OpMult("*",self,uBigN)
/*(*)*/ OPERATOR "*="  ARG uBigN INLINE __OpMult("*=",self,uBigN)

        OPERATOR "/"   ARGS uBigN,lFloat INLINE __OpDivide("/",self,uBigN,lFloat)
/*(*)*/ OPERATOR "/="  ARGS uBigN,lFloat INLINE __OpDivide("/=",self,uBigN,lFloat)
    
        OPERATOR "%"   ARG uBigN INLINE __OpMod("%",self,uBigN)
/*(*)*/ OPERATOR "%="  ARG uBigN INLINE __OpMod("%=",self,uBigN)

        OPERATOR "^"   ARG uBigN INLINE __OpPower("^",self,uBigN)
        OPERATOR "**"  ARG uBigN INLINE __OpPower("**",self,uBigN)     //(same as "^")

/*(*)*/ OPERATOR "^="  ARG uBigN INLINE __OpPower("^=",self,uBigN)
/*(*)*/ OPERATOR "**=" ARG uBigN INLINE __OpPower("**=",self,uBigN)    //(same as "^=")
    
        OPERATOR ":="  ARGS uBigN,nBase,cRDiv,lLZRmv,nAcc INLINE __OpAssign(self,uBigN,nBase,cRDiv,lLZRmv,nAcc)

#endif //__PROTHEUS__
                    
endCLASS

#ifndef __PROTHEUS__

    /* overloaded methods/functions */

    static function __OpEqual(oSelf,uBigN)
    return(oSelf:eq(uBigN))
    
    static function __OpNotEqual(oSelf,uBigN)
    return(oSelf:ne(uBigN))
    
    static function __OpGreater(oSelf,uBigN)
    return(oSelf:gt(uBigN))
    
    static function __OpGreaterEqual(oSelf,uBigN)
    return(oSelf:gte(uBigN))
    
    static function __OpLess(oSelf,uBigN)
    return(oSelf:lt(uBigN))
    
    static function __OpLessEqual(oSelf,uBigN)
    return(oSelf:lte(uBigN))
    
    static function __OpInc(oSelf)
    return(oSelf:SetValue(oSelf:OpInc()))
    
    static function __OpDec(oSelf)
    return(oSelf:SetValue(oSelf:OpDec()))
    
    static function __OpPlus(cOp,oSelf,uBigN)
        local oOpPlus
        if cOp=="+="
            oOpPlus:=oSelf:SetValue(oSelf:Add(uBigN))
        Else
            oOpPlus:=oSelf:Add(uBigN)
        endif
    return(oOpPlus)
    
    static function __OpMinus(cOp,oSelf,uBigN)
        local oOpMinus
        if cOp=="-="
            oOpMinus:=oSelf:SetValue(oSelf:Sub(uBigN))
        Else
            oOpMinus:=oSelf:Sub(uBigN)
        endif
    return(oOpMinus)
    
    static function __OpMult(cOp,oSelf,uBigN)
        local oOpMult
        if cOp=="*="
            oOpMult:=oSelf:SetValue(oSelf:Mult(uBigN))    
        Else
            oOpMult:=oSelf:Mult(uBigN)
        endif
    return(oOpMult)
    
    static function __OpDivide(cOp,oSelf,uBigN,lFloat)
        local oOpDivide
        if cOp=="/="
            oOpDivide:=oSelf:SetValue(oSelf:Div(uBigN,lFloat))            
        Else
            oOpDivide:=oSelf:Div(uBigN,lFloat)
        endif
    return(oOpDivide)
    
    static function __OpMod(cOp,oSelf,uBigN)
        local oOpMod
        if cOp=="%="
            oOpMod:=oSelf:SetValue(oSelf:Mod(uBigN))    
        Else
            oOpMod:=oSelf:Mod(uBigN)
        endif
    return(oOpMod)
    
    static function __OpPower(cOp,oSelf,uBigN)
        local oOpPower
        switch cOp
            case "^="
            case "**="
                oOpPower:=oSelf:SetValue(oSelf:Pow(uBigN))
                exit
            otherwise
                oOpPower:=oSelf:Pow(uBigN)
        endswitch
    return(oOpPower)
    
    static function __OpAssign(oSelf,uBigN,nBase,cRDiv,lLZRmv,nAcc)
    return(oSelf:SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc))

#endif //__PROTHEUS__

/*
    function    : tBigNumber():New
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Instancia um novo Objeto tBigNumber
    Sintaxe     : tBigNumber():New(uBigN,nBase) -> self
*/
#ifdef __PROTHEUS__
    user function tBigNumber(uBigN,nBase)
    return(tBigNumber():New(uBigN,nBase))
#endif

/*
    method      : New
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : CONSTRUCTOR
    Sintaxe     : tBigNumber():New(uBigN,nBase) -> self
*/
method New(uBigN,nBase) CLASS tBigNumber
    
    DEFAULT nBase:=10    
    self:nBase:=nBase

    // -------------------- assign thread static values -------------------------
    if thslsdSet==NIL
        self:SetDecimals()
        self:nthRootAcc()
        __Initsthd(nBase)
    endif
 
    DEFAULT uBigN:="0"
    self:SetValue(uBigN,nBase)

     // -------------------- assign static values --------------------------------
    if __lstbNSet==NIL
        __InitstbN(nBase)
        self:Divmethod(__DIVMETHOD__)
    endif

return(self)

/*
    method      : tBigNGC
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : DESTRUCTOR
*/
#ifdef TBN_DBFILE
    #ifdef __HARBOUR__
        Procedure tBigNGC() CLASS tBigNumber
    #else
        static Procedure tBigNGC()
    #endif    
            local nFile
            local nFiles
            DEFAULT thsdFiles:=Array(0)
            nFiles:=tBIGNaLen(thsdFiles)
            for nFile:=1 to nFiles
                if Select(thsdFiles[nFile][1])>0
                    (thsdFiles[nFile][1])->(dbCloseArea())
                endif            
                #ifdef __PROTEUS__
                    MsErase(thsdFiles[nFile][2],NIL,if((Type("__localDriver")=="C"),__localDriver,"DBFCDXADS"))
                #else
                    #ifdef TBN_MEMIO
                        dbDrop(thsdFiles[nFile][2])
                    #else
                        fErase(thsdFiles[nFile][2])
                    #endif
                #endif    
            next nFile
            aSize(thsdFiles,0)
        return
#endif    

/*
    method      : __cDec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __cDec
    Sintaxe     : tBigNumber():__cDec() -> cDec
*/
method __cDec(cDec) CLASS tBigNumber
    if .not.(cDec==NIL)
        self:lNeg:=SubStr(cDec,1,1)=="-"
        if self:lNeg
            cDec:=SubStr(cDec,2)
        endif
        self:cDec:=cDec
        self:nDec:=hb_bLen(cDec)
        self:nSize:=self:nInt+self:nDec
        if self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
    endif
return(self:cDec)

/*
    method      : __cInt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __cDec
    Sintaxe     : tBigNumber():__cInt() -> cInt
*/
method __cInt(cInt) CLASS tBigNumber
    if .not.(cInt==NIL)
        self:lNeg:=SubStr(cInt,1,1)=="-"
        if self:lNeg
            cInt:=SubStr(cInt,2)
        endif
        self:cInt:=cInt
        self:nInt:=hb_bLen(cInt)
        self:nSize:=self:nInt+self:nDec
        if self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
    endif
return(self:cInt)

/*
    method      : __cRDiv
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 30/03/2014
    Descricao   : __cRDiv
    Sintaxe     : tBigNumber():__cRDiv() -> __cRDiv
*/
method __cRDiv(cRDiv) CLASS tBigNumber
    if .not.(cRDiv==NIL)
        if Empty(cRDiv)
            cRDiv:="0"
        endif
        self:cRDiv:=cRDiv
    endif
return(self:cRDiv)

/*
    method      : __cSig
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __cSig
    Sintaxe     : tBigNumber():__cSig() -> cSig
*/
method __cSig(cSig) CLASS tBigNumber
    if .not.(cSig==NIL)
        self:cSig:=cSig 
        self:lNeg:=(cSig=="-")
        if self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
        if .not.(self:lNeg)
            self:cSig:=""
        endif
    endif
return(self:cSig)

/*
    method      : __lNeg
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __lNeg
    Sintaxe     : tBigNumber():__lNeg() -> lNeg
*/
method __lNeg(lNeg) CLASS tBigNumber
    if .not.(lNeg==NIL)
        self:lNeg:=lNeg
        if self:eq(__o0)
            self:lNeg:=.F.
            self:cSig:=""
        endif
        if lNeg
            self:cSig:="-"    
        endif
    endif
return(self:lNeg)

/*
    method      : __nBase
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __nBase
    Sintaxe     : tBigNumber():__nBase() -> nBase
*/
method __nBase(nBase) CLASS tBigNumber
    if .not.(nBase==NIL)
        self:nBase:=nBase
    endif
return(self:nBase)

/*
    method      : __nDec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __nDec
    Sintaxe     : tBigNumber():__nDec() -> nDec
*/
method __nDec(nDec) CLASS tBigNumber
    if .not.(nDec==NIL)
        if nDec>self:nDec
            self:cDec:=PadR(self:cDec,nDec,"0")
        Else
            self:cDec:=SubStr(self:cDec,1,nDec)
        endif
        self:nDec:=nDec
        self:nSize:=self:nInt+self:nDec
    endif
return(self:nDec)

/*
    method      : __nInt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : __nInt
    Sintaxe     : tBigNumber():__nInt() -> nInt
*/
method __nInt(nInt) CLASS tBigNumber
    if .not.(nInt==NIL)
        if nInt>self:nInt
            self:cInt:=PadL(self:cInt,nInt,"0")
            self:nInt:=nInt
            self:nSize:=self:nInt+self:nDec
        endif    
    endif
return(self:nInt)

/*
    method      : __nSize
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 17/02/2014
    Descricao   : nSize
    Sintaxe     : tBigNumber():__nSize() -> nSize
*/
method __nSize(nSize) CLASS tBigNumber
    if .not.(nSize==NIL)
        if nSize>self:nInt+self:nDec
            if self:nInt>self:nDec
                self:nInt:=nSize-self:nDec
                self:cInt:=PadL(self:cInt,self:nInt,"0")
            Else
                 self:nDec:=nSize-self:nInt
                 self:cDec:=PadR(self:cDec,self:nDec,"0")
            endif    
            self:nSize:=nSize
        endif
    endif
return(self:nSize)

/*
    method      : Clone
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 27/03/2013
    Descricao   : Clone
    Sintaxe     : tBigNumber():Clone() -> oClone
*/
method Clone() CLASS tBigNumber
    if thslsdSet==NIL
        return(tBigNumber():New(self))
    endif
#ifdef __PROTHEUS__
return(tBigNumber():New(self))
#else  //__HARBOUR__
return(__objClone(self))
#endif //__PROTHEUS__    

/*
    method      : ClassName
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : ClassName
    Sintaxe     : tBigNumber():ClassName() -> cClassName
*/
method ClassName() CLASS tBigNumber
return("TBIGNUMBER")

/*
    method    : SetDecimals
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 04/02/2013
    Descricao : Setar o Numero de Casas Decimais
    Sintaxe   : tBigNumber():SetDecimals(nSet) -> nLastSet
*/
method SetDecimals(nSet) CLASS tBigNumber

    local nLastSet

    if hb_mutexLock(__stkMutex)
    
        nLastSet:=__nDecimalSet
    
        DEFAULT __nDecimalSet:=if(nSet==NIL,32,nSet)
        DEFAULT nSet :=__nDecimalSet
        DEFAULT nLastSet:=nSet

        if nSet>MAX_DECIMAL_PRECISION
            nSet:=MAX_DECIMAL_PRECISION
        endif

        __nDecimalSet:=nSet

        hb_mutexUnLock(__stkMutex)

  	endif
    
    DEFAULT nLastSet:=if(nSet==NIL,32,nSet)
    
return(nLastSet)

/*
    method      : nthRootAcc
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Setar a Precisao para nthRoot
    Sintaxe     : tBigNumber():nthRootAcc(nSet) -> nLastSet
*/
method nthRootAcc(nSet) CLASS tBigNumber

    local nLastSet
    
    if hb_mutexLock(__stkMutex)
    
        nLastSet:=__nthRootAcc

        DEFAULT __nthRootAcc:=if(nSet==NIL,6,nSet)
        DEFAULT nSet:=__nthRootAcc
        DEFAULT nLastSet:=nSet

        if nSet>MAX_DECIMAL_PRECISION
            nSet:=MAX_DECIMAL_PRECISION
        endif

        __nthRootAcc:=Min(self:SetDecimals()-1,nSet)
        
        hb_mutexUnLock(__stkMutex)
    
    endif
    
    DEFAULT nLastSet:=if(nSet==NIL,6,nSet)

return(nLastSet)

/*
    method      : SetValue
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : SetValue
    Sintaxe     : tBigNumber():SetValue(uBigN,nBase,cRDiv,lLZRmv) -> self
*/
method SetValue(uBigN,nBase,cRDiv,lLZRmv,nAcc) CLASS tBigNumber

    local cType:=ValType(uBigN)

    local nFP

    #ifdef __TBN_DYN_OBJ_SET__
    local nP
        #ifdef __HARBOUR__
            MEMVAR This
        #endif
        private This
    #endif    

    if cType=="O"
    
        DEFAULT cRDiv:=uBigN:cRDiv

        #ifdef __TBN_DYN_OBJ_SET__

            #ifdef __PROTHEUS__
    
                This:=self
                uBigN:=ClassDataArr(uBigN)
                nFP:=hb_bLen(uBigN)
                
                for nP:=1 to nFP
                    &("This:"+uBigN[nP][1]):=uBigN[nP][2]
                next nP    
            
            #else
    
                __objSetValueList(self,__objGetValueList(uBigN))
    
            #endif    
            
        #else

            self:cDec:=uBigN:cDec
            self:cInt:=uBigN:cInt
            self:cRDiv:=uBigN:cRDiv
            self:cSig:=uBigN:cSig
            self:lNeg:=uBigN:lNeg
            self:nBase:=uBigN:nBase
            self:nDec:=uBigN:nDec
            self:nInt:=uBigN:nInt
            self:nSize:=uBigN:nSize
            
        #endif
    
    Elseif cType=="A"

        DEFAULT cRDiv:=uBigN[3][2]
        
        #ifdef __TBN_DYN_OBJ_SET__

            This:=self
            nFP:=hb_bLen(uBigN)
    
            for nP:=1 to nFP
                &("This:"+uBigN[nP][1]):=uBigN[nP][2]
            next nP    
        
        #else

            self:cDec:=uBigN[1][2]
            self:cInt:=uBigN[2][2]
            self:cRDiv:=uBigN[3][2]
            self:cSig:=uBigN[4][2]
            self:lNeg:=uBigN[5][2]
            self:nBase:=uBigN[6][2]
            self:nDec:=uBigN[7][2]
            self:nInt:=uBigN[8][2]
            self:nSize:=uBigN[9][2]
        
        #endif
    
    Elseif cType=="C"

        while " " $ uBigN
            uBigN:=StrTran(uBigN," ","")    
        end while

        self:lNeg:=SubStr(uBigN,1,1)=="-"

        if self:lNeg
            uBigN:=SubStr(uBigN,2)
            self:cSig:="-"
        Else
            self:cSig:=""
        endif

        nFP:=AT(".",uBigN)

        DEFAULT nBase:=self:nBase

        self:cInt:="0"
        self:cDec:="0"

        do case
        case nFP==0
            self:cInt:=SubStr(uBigN,1)
            self:cDec:="0"
        case nFP==1
            self:cInt:="0"
            self:cDec:=SubStr(uBigN,nFP+1)
            if "0"==SubStr(self:cDec,1,1)
                nFP:=hb_bLen(self:cDec)
                IncZeros(nFP)
                if self:cDec==SubStr(thscstcZ0,1,nFP)
                    self:cDec:="0"
                endif
            endif    
        otherwise
            self:cInt:=SubStr(uBigN,1,nFP-1)
            self:cDec:=SubStr(uBigN,nFP+1)
            if "0"==SubStr(self:cDec,1,1)
                nFP:=hb_bLen(self:cDec)
                IncZeros(nFP)
                if self:cDec==SubStr(thscstcZ0,1,nFP)
                    self:cDec:="0"
                endif
            endif    
        endcase
        
        if self:cInt=="0" .and. (self:cDec=="0".or.self:cDec=="")
            self:lNeg:=.F.
            self:cSig:=""
        endif
 
        self:nInt:=hb_bLen(self:cInt)
        self:nDec:=hb_bLen(self:cDec)
            
    endif

    if self:cInt==""
        self:cInt:="0"
        self:nInt:=1
    endif

    if self:cDec==""
        self:cDec:="0"
        self:nDec:=1
    endif
 
    if Empty(cRDiv)
        cRDiv:="0"
    endif
    self:cRDiv:=cRDiv

    DEFAULT lLZRmv:=(self:nBase==10)
    if lLZRmv
        while self:nInt>1 .and. SubStr(self:cInt,1,1)=="0"
            self:cInt:=SubStr(self:cInt,2)
            --self:nInt
        end while
    endif

    DEFAULT nAcc:=__nDecimalSet
    if self:nDec>nAcc
        self:nDec:=nAcc
        self:cDec:=SubStr(self:cDec,1,self:nDec)
        if self:cDec==""
            self:cDec:="0"
            self:nDec:=1
        endif
    endif
    
    self:nSize:=(self:nInt+self:nDec)

return(self)

/*
    method      : GetValue
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : GetValue
    Sintaxe     : tBigNumber():GetValue(lAbs,lObj) -> uNR
*/
method GetValue(lAbs,lObj) CLASS tBigNumber

    local uNR

    DEFAULT lAbs:=.F.
    DEFAULT lObj:=.F.
    
    uNR:=if(lAbs,"",self:cSig)
    uNR+=self:cInt
    uNR+="."
    uNR+=self:cDec

    if lObj
        uNR:=tBigNumber():New(uNR)
    endif

return(uNR)        

/*
    method      : ExactValue
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : ExactValue
    Sintaxe     : tBigNumber():ExactValue(lAbs) -> uNR
*/
method ExactValue(lAbs,lObj) CLASS tBigNumber

    local cDec

    local uNR

    DEFAULT lAbs:=.F.
    DEFAULT lObj:=.F.

    uNR:=if(lAbs,"",self:cSig)

    uNR+=self:cInt
    cDec:=self:Dec(NIL,NIL,self:nBase==10)

    if .not.(cDec=="")
        uNR+="."
        uNR+=cDec
    endif

    if lObj
        uNR:=tBigNumber():New(uNR)
    endif

return(uNR)

/*
    method      : Abs
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna o Valor Absoluto de um Numero
    Sintaxe     : tBigNumber():Abs() -> uNR
*/
method Abs(lObj) CLASS tBigNumber
return(self:GetValue(.T.,lObj))

/*
    method      : Int
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna a Parte Inteira de um Numero
    Sintaxe     : tBigNumber():Int(lObj,lSig) -> uNR
*/
method Int(lObj,lSig) CLASS tBigNumber
    local uNR
    DEFAULT lObj:=.F.
    DEFAULT lSig:=.F.
    uNR:=if(lSig,self:cSig,"")+self:cInt
    if lObj
        uNR:=tBigNumber():New(uNR)
    endif
return(uNR)

/*
    method      : Dec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna a Parte Decimal de um Numero
    Sintaxe     : tBigNumber():Dec(lObj,lSig,lNotZ) -> uNR
*/
method Dec(lObj,lSig,lNotZ) CLASS tBigNumber

    local cDec:=self:cDec
    
    local nDec
    
    local uNR

    DEFAULT lNotZ:=.F.
    if lNotZ
        nDec:=self:nDec
        while SubStr(cDec,-1)=="0"
            cDec:=SubStr(cDec,1,--nDec)
        end while
    endif

    DEFAULT lObj:=.F.
    DEFAULT lSig:=.F.
    if lObj
        uNR:=tBigNumber():New(if(lSig,self:cSig,"")+"0."+cDec)
    Else
        uNR:=if(lSig,self:cSig,"")+cDec
    endif

return(uNR)

/*
    method      : eq
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Compara se o valor corrente eh igual ao passado como parametro
    Sintaxe     : tBigNumber():eq(uBigN) -> leq
*/
method eq(uBigN) CLASS tBigNumber

    local leq

    thseqN1:SetValue(self)
    thseqN2:SetValue(uBigN)
 
    leq:=thseqN1:lNeg==thseqN2:lNeg
    if leq
        thseqN1:Normalize(@thseqN2)
        #ifdef __PTCOMPAT__
            leq:=thseqN1:GetValue(.T.)==thseqN2:GetValue(.T.)
        #else
            leq:=tBIGNmemcmp(thseqN1:GetValue(.T.),thseqN2:GetValue(.T.))==0
        #endif    
    endif        

return(leq)

/*
    method      : ne
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh igual ao valor passado como parametro
    Sintaxe     : tBigNumber():ne(uBigN) -> .not.(leq)
*/
method ne(uBigN) CLASS tBigNumber
return(.not.(self:eq(uBigN)))

/*
    method      : gt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh maior que o valor passado como parametro
    Sintaxe     : tBigNumber():gt(uBigN) -> lgt
*/
method gt(uBigN) CLASS tBigNumber

    local lgt

    thsgtN1:SetValue(self)
    thsgtN2:SetValue(uBigN)
    
    if thsgtN1:lNeg .or. thsgtN2:lNeg
        if thsgtN1:lNeg .and. thsgtN2:lNeg
            thsgtN1:Normalize(@thsgtN2)
            #ifdef __PTCOMPAT__
                lgt:=thsgtN1:GetValue(.T.)<thsgtN2:GetValue(.T.)
            #else
                lgt:=tBIGNmemcmp(thsgtN1:GetValue(.T.),thsgtN2:GetValue(.T.))==-1
            #endif    
        Elseif thsgtN1:lNeg .and. .not.(thsgtN2:lNeg)
            lgt:=.F.
        Elseif .not.(thsgtN1:lNeg) .and. thsgtN2:lNeg
            lgt:=.T.
        endif
    Else
        thsgtN1:Normalize(@thsgtN2)
        #ifdef __PTCOMPAT__
            lgt:=thsgtN1:GetValue(.T.)>thsgtN2:GetValue(.T.)
        #else
            lgt:=tBIGNmemcmp(thsgtN1:GetValue(.T.),thsgtN2:GetValue(.T.))==1
        #endif    
    endif 

return(lgt)

/*
    method      : lt
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh menor que o valor passado como parametro
    Sintaxe     : tBigNumber():lt(uBigN) -> llt
*/
method lt(uBigN) CLASS tBigNumber
   
    local llt

    thsltN1:SetValue(self)
    thsltN2:SetValue(uBigN)
    
    if thsltN1:lNeg .or. thsltN2:lNeg
        if thsltN1:lNeg .and. thsltN2:lNeg
            thsltN1:Normalize(@thsltN2)
            #ifdef __PTCOMPAT__
                llt:=thsltN1:GetValue(.T.)>thsltN2:GetValue(.T.)
            #else
                llt:=tBIGNmemcmp(thsltN1:GetValue(.T.),thsltN2:GetValue(.T.))==1
            #endif    
        Elseif thsltN1:lNeg .and. .not.(thsltN2:lNeg)
            llt:=.T.
        Elseif .not.(thsltN1:lNeg) .and. thsltN2:lNeg
            llt:=.F.
        endif
    Else
        thsltN1:Normalize(@thsltN2)
        #ifdef __PTCOMPAT__
            llt:=thsltN1:GetValue(.T.)<thsltN2:GetValue(.T.)
        #else
            llt:=tBIGNmemcmp(thsltN1:GetValue(.T.),thsltN2:GetValue(.T.))==-1
        #endif    
    endif    

return(llt)

/*
    method      : gte
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh maior ou igual ao valor passado como parametro
    Sintaxe     : tBigNumber():gte(uBigN) -> lgte
*/
method gte(uBigN) CLASS tBigNumber
return(self:cmp(uBigN)>=0)

/*
    method      : lte
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Verifica se o valor corrente eh menor ou igual ao valor passado como parametro
    Sintaxe     : tBigNumber():lte(uBigN) -> lte
*/
method lte(uBigN) CLASS tBigNumber
return(self:cmp(uBigN)<=0)

/*
    method      : cmp
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 11/03/2014
    Descricao   : Compara self com valor passado como parametro e retorna:
                  -1 : self < que valor de referencia;
                   0 : self = valor de referencia;
                   1 : self > que valor de referencia;
    Sintaxe     : tBigNumber():cmp(uBigN) -> nCmp
*/
method cmp(uBigN) CLASS tBigNumber

    local nCmp
    local iCmp
    
    local llt
    local leq
    
    thscmpN1:SetValue(self)
    thscmpN2:SetValue(uBigN)
    
#ifdef __PTCOMPAT__
    thscmpN1:Normalize(@thscmpN2)
#endif
    
    leq:=thscmpN1:lNeg==thscmpN2:lNeg
    if leq
        #ifndef __PTCOMPAT__    
            thscmpN1:Normalize(@thscmpN2)
        #endif        
        #ifdef __PTCOMPAT__
            iCmp:=if(thscmpN1:GetValue(.T.)==thscmpN2:GetValue(.T.),0,NIL)
        #else
            iCmp:=tBIGNmemcmp(thscmpN1:GetValue(.T.),thscmpN2:GetValue(.T.))
        #endif
        leq:=iCmp==0
    endif    

    if leq
        nCmp:=0    
    Else
        if thscmpN1:lNeg .or. thscmpN2:lNeg
            if thscmpN1:lNeg .and. thscmpN2:lNeg
                if iCmp==NIL
                    #ifndef __PTCOMPAT__
                        thscmpN1:Normalize(@thscmpN2)
                    #endif    
                    #ifdef __PTCOMPAT__
                        iCmp:=if(thscmpN1:GetValue(.T.)>thscmpN2:GetValue(.T.),1,-1)
                    #else
                        iCmp:=tBIGNmemcmp(thscmpN1:GetValue(.T.),thscmpN2:GetValue(.T.))
                    #endif    
                endif
                llt:=iCmp==1
            Elseif thscmpN1:lNeg .and. .not.(thscmpN2:lNeg)
                llt:=.T.
            Elseif .not.(thscmpN1:lNeg) .and. thscmpN2:lNeg
                llt:=.F.
            endif
        Else
            #ifdef __PTCOMPAT__
                iCmp:=if(thscmpN1:GetValue(.T.)<thscmpN2:GetValue(.T.),-1,1)
            #endif
            llt:=iCmp==-1
        endif
        if llt
            nCmp:=-1
        Else
            nCmp:=1
        endif
    endif
    
return(nCmp)

/*
    method      : btw (between)
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 01/04/2014
    Descricao   : Retorna .T. se self estiver no intervalo passado.  
    Sintaxe     : tBigNumber():btw(uBigS,uBigE) -> lRet
*/
method btw(uBigS,uBigE) CLASS tBigNumber
return(self:cmp(uBigS)>=0.and.self:cmp(uBigE)<=0)

/*
    method      : ibtw (integer between)
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 11/03/2014
    Descricao   : Retorna .T. se self estiver no intervalo passado.  
    Sintaxe     : tBigNumber():ibtw(uiBigS,uiBigE) -> lRet
*/
method ibtw(uiBigS,uiBigE) CLASS tBigNumber
    local lbtw := .F.
    if self:Dec(.T.,.F.,.T.):eq(__o0)
        lbtw := self:cmp(uiBigS)>=0.and.self:cmp(uiBigE)<=0
    endif   
return(lbtw)

/*
    method      : Max
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna o maior valor entre o valor corrente e o valor passado como parametro
    Sintaxe     : tBigNumber():Max(uBigN) -> oMax
*/
method Max(uBigN) CLASS tBigNumber
    local oMax:=tBigNumber():New(uBigN)
    if self:gt(oMax)
        oMax:SetValue(self)
    endif
return(oMax)

/*
    method      : Min
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Retorna o menor valor entre o valor corrente e o valor passado como parametro
    Sintaxe     : tBigNumber():Min(uBigN) -> oMin
*/
method Min(uBigN) CLASS tBigNumber
    local oMin:=tBigNumber():New(uBigN)
    if self:lt(oMin)
        oMin:SetValue(self)
    endif
return(oMin)

/*
    method      : Add
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Soma
    Sintaxe     : tBigNumber():Add(uBigN) -> oBigNR
*/
method Add(uBigN) CLASS tBigNumber

    local cInt        
    local cDec        

    local cN1
    local cN2
    local cNT

    local lNeg         
    local lInv
    local lAdd:=.T.

    local nDec        
    local nSize     

    thsadN1:SetValue(self)
    thsadN2:SetValue(uBigN)
    
    thsadN1:Normalize(@thsadN2)

    nDec:=thsadN1:nDec
    nSize:=thsadN1:nSize

    cN1:=thsadN1:cInt
    cN1+=thsadN1:cDec

    cN2:=thsadN2:cInt
    cN2+=thsadN2:cDec

    lNeg:=(thsadN1:lNeg .and. .not.(thsadN2:lNeg)) .or. (.not.(thsadN1:lNeg) .and. thsadN2:lNeg)

    if lNeg
        lAdd:=.F.
        lInv:=cN1<cN2
        lNeg:=(thsadN1:lNeg .and. .not.(lInv)) .or. (thsadN2:lNeg .and. lInv)
        if lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        endif
    Else
        lNeg:=thsadN1:lNeg
    endif

    if lAdd
        thsadNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
    Else
        thsadNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
    endif

    cNT:=thsadNR:cInt
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)

    cNT:=cInt
    cNT+="."
    cNT+=cDec

    thsadNR:SetValue(cNT)

    if lNeg
        thsadNR:__cSig("-")
    endif

return(thsadNR:Clone())

/*
    method      : Sub
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Soma
    Sintaxe     : tBigNumber():Sub(uBigN) -> oBigNR
*/
method Sub(uBigN) CLASS tBigNumber

    local cInt        
    local cDec        

    local cN1     
    local cN2     
    local cNT         

    local lNeg        
    local lInv        
    local lSub:=.T.

    local nDec        
    local nSize     

    thssbN1:SetValue(self)
    thssbN2:SetValue(uBigN)
    
    thssbN1:Normalize(@thssbN2)
    
    nDec:=thssbN1:nDec
    nSize:=thssbN1:nSize

    cN1:=thssbN1:cInt
    cN1+=thssbN1:cDec

    cN2:=thssbN2:cInt
    cN2+=thssbN2:cDec

    lNeg:=(thssbN1:lNeg .and. .not.(thssbN2:lNeg)) .or. (.not.(thssbN1:lNeg) .and. thssbN2:lNeg)

    if lNeg
        lSub:=.F.
        lNeg:=thssbN1:lNeg
    Else
        lInv:=cN1<cN2
        lNeg:=thssbN1:lNeg .or. lInv
        if lInv
            cNT:=cN1
            cN1:=cN2
            cN2:=cNT
            cNT:=NIL
        endif
    endif

    if lSub
        thssbNR:SetValue(Sub(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
    Else
        thssbNR:SetValue(Add(cN1,cN2,nSize,self:nBase),NIL,NIL,.F.)
    endif

    cNT:=thssbNR:cInt
    
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)
    
    cNT:=cInt
    cNT+="."
    cNT+=cDec
    
    thssbNR:SetValue(cNT)

    if lNeg
        thssbNR:__cSig("-")
    endif

return(thssbNR:Clone())

/*
    method      : Mult
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Multiplicacao 
    Sintaxe     : tBigNumber():Mult(uBigN) -> oBigNR
*/
method Mult(uBigN) CLASS tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg    
    local lNeg1 
    local lNeg2

    local nDec    
    local nSize 

    thsmtN1:SetValue(self)
    thsmtN2:SetValue(uBigN)
    
    thsmtN1:Normalize(@thsmtN2)
 
    lNeg1:=thsmtN1:lNeg
    lNeg2:=thsmtN2:lNeg    
    lNeg:=(lNeg1 .and. .not.(lNeg2)) .or. (.not.(lNeg1) .and. lNeg2)
 
    cN1:=thsmtN1:cInt
    cN1+=thsmtN1:cDec

    cN2:=thsmtN2:cInt
    cN2+=thsmtN2:cDec

    nDec:=thsmtN1:nDec*2
    nSize:=thsmtN1:nSize
    
    thsmtNR:SetValue(Mult(cN1,cN2,nSize,self:nBase),self:nBase,NIL,.F.)

    cNT:=thsmtNR:cInt
    
    if nDec>0
        cDec:=SubStr(cNT,-nDec)
        cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)
        cNT:=cInt
        cNT+="."
        cNT+=cDec
    endif    
    
    thsmtNR:SetValue(cNT)
    
    cNT:=thsmtNR:ExactValue()
    
    thsmtNR:SetValue(cNT)

    if lNeg
        thsmtNR:__cSig("-")
    endif

return(thsmtNR:Clone())

/*
    method      : egMult
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Multiplicacao Egipcia
    Sintaxe     : tBigNumber():egMult(uBigN) -> oBigNR
*/
method egMult(uBigN) CLASS tBigNumber

    local cInt
    local cDec

    local cN1
    local cN2
    local cNT

    local lNeg    
    local lNeg1 
    local lNeg2
 
    local nDec    

    thsmtN1:SetValue(self)
    thsmtN2:SetValue(uBigN)
    
    thsmtN1:Normalize(@thsmtN2)
 
    lNeg1:=thsmtN1:lNeg
    lNeg2:=thsmtN2:lNeg    
    lNeg:=(lNeg1 .and. .not.(lNeg2)) .or. (.not.(lNeg1) .and. lNeg2)
    
    cN1:=thsmtN1:cInt
    cN1+=thsmtN1:cDec

    cN2:=thsmtN2:cInt
    cN2+=thsmtN2:cDec

    nDec:=thsmtN1:nDec*2

    thsmtNR:SetValue(egMult(cN1,cN2,self:nBase),self:nBase,NIL,.F.)

    cNT:=thsmtNR:cInt
    
    cDec:=SubStr(cNT,-nDec)
    cInt:=SubStr(cNT,1,hb_bLen(cNT)-nDec)
    
    cNT:=cInt
    cNT+="."
    cNT+=cDec
    
    thsmtNR:SetValue(cNT)
    
    cNT:=thsmtNR:ExactValue()
    
    thsmtNR:SetValue(cNT)

    if lNeg
        thsmtNR:__cSig("-")
    endif

return(thsmtNR:Clone())

/*
    method      : Div
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Divisao
    Sintaxe     : tBigNumber():Div(uBigN,lFloat) -> oBigNR
*/
method Div(uBigN,lFloat) CLASS tBigNumber

    local cDec
    
    local cN1
    local cN2
    local cNR

    local lNeg    
    local lNeg1 
    local lNeg2
    
    local nAcc:=__nDecimalSet
    local nDec
    
    BEGIN SEQUENCE

        if __o0:eq(uBigN)
            thsdvNR:SetValue(__o0)
            break
        endif

        thsdvN1:SetValue(self)
        thsdvN2:SetValue(uBigN)
        
        DEFAULT lFloat:=.T.
 
        if thsdvN2:eq(__o2)
            //(Div(2)==Mult(.5)
            thsdvNR:SetValue(thsdvN1:Mult(__od2))
            if .not.(lFloat)
                thsdvNR:__cDec("0")
                thsdvNR:__cInt(thsdvNR:Int(.F.,.T.))
                thsdvNR:__cRDiv(thsdvN1:Sub(thsdvN2:Mult(thsdvNR:Int(.T.,.F.))):ExactValue(.T.))
            endif
            break
        endif
        
        thsdvN1:Normalize(@thsdvN2)
    
        lNeg1:=thsdvN1:lNeg
        lNeg2:=thsdvN2:lNeg    
        lNeg:=(lNeg1 .and. .not.(lNeg2)) .or. (.not.(lNeg1) .and. lNeg2)
    
        cN1:=thsdvN1:cInt
        cN1+=thsdvN1:cDec
    
        cN2:=thsdvN2:cInt
        cN2+=thsdvN2:cDec

        if __nDivMeth==2
            thsdvNR:SetValue(ecDiv(cN1,cN2,thsdvN1:nSize,thsdvN1:nBase,nAcc,lFloat))
        Else
            thsdvNR:SetValue(egDiv(cN1,cN2,thsdvN1:nSize,thsdvN1:nBase,nAcc,lFloat))
        endif    

        if lFloat

            thsdvRDiv:SetValue(thsdvNR:cRDiv,NIL,NIL,.F.)
        
            if thsdvRDiv:gt(__o0)
    
                cDec:=""
        
                thsdvN2:SetValue(cN2)
        
                while thsdvRDiv:lt(thsdvN2)
                    thsdvRDiv:cInt+="0"
                    thsdvRDiv:nInt++
                    thsdvRDiv:nSize++
                    if thsdvRDiv:lt(thsdvN2)
                        cDec+="0"
                    endif
                end while
        
                while thsdvRDiv:gte(thsdvN2)
                    
                    thsdvRDiv:Normalize(@thsdvN2)
            
                    cN1:=thsdvRDiv:cInt
                    cN1+=thsdvRDiv:cDec
        
                    cN2:=thsdvN2:cInt
                    cN2+=thsdvN2:cDec

                    if __nDivMeth==2
                        thsdvRDiv:SetValue(ecDiv(cN1,cN2,thsdvRDiv:nSize,thsdvRDiv:nBase,nAcc,lFloat))
                    Else
                        thsdvRDiv:SetValue(egDiv(cN1,cN2,thsdvRDiv:nSize,thsdvRDiv:nBase,nAcc,lFloat))
                    endif

                    cDec+=thsdvRDiv:ExactValue(.T.)
                    nDec:=hb_bLen(cDec)
        
                    thsdvRDiv:SetValue(thsdvRDiv:cRDiv,NIL,NIL,.F.)
                    thsdvRDiv:SetValue(thsdvRDiv:ExactValue(.T.))

                    if thsdvRDiv:eq(__o0) .or. nDec>=nAcc
                        exit
                    endif
        
                    thsdvN2:SetValue(cN2)        
                    
                    while thsdvRDiv:lt(thsdvN2)
                        thsdvRDiv:cInt+="0"
                        thsdvRDiv:nInt++
                        thsdvRDiv:nSize++
                        if thsdvRDiv:lt(thsdvN2)
                            cDec+="0"
                        endif
                    end while
                
                end while
        
                cNR:=thsdvNR:__cInt()
                cNR+="."
                cNR+=SubStr(cDec,1,nAcc)
        
                thsdvNR:SetValue(cNR,NIL,thsdvRDiv:ExactValue(.T.))
    
            endif
    
        endif
    
        if lNeg
            thsdvNR:__cSig("-")
        endif

    end Sequence

return(thsdvNR:Clone())

/*
    method      : Divmethod
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 24/03/2014
    Descricao   : Setar o metodo de Divisao a ser utilizado
    Sintaxe     : tBigNumber():Divmethod(nmethod) -> nLstmethod
*/
method Divmethod(nmethod) CLASS tBigNumber
    local nLstmethod
    DEFAULT __nDivMeth:= __DIVMETHOD__
    DEFAULT nmethod:= __nDivMeth
    nLstmethod:= __nDivMeth
    __nDivMeth:=nmethod
return(nLstmethod)

/*
    method      : Mod
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2013
    Descricao   : Resto da Divisao
    Sintaxe     : tBigNumber():Mod(uBigN) -> oMod
*/
method Mod(uBigN) CLASS tBigNumber
    local oMod:=tBigNumber():New(uBigN)
    local nCmp:=self:cmp(oMod)
    if nCmp==-1
        oMod:SetValue(self)
    Elseif nCmp==0
        oMod:SetValue(__o0)
    Else
        oMod:SetValue(self:Div(oMod,.F.))
        oMod:SetValue(oMod:cRDiv,NIL,NIL,.F.)
    endif    
return(oMod)

/*
    method      : Pow
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2013
    Descricao   : Caltulo de Potencia
    Sintaxe     : tBigNumber():Pow(uBigN) -> oBigNR
*/
method Pow(uBigN) CLASS tBigNumber

#ifndef __PTCOMPAT__
    local aThreads
#endif

    local oSelf:=self:Clone()
    
    local cM10
    
    local cPowB
    local cPowA
    
    local lPoWN
    local lPowF
    
    local nZS

    lPoWN:=thspwNP:SetValue(uBigN):lt(__o0)

    BEGIN SEQUENCE

        if oSelf:eq(__o0) .and. thspwNP:eq(__o0)
            thspwNR:SetValue(__o1)
            break
        endif

        if oSelf:eq(__o0)
            thspwNR:SetValue(__o0)
            break
        endif

        if thspwNP:eq(__o0)
            thspwNR:SetValue(__o1)
            break
        endif

        thspwNR:SetValue(oSelf)

        if thspwNR:eq(__o1)
            thspwNR:SetValue(__o1)
            break
        endif

        if __o1:eq(thspwNP:SetValue(thspwNP:Abs()))
            break
        endif

        lPowF:=thspwA:SetValue(thspwNP:cDec):gt(__o0)
        
        if lPowF

            cPowA:=thspwNP:cInt+thspwNP:Dec(NIL,NIL,.T.)
            thspwA:SetValue(cPowA)

            nZS:=hb_bLen(thspwNP:Dec(NIL,NIL,.T.))
            IncZeros(nZS)
            
            cM10:="1"
            cM10+=SubStr(thscstcZ0,1,nZS)
            
            cPowB:=cM10

            if thspwB:SetValue(cPowB):gt(__o1)
                thspwGCD:SetValue(thspwA:GCD(thspwB))
                #ifndef __PTCOMPAT__
                    aThreads:=Array(2,2)
                    aThreads[1][1]:=hb_threadStart(@thDiv(),thspwA,thspwGCD)
                    aThreads[1][2]:=hb_threadStart(@thDiv(),thspwB,thspwGCD)
                    hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                    hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                    hb_threadWait(aThreads[1])
                    thspwA:SetValue(aThreads[2][1])
                    thspwB:SetValue(aThreads[2][2])
                #else
                    thspwA:SetValue(thspwA:Div(thspwGCD))
                    thspwB:SetValue(thspwB:Div(thspwGCD))
                #endif
            endif

            thspwA:Normalize(@thspwB)
    
            thspwNP:SetValue(thspwA)

        endif

        thspwNT:SetValue(__o0)
        thspwNP:SetValue(thspwNP:OpDec())
        while thspwNT:lt(thspwNP)
            thspwNR:SetValue(thspwNR:Mult(oSelf))
            thspwNT:SetValue(thspwNT:OpInc())
        end while

        if lPowF
            thspwNR:SetValue(thspwNR:nthRoot(thspwB))
        endif

    end SEQUENCE

    if lPoWN
        thspwNR:SetValue(__o1:Div(thspwNR))    
    endif

return(thspwNR:Clone())

/*
    method      : OpInc
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Incrementa em 1
    Sintaxe     : tBigNumber():OpInc() -> oBigNR
*/
method OpInc() CLASS tBigNumber
#ifdef __PTCOMPAT__
    return(self:Add(__o1))
#else        
    return(self:SetValue(tBIGNiADD(self:cInt,1,self:nBase)))
#endif    

/*
    method      : OpDec
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Decrementa em 1
    Sintaxe     : tBigNumber():OpDec() -> oBigNR
*/
method OpDec() CLASS tBigNumber
#ifdef __PTCOMPAT__
    return(self:Sub(__o1))
#else
    return(self:SetValue(tBIGNiSUB(self:cInt,1,self:nBase)))
#endif    


/*
    method      : e
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : Retorna o Numero de Neper (2.718281828459045235360287471352662497757247...)
    Sintaxe     : tBigNumber():e(lforce) -> oeTthD
    (((n+1)^(n+1))/(n^n))-((n^n)/((n-1)^(n-1)))
*/
method e(lforce) CLASS tBigNumber

    local oeTthD

    local oPowN
    local oDiv1P
    local oDiv1S
    local oBigNC
    local oAdd1N
    local oSub1N
    local oPoWNAd
    local oPoWNS1

    BEGIN SEQUENCE
        
        DEFAULT lforce:=.F.

        if .not.(lforce)

            oeTthD:=__o0:Clone()
            oeTthD:SetValue(__eTthD())

            break

        endif

        oBigNC:=self:Clone()
        
        if oBigNC:eq(__o0)
            oBigNC:SetValue(__o1)
        endif

        oPowN:=oBigNC:Clone()
        
        oPowN:SetValue(oPowN:Pow(oPowN))
        
        oAdd1N:=oBigNC:OpInc()
        oSub1N:=oBigNC:OpDec()

        oPoWNAd:=oAdd1N:Pow(oAdd1N)
        oPoWNS1:=oSub1N:Pow(oSub1N)
        
        oDiv1P:=oPoWNAd:Div(oPowN)
        oDiv1S:=oPowN:Div(oPoWNS1)

        oeTthD:SetValue(oDiv1P:Sub(oDiv1S))

    end SEQUENCE

return(oeTthD)

/*
    method    : Exp
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 06/02/2013
    Descricao : Potencia do Numero de Neper e^cN
    Sintaxe   : tBigNumber():Exp(lforce) -> oBigNR
*/
method Exp(lforce) CLASS tBigNumber
    local oBigNe:=self:e(lforce)
    local oBigNR:=oBigNe:Pow(self)
return(oBigNR)

/*
    method    : PI
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 04/02/2013
    Descricao : Retorna o Numero Irracional PI (3.1415926535897932384626433832795...)
    Sintaxe   : tBigNumber():PI(lforce) -> oPITthD
*/
method PI(lforce) CLASS tBigNumber
    
    local oPITthD

    DEFAULT lforce:=.F.

    BEGIN SEQUENCE

        lforce:=.F.    //TODO: Implementar o calculo.

        if .not.(lforce)

            oPITthD:=__o0:Clone()
            oPITthD:SetValue(__PITthD())

            break

        endif

        //TODO: Implementar o calculo,Depende de Pow com Expoente Fracionario

    end SEQUENCE

return(oPITthD)

/*
    method    : GCD
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 23/02/2013
    Descricao : Retorna o GCD/MDC
    Sintaxe   : tBigNumber():GCD(uBigN) -> oGCD
*/
method GCD(uBigN) CLASS tBigNumber

    local oX:=self:Clone()
    local oY:=tBigNumber():New(uBigN)
     
    local oGCD  
     
    oX:SetValue(oY:Max(self))
    oY:SetValue(oY:Min(self))

    if oY:eq(__o0)
        oGCD:=oX
    Else
        oGCD:=oY:Clone()
        if oX:lte(__oMinGCD).and.oY:lte(__oMinGCD)
            oGCD:SetValue(cGCD(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
        Else
            while .T.
                oY:SetValue(oX:Mod(oY))
                if oY:eq(__o0)
                    exit
                endif
                oX:SetValue(oGCD)
                oGCD:SetValue(oY)
            end while
        endif
    endif 

return(oGCD)

static function cGCD(nX,nY)
    #ifndef __PTCOMPAT__
        local nGCD:=TBIGNGDC(nX,nY)
    #else //__PROTHEUS__
        local nGCD:=nX
        nX:=Max(nY,nGCD)
        nY:=Min(nGCD,nY)
        if nY==0
            nGCD:=nX
        Else
            nGCD:=nY
            while .T.
                if (nY:=(nX%nY))==0
                    exit
                endif
                nX:=nGCD
                nGCD:=nY
            end while
        endif
    #endif //__PTCOMPAT__
return(hb_ntos(nGCD))

/*
    method    : LCM
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 23/02/2013
    Descricao : Retorna o LCM/MMC
    Sintaxe   : tBigNumber():LCM(uBigN) -> oLCM
*/
method LCM(uBigN) CLASS tBigNumber

#ifndef __PTCOMPAT__
    local aThreads
#endif
    
    local oX:=self:Clone()
    local oY:=tBigNumber():New(uBigN)

    local oI:=__o2:Clone()
    
    local oLCM:=__o1:Clone()
    
    local lMX
    local lMY
    
    if oX:nInt<=__nMinLCM.and.oY:nInt<=__nMinLCM
        oLCM:SetValue(cLCM(Val(oX:Int(.F.,.F.)),Val(oY:Int(.F.,.F.))))
    Else
        #ifndef __PTCOMPAT__
            aThreads:=Array(2,2)
        #endif    
        while .T.
            #ifndef __PTCOMPAT__
                aThreads[1][1]:=hb_threadStart(@thMod0(),oX,oI)
                aThreads[1][2]:=hb_threadStart(@thMod0(),oY,oI)
                hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                hb_threadWait(aThreads[1])
                lMX:=aThreads[2][1]
                lMY:=aThreads[2][2]
            #else
                lMX:=oX:Mod(oI):eq(__o0)
                lMY:=oY:Mod(oI):eq(__o0)
            #endif    
            while lMX .or. lMY
                oLCM:SetValue(oLCM:Mult(oI))
                #ifndef __PTCOMPAT__
                    if lMX .and. lMY                    
                        aThreads[1][1]:=hb_threadStart(@thDiv(),oX,oI,.F.)
                        aThreads[1][2]:=hb_threadStart(@thDiv(),oY,oI,.F.)
                        hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                        hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                        hb_threadWait(aThreads[1])
                        oX:SetValue(aThreads[2][1])
                        oY:SetValue(aThreads[2][2])
                        aThreads[1][1]:=hb_threadStart(@thMod0(),oX,oI)
                        aThreads[1][2]:=hb_threadStart(@thMod0(),oY,oI)
                        hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                        hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                        hb_threadWait(aThreads[1])
                        lMX:=aThreads[2][1]
                        lMY:=aThreads[2][2]
                    Else
                        if lMX
                            oX:SetValue(oX:Div(oI,.F.))
                            lMX:=oX:Mod(oI):eq(__o0)
                        endif
                        if lMY
                            oY:SetValue(oY:Div(oI,.F.))
                            lMY:=oY:Mod(oI):eq(__o0)
                        endif
                    endif    
                #else
                    if lMX
                        oX:SetValue(oX:Div(oI,.F.))
                        lMX:=oX:Mod(oI):eq(__o0)
                    endif
                    if lMY
                        oY:SetValue(oY:Div(oI,.F.))
                        lMY:=oY:Mod(oI):eq(__o0)
                    endif
                #endif    
            end while
            if oX:eq(__o1) .and. oY:eq(__o1)
                exit
            endif
            oI:SetValue(oI:OpInc())        
        end while
    endif
    
return(oLCM)

static function cLCM(nX,nY)
    #ifndef __PTCOMPAT__
        local nLCM:=TBIGNLCM(nX,nY)
    #else //__PROTHEUS__
        local nLCM:=1
        local nI:=2
        local lMX
        local lMY
        while .T.
            lMX:=(nX%nI)==0
            lMY:=(nY%nI)==0
            while lMX .or. lMY
                nLCM *= nI
                if lMX
                    nX:=Int(nX/nI)
                    lMX:=(nX%nI)==0
                endif
                if lMY
                    nY:=Int(nY/nI)
                    lMY:=(nY%nI)==0
                endif
            end while
            if nX==1 .and. nY==1
                exit
            endif
            ++nI
        end while
    #endif //__PTCOMPAT__    
return(hb_ntos(nLCM))

/*

    method    : nthRoot
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 05/03/2013
    Descricao : Radiciacao 
    Sintaxe   : tBigNumber():nthRoot(uBigN) -> othRoot
*/
method nthRoot(uBigN) CLASS tBigNumber

    local cFExit

    local nZS

    local oRootB:=self:Clone()
    local oRootE
    
    local othRoot:=__o0:Clone()

    local oFExit

    BEGIN SEQUENCE

        if oRootB:eq(__o0)
            break
        endif

        if oRootB:lNeg
            break
        endif

        if oRootB:eq(__o1)
            othRoot:SetValue(__o1)
            break
        endif

        oRootE:=tBigNumber():New(uBigN)

        if oRootE:eq(__o0)
            break
        endif

        if oRootE:eq(__o1)
            othRoot:SetValue(oRootB)
            break
        endif

        nZS:=__nthRootAcc-1
        IncZeros(nZS)
        
        cFExit:="0."+SubStr(thscstcZ0,1,nZS)+"1"
            
        oFExit:=__o0:Clone()
        oFExit:SetValue(cFExit,NIL,NIL,NIL,__nthRootAcc)

        othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

    end SEQUENCE

return(othRoot)

/*

    method    : nthRootPF
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 05/03/2013
    Descricao : Radiciacao utilizando Fatores Primos
    Sintaxe   : tBigNumber():nthRootPF(uBigN) -> othRoot
*/
method nthRootPF(uBigN) CLASS tBigNumber

    local aIPF
    local aDPF

    local cFExit
    
    local lDec

    local nZS
    
    local nPF
    local nPFs

    local oRootB:=self:Clone()
    local oRootD
    local oRootE

    local oRootT

    local othRoot:=__o0:Clone()
    local othRootD

    local oFExit

    BEGIN SEQUENCE

        if oRootB:eq(__o0)
            break
        endif

        if oRootB:lNeg
            break
        endif

        if oRootB:eq(__o1)
            othRoot:SetValue(__o1)
            break
        endif

        oRootE:=tBigNumber():New(uBigN)

        if oRootE:eq(__o0)
            break
        endif

        if oRootE:eq(__o1)
            othRoot:SetValue(oRootB)
            break
        endif
        
        oRootT:=__o0:Clone()

        nZS:=__nthRootAcc-1
        IncZeros(nZS)
    
        cFExit:="0."+SubStr(thscstcZ0,1,nZS)+"1"
            
        oFExit:=__o0:Clone()
        oFExit:SetValue(cFExit,NIL,NIL,NIL,__nthRootAcc)

        lDec:=oRootB:Dec(.T.):gt(__o0)
        
        if lDec
            
            nZS:=hb_bLen(oRootB:Dec(NIL,NIL,.T.))
            IncZeros(nZS)
            
            oRootD:=tBigNumber():New("1"+SubStr(thscstcZ0,1,nZS))
            oRootT:SetValue(oRootB:cInt+oRootB:cDec)
            
            aIPF:=oRootT:PFactors()
            aDPF:=oRootD:PFactors()

        Else
        
            aIPF:=oRootB:PFactors()
            aDPF:=Array(0)
        
        endif

        nPFs:=tBIGNaLen(aIPF)

        if nPFs>0
            othRoot:SetValue(__o1)
            othRootD:=__o0:Clone()
            oRootT:SetValue(__o0)
            for nPF:=1 to nPFs
                if oRootE:eq(aIPF[nPF][2])
                    othRoot:SetValue(othRoot:Mult(aIPF[nPF][1]))
                Else
                    oRootT:SetValue(aIPF[nPF][1])
                    oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
                    oRootT:SetValue(oRootT:Pow(aIPF[nPF][2]))
                    othRoot:SetValue(othRoot:Mult(oRootT))
                endif    
            next nPF
            if .not.(Empty(aDPF))
                nPFs:=tBIGNaLen(aDPF)
                if nPFs>0
                    othRootD:SetValue(__o1)
                    for nPF:=1 to nPFs
                        if oRootE:eq(aDPF[nPF][2])
                            othRootD:SetValue(othRootD:Mult(aDPF[nPF][1]))
                        Else
                            oRootT:SetValue(aDPF[nPF][1])
                            oRootT:SetValue(nthRoot(oRootT,oRootE,oFExit))
                            oRootT:SetValue(oRootT:Pow(aDPF[nPF][2]))
                            othRootD:SetValue(othRootD:Mult(oRootT))
                        endif
                    next nPF
                    if othRootD:gt(__o0)
                        othRoot:SetValue(othRoot:Div(othRootD))    
                    endif
                endif    
            endif
            break
        endif

        othRoot:SetValue(nthRoot(oRootB,oRootE,oFExit))

    end SEQUENCE

return(othRoot)

/*
    method    : SQRT
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 06/03/2013
    Descricao : Retorna a Raiz Quadrada (radix quadratum -> O Lado do Quadrado) do Numero passado como parametro
    Sintaxe   : tBigNumber():SQRT() -> oSQRT
*/
method SQRT() CLASS tBigNumber

    local oSQRT:=self:Clone()    
    
    BEGIN SEQUENCE

        if oSQRT:lte(oSQRT:SysSQRT())
            oSQRT:SetValue(__SQRT(hb_ntos(Val(oSQRT:GetValue()))))
            break
        endif

        if oSQRT:eq(__o0)
            oSQRT:SetValue(__o0)
            break
        endif

        oSQRT:SetValue(__SQRT(oSQRT))

    end SEQUENCE

return(oSQRT)

/*
    method    : SysSQRT
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 06/03/2013
    Descricao : Define o valor maximo para calculo da SQRT considerando a funcao padrao
    Sintaxe   : tBigNumber():SysSQRT(uSet) -> oSysSQRT
*/
method SysSQRT(uSet) CLASS tBigNumber

    local cType
    
    cType:=ValType(uSet)
    if ( cType $ "C|N|O" )
        thsSysSQRT:SetValue(if(cType$"C|O",uSet,if(cType=="N",hb_ntos(uSet),"0")))
        if thsSysSQRT:gt(MAX_SYS_SQRT)
            thsSysSQRT:SetValue(MAX_SYS_SQRT)
        endif
    endif
    
return(thsSysSQRT)

/*
    method      : Log
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o logaritmo na Base N DEFAULT 10
    Sintaxe     : tBigNumber():Log(Log(uBigNB) -> oBigNR
    Referencia  : //http://www.vivaolinux.com.br/script/Calculo-de-logaritmo-de-um-numero-por-um-terceiro-metodo-em-C
*/
method Log(uBigNB) CLASS tBigNumber

#ifndef __PTCOMPAT__
    local aThreads:=Array(2,2)
#endif

    local oS:=__o0:Clone()
    local oT:=__o0:Clone()
    local oI:=__o1:Clone()
    local oX:=self:Clone()
    local oY:=__o0:Clone()
    local oLT:=__o0:Clone()
    
    local noTcmp1

    local lflag:=.F.
    
    if oX:eq(__o0)
        return(__o0:Clone())
    endif

    DEFAULT uBigNB:=self:e()

    oT:SetValue(uBigNB)

    noTcmp1:=oT:cmp(__o1)
    if noTcmp1==0
        return(__o0:Clone())
    endif
    
    if __o0:lt(oT) .and. noTcmp1==-1
         lflag:=.not.(lflag)
         oT:SetValue(__o1:Div(oT))
         noTcmp1:=oT:cmp(__o1)
    endif

    while oX:gt(oT) .and. noTcmp1==1
        #ifndef __PTCOMPAT__
            aThreads[1][1]:=hb_threadStart(@thAdd(),oY,oI)
           aThreads[1][2]:=hb_threadStart(@thDiv(),oX,oT)
            hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
            hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
            hb_threadWait(aThreads[1])
            oY:SetValue(aThreads[2][1])
            oX:SetValue(aThreads[2][2])
        #else
            oY:SetValue(oY:Add(oI))
            oX:SetValue(oX:Div(oT))
        #endif    
    end while 

    oS:SetValue(oS:Add(oY))
    oY:SetValue(__o0)
    #ifndef __PTCOMPAT__
        aThreads[1][1]:=hb_threadStart(@thnthRoot(),oT,__o2)
        aThreads[1][2]:=hb_threadStart(@thMult(),oI,__od2)
        hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
        hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
        hb_threadWait(aThreads[1])
        oT:SetValue(aThreads[2][1])
        oI:SetValue(aThreads[2][2])
    #else
        oT:SetValue(oT:nthRoot(__o2))
        oI:SetValue(oI:Mult(__od2))
    #endif    

    noTcmp1:=oT:cmp(__o1)
    
    while noTcmp1==1

        while oX:gt(oT) .and. noTcmp1==1
            #ifndef __PTCOMPAT__
                aThreads[1][1]:=hb_threadStart(@thAdd(),oY,oI)
                aThreads[1][2]:=hb_threadStart(@thDiv(),oX,oT)
                hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
                hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
                hb_threadWait(aThreads[1])
                oY:SetValue(aThreads[2][1])
                oX:SetValue(aThreads[2][2])
            #else
                oY:SetValue(oY:Add(oI))
                oX:SetValue(oX:Div(oT))
            #endif    
        end while 
    
        oS:SetValue(oS:Add(oY))
        
        oY:SetValue(__o0)
        
        oLT:SetValue(oT)
        
        oT:SetValue(oT:nthRoot(__o2))
        
        if oT:eq(oLT)
            exit    
        endif 
        
        oI:SetValue(oI:Mult(__od2))
  
        noTcmp1:=oT:cmp(__o1)

    end while

    if lflag
        oS:SetValue(oS:Mult("-1"))
    endif    

return(oS)

/*
    method      : Log2
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o logaritmo Base 2
    Sintaxe     : tBigNumber():Log2() -> oBigNR
*/
method Log2() CLASS tBigNumber
    local ob2:=__o2:Clone()
return(self:Log(ob2))

/*
    method      : Log10
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o logaritmo Base 10
    Sintaxe     : tBigNumber():Log10() -> oBigNR
*/
method Log10() CLASS tBigNumber
    local ob10:=__o10:Clone()
return(self:Log(ob10))

/*
    method      : Ln
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Logaritmo Natural
    Sintaxe     : tBigNumber():Ln() -> oBigNR
*/
method Ln() CLASS tBigNumber
return(self:Log(__o1:Exp()))

/*
    method      : aLog
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o Antilogaritmo 
    Sintaxe     : tBigNumber():aLog(Log(uBigNB) -> oBigNR
*/
method aLog(uBigNB) CLASS tBigNumber
    local oaLog:=tBigNumber():New(uBigNB)
return(oaLog:Pow(self))

/*
    method      : aLog2
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o Antilogaritmo Base 2
    Sintaxe     : tBigNumber():aLog2() -> oBigNR
*/
method aLog2() CLASS tBigNumber
    local ob2:=__o2:Clone()
return(self:aLog(ob2))

/*
    method      : aLog10
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o Antilogaritmo Base 10
    Sintaxe     : tBigNumber():aLog10() -> oBigNR
*/
method aLog10() CLASS tBigNumber
    local ob10:=__o10:Clone()
return(self:aLog(ob10))

/*
    method      : aLn
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 20/02/2013
    Descricao   : Retorna o AntiLogaritmo Natural
    Sintaxe     : tBigNumber():aLn() -> oBigNR
*/
method aLn() CLASS tBigNumber
return(self:aLog(__o1:Exp()))

/*
    method    : MathC
    Autor     : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data      : 05/03/2013
    Descricao : Operacoes Matematicas
    Sintaxe   : tBigNumber():MathC(uBigN1,cOperator,uBigN2) -> cNR
*/
method MathC(uBigN1,cOperator,uBigN2) CLASS tBigNumber
return(MathO(uBigN1,cOperator,uBigN2,.F.))

/*
    method      : MathN
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Operacoes Matematicas
    Sintaxe     : tBigNumber():MathN(uBigN1,cOperator,uBigN2) -> oBigNR
*/
method MathN(uBigN1,cOperator,uBigN2) CLASS tBigNumber
return(MathO(uBigN1,cOperator,uBigN2,.T.))

/*
    method      : Rnd
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : Rnd arredonda um numero decimal, "para cima", se o digito da precisao definida for >= 5, caso contrario, truca.
    Sintaxe     : tBigNumber():Rnd(nAcc) -> oRND
*/
method Rnd(nAcc) CLASS tBigNumber

    local oRnd:=self:Clone()

    local cAdd
    local cAcc

    DEFAULT nAcc:=Max((Min(oRnd:nDec,__nDecimalSet)-1),0)

    if .not.(oRnd:eq(__o0))
        cAcc:=SubStr(oRnd:cDec,nAcc+1,1)
        if cAcc==""
            cAcc:=SubStr(oRnd:cDec,--nAcc+1,1)
        endif
        if cAcc>="5"
            cAdd:="0."
            IncZeros(nAcc)
            cAdd+=SubStr(thscstcZ0,1,nAcc)+"5"
            oRnd:SetValue(oRnd:Add(cAdd))
        endif
        oRnd:SetValue(oRnd:cInt+"."+SubStr(oRnd:cDec,1,nAcc),NIL,oRnd:cRDiv)
    endif

return(oRnd)

/*
    method      : NoRnd
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : NoRnd trunca um numero decimal
    Sintaxe     : tBigNumber():NoRnd(nAcc) -> oBigNR
*/
method NoRnd(nAcc) CLASS tBigNumber
return(self:Truncate(nAcc))

/*
    method      : Floor
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2014
    Descricao   : Retorna o "Piso" de um Numero Real de acordo com o Arredondamento para "baixo"
    Sintaxe     : tBigNumber():Floor(nAcc) -> oFloor
*/
method Floor(nAcc) CLASS tBigNumber
    local oInt:=self:Int(.T.,.T.)
    local oFloor:=self:Clone()
    DEFAULT nAcc:=Max((Min(oFloor:nDec,__nDecimalSet)-1),0)
    oFloor:SetValue(oFloor:Rnd(nAcc):Int(.T.,.T.))
    oFloor:SetValue(oFloor:Min(oInt))
return(oFloor)

/*
    method      : Ceiling
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 05/03/2014
    Descricao   : Retorna o "Teto" de um Numero Real de acordo com o Arredondamento para "cima"
    Sintaxe     : tBigNumber():Ceiling(nAcc) -> oCeiling
*/
method Ceiling(nAcc) CLASS tBigNumber
    local oInt:=self:Int(.T.,.T.)
    local oCeiling:=self:Clone()
    DEFAULT nAcc:=Max((Min(oCeiling:nDec,__nDecimalSet)-1),0)
    oCeiling:SetValue(oCeiling:Rnd(nAcc):Int(.T.,.T.))
    oCeiling:SetValue(oCeiling:Max(oInt))
return(oCeiling)

/*
    method      : Truncate
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 06/02/2013
    Descricao   : Truncate trunca um numero decimal
    Sintaxe     : tBigNumber():Truncate(nAcc) -> oTrc
*/
method Truncate(nAcc) CLASS tBigNumber

    local oTrc:=self:Clone()
    local cDec:=oTrc:cDec

    if .not.(__o0:eq(cDec))
        DEFAULT nAcc:=Min(oTrc:nDec,__nDecimalSet)
        cDec:=SubStr(cDec,1,nAcc)
        oTrc:SetValue(oTrc:cInt+"."+cDec)
    endif

return(oTrc)

/*
    method      : Normalize
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Normaliza os Dados
    Sintaxe     : tBigNumber():Normalize(oBigN) -> self
*/
method Normalize(oBigN) CLASS tBigNumber
#ifdef __PTCOMPAT__    
    local nPadL:=Max(self:nInt,oBigN:nInt)
    local nPadR:=Max(self:nDec,oBigN:nDec)
    local nSize:=(nPadL+nPadR)
    
    local lPadL:=nPadL!=self:nInt
    local lPadR:=nPadR!=self:nDec

    IncZeros(nSize)
    
    if lPadL .or. lPadR
        if lPadL
            self:cInt:=SubStr(thscstcZ0,1,nPadL-self:nInt)+self:cInt
            self:nInt:=nPadL
        endif
        if lPadR
            self:cDec+=SubStr(thscstcZ0,1,nPadR-self:nDec)
            self:nDec:=nPadR
        endif
        self:nSize:=nSize
    endif

    lPadL:=nPadL!=oBigN:nInt
    lPadR:=nPadR!=oBigN:nDec 
    
    if lPadL .or. lPadR
        if lPadL
            oBigN:cInt:=SubStr(thscstcZ0,1,nPadL-oBigN:nInt)+oBigN:cInt
            oBigN:nInt:=nPadL
        endif
        if lPadR
            oBigN:cDec+=SubStr(thscstcZ0,1,nPadR-oBigN:nDec)
            oBigN:nDec:=nPadR
        endif
        oBigN:nSize:=nSize
    endif
#else    
    tBIGNNormalize(@self:cInt,@self:nInt,@self:cDec,@self:nDec,@self:nSize,@oBigN:cInt,@oBigN:nInt,@oBigN:cDec,@oBigN:nDec,@oBigN:nSize)
#endif    
return(self)

/*
    method      : D2H
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Decimal para Hexa
    Sintaxe     : tBigNumber():D2H(cHexB) -> cHexN
*/
method D2H(cHexB) CLASS tBigNumber

    local otH:=__o0:Clone()
    local otN:=tBigNumber():New(self:cInt)

    local cHexN:=""
    local cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"

    local cInt
    local cDec
    local cSig:=self:cSig

    local oHexN

    local nAT
    
    DEFAULT cHexB:="16"

    otH:SetValue(cHexB)
    
    while otN:gt(__o0)
        otN:SetValue(otN:Div(otH,.F.))
        nAT:=Val(otN:cRDiv)+1
        cHexN:=SubStr(cHexC,nAT,1)+cHexN
    end while

    if cHexN==""
        cHexN:="0"        
    endif

    cInt:=cHexN

    cHexN:=""
    otN:=tBigNumber():New(self:Dec(NIL,NIL,.T.))

    while otN:gt(__o0)
        otN:SetValue(otN:Div(otH,.F.))
        nAT:=Val(otN:cRDiv)+1
        cHexN:=SubStr(cHexC,nAT,1)+cHexN
    end while

    if cHexN==""
        cHexN:="0"        
    endif

    cDec:=cHexN

    oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

return(oHexN)

/*
    method      : H2D
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Hexa para Decimal
    Sintaxe     : tBigNumber():H2D() -> otNR
*/
method H2D() CLASS tBigNumber

    local otH:=__o0:Clone()
    local otNR:=__o0:Clone()
    local otLN:=__o0:Clone()
    local otPw:=__o0:Clone()
    local otNI:=__o0:Clone()
    local otAT:=__o0:Clone()

    local cHexB:=hb_ntos(self:nBase)
    local cHexC:="0123456789ABCDEFGHIJKLMNOPQRSTUV"
    local cHexN:=self:cInt
    
    local cInt
    local cDec
    local cSig:=self:cSig

    local nLn:=hb_bLen(cHexN)
    local nI:=nLn

    otH:SetValue(cHexB)
    otLN:SetValue(hb_ntos(nLn))

    while nI>0
        otNI:SetValue(hb_ntos(--nI))
        otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1))) 
        otPw:SetValue(otLN:Sub(otNI))
        otPw:SetValue(otPw:OpDec())
        otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    end while

    cInt:=otNR:cInt

    cHexN:=self:cDec
    nLn:=self:nDec
    nI:=nLn

    otLN:SetValue(hb_ntos(nLn))

    while nI>0
        otNI:SetValue(hb_ntos(--nI))
        otAT:SetValue(hb_ntos((AT(SubStr(cHexN,nI+1,1),cHexC)-1)))
        otPw:SetValue(otLN:Sub(otNI))
        otPw:SetValue(otPw:OpDec())
        otPw:SetValue(otH:Pow(otPw))
        otAT:SetValue(otAT:Mult(otPw))
        otNR:SetValue(otNR:Add(otAT))
    end while

    cDec:=otNR:cDec

    otNR:SetValue(cSig+cInt+"."+cDec)

return(otNR)

/*
    method      : H2B
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Hex para Bin
    Sintaxe     : tBigNumber():H2B(cHexN) -> cBin
*/
method H2B() CLASS tBigNumber

    local aH2B:={;
                            {"0","00000"},;
                            {"1","00001"},;
                            {"2","00010"},;
                            {"3","00011"},;
                            {"4","00100"},;
                            {"5","00101"},;
                            {"6","00110"},;
                            {"7","00111"},;
                            {"8","01000"},;
                            {"9","01001"},;
                            {"A","01010"},;
                            {"B","01011"},;
                            {"C","01100"},;
                            {"D","01101"},;
                            {"E","01110"},;
                            {"F","01111"},;
                            {"G","10000"},;
                            {"H","10001"},;
                            {"I","10010"},;
                            {"J","10011"},;
                            {"K","10100"},;
                            {"L","10101"},;
                            {"M","10110"},;
                            {"N","10111"},;
                            {"O","11000"},;
                            {"P","11001"},;
                            {"Q","11010"},;
                            {"R","11011"},;
                            {"S","11100"},;
                            {"T","11101"},;
                            {"U","11110"},;
                            {"V","11111"};
                        }

    local cChr
    local cBin:=""

    local cInt
    local cDec

    local cSig:=self:cSig
    local cHexB:=hb_ntos(self:nBase)
    local cHexN:=self:cInt

    local oBin:=tBigNumber():New(NIL,2)

    local nI:=0
    local nLn:=hb_bLen(cHexN)
    local nAT

    local l16

    BEGIN SEQUENCE

        if Empty(cHexB)
             break
        endif

        if .not.(cHexB $ "[16][32]")
            break
        endif

        l16:=cHexB=="16"

        while ++nI<=nLn
            cChr:=SubStr(cHexN,nI,1)
            nAT:=aScan(aH2B,{|aE|(aE[1]==cChr)})
            if nAT>0
                cBin+=if(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
            endif
        end while

        cInt:=cBin

        nI:=0
        cBin:=""
        cHexN:=self:cDec
        nLn:=self:nDec
        
        while ++nI<=nLn
            cChr:=SubStr(cHexN,nI,1)
            nAT:=aScan(aH2B,{|aE|(aE[1]==cChr)})
            if nAT>0
                cBin+=if(l16,SubStr(aH2B[nAT][2],2),aH2B[nAT][2])
            endif
        end while

        cDec:=cBin

        oBin:SetValue(cSig+cInt+"."+cDec)

    end SEQUENCE

return(oBin)

/*
    method      : B2H
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 07/02/2013
    Descricao   : Converte Bin para Hex
    Sintaxe     : tBigNumber():B2H(cHexB) -> cHexN
*/
method B2H(cHexB) CLASS tBigNumber
    
    local aH2B:={;
                            {"0","00000"},;
                            {"1","00001"},;
                            {"2","00010"},;
                            {"3","00011"},;
                            {"4","00100"},;
                            {"5","00101"},;
                            {"6","00110"},;
                            {"7","00111"},;
                            {"8","01000"},;
                            {"9","01001"},;
                            {"A","01010"},;
                            {"B","01011"},;
                            {"C","01100"},;
                            {"D","01101"},;
                            {"E","01110"},;
                            {"F","01111"},;
                            {"G","10000"},;
                            {"H","10001"},;
                            {"I","10010"},;
                            {"J","10011"},;
                            {"K","10100"},;
                            {"L","10101"},;
                            {"M","10110"},;
                            {"N","10111"},;
                            {"O","11000"},;
                            {"P","11001"},;
                            {"Q","11010"},;
                            {"R","11011"},;
                            {"S","11100"},;
                            {"T","11101"},;
                            {"U","11110"},;
                            {"V","11111"};
                        }

    local cChr
    local cInt
    local cDec
    local cSig:=self:cSig
    local cBin:=self:cInt
    local cHexN:=""

    local oHexN

    local nI:=1
    local nLn:=hb_bLen(cBin)
    local nAT

    local l16
    
    BEGIN SEQUENCE

        if Empty(cHexB)
            break
        endif

        if .not.(cHexB $ "[16][32]")
            oHexN:=tBigNumber():New(NIL,16)
            break
        endif

        l16:=cHexB=="16"

        while nI<=nLn
            cChr:=SubStr(cBin,nI,if(l16,4,5))
            nAT:=aScan(aH2B,{|aE|(if(l16,SubStr(aE[2],2),aE[2])==cChr)})
            if nAT>0
                cHexN+=aH2B[nAT][1]
            endif
            nI+=if(l16,4,5)
        end while
    
        cInt:=cHexN

        nI:=1
        cBin:=self:cDec
        nLn:=self:nDec
        cHexN:=""

        while nI<=nLn
            cChr:=SubStr(cBin,nI,if(l16,4,5))
            nAT:=aScan(aH2B,{|aE|(if(l16,SubStr(aE[2],2),aE[2])==cChr)})
            if nAT>0
                cHexN+=aH2B[nAT][1]
            endif
            nI+=if(l16,4,5)
        end while

        cDec:=cHexN

        oHexN:=tBigNumber():New(cSig+cInt+"."+cDec,Val(cHexB))

    end SEQUENCE

return(oHexN)

/*
    method      : D2B
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 23/03/2013
    Descricao   : Converte Dec para Bin
    Sintaxe     : tBigNumber():D2B(cHexB) -> oBin
*/
method D2B(cHexB) CLASS tBigNumber
    local oHex:=self:D2H(cHexB)
    local oBin:=oHex:H2B()
return(oBin)

/*
    method      : B2D
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 23/03/2013
    Descricao   : Converte Bin para Dec
    Sintaxe     : tBigNumber():B2D(cHexB) -> oDec
*/
method B2D(cHexB) CLASS tBigNumber
    local oHex:=self:B2H(cHexB) 
    local oDec:=oHex:H2D()
return(oDec)

/*
    method      : Randomize
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Randomize BigN Integer
    Sintaxe     : tBigNumber():Randomize(uB,uE,nExit) -> oR
*/
method Randomize(uB,uE,nExit) CLASS tBigNumber

    local aE
    
    local oB:=__o0:Clone()
    local oE:=__o0:Clone()
    local oT:=__o0:Clone()
    local oM:=__o0:Clone()
    local oR:=__o0:Clone()

    local cR:=""

    local nB
    local nE
    local nR
    local nS
    local nT

    local lI

    #ifdef __HARBOUR__
        oM:SetValue("9999999999999999999999999999")
    #else //__PROTHEUS__
        oM:SetValue("999999999")
    #endif    

    DEFAULT uB:="1"
    DEFAULT uE:=oM:ExactValue()

    oB:SetValue(uB)
    oE:SetValue(uE)

    oB:SetValue(oB:Int(.T.):Abs(.T.))
    oE:SetValue(oE:Int(.T.):Abs(.T.))
    
    oT:SetValue(oB:Min(oE))
    oE:SetValue(oB:Max(oE))
    oB:SetValue(oT)

    BEGIN SEQUENCE
    
        if oB:gt(oM)
    
            nE:=Val(oM:ExactValue())
            nB:=Int(nE/2)
            nR:=__Random(nB,nE)
            cR:=hb_ntos(nR)
            
            oR:SetValue(cR)
            
            lI:=.F.
            nS:=oE:nInt
            
            while oR:lt(oM)
                nR:=__Random(nB,nE)
                cR+=hb_ntos(nR)
                nT:=nS
                if lI
                    while nT>0
                        nR:=-(__Random(1,nS))
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT+=nR
                    end while
                Else
                    while nT>0
                        nR:=__Random(1,nS)
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT -= nR
                    end while
                endif
                lI:=.not.(lI)
            end while
            
            DEFAULT nExit:=EXIT_MAX_RANDOM
            aE:=Array(0)

            nS:=oE:nInt
            
            while oR:lt(oE)
                nR:=__Random(nB,nE)
                cR+=hb_ntos(nR)
                nT:=nS
                if lI
                    while  nT>0
                        nR:=-(__Random(1,nS))
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT+=nR
                    end while
                Else
                    while nT>0
                        nR:=__Random(1,nS)
                        oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                        if oR:gte(oE)
                            exit
                        endif
                        nT -= nR
                    end while
                endif
                lI:=.not.(lI)
                nT:=0
                if aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
                    exit
                endif
                if nT<=RANDOM_MAX_EXIT
                    aAdd(aE,__Random(1,nExit))
                endif
            end while

            break
        
        endif
        
        if oE:lte(oM)
            nB:=Val(oB:ExactValue())
            nE:=Val(oE:ExactValue())
            nR:=__Random(nB,nE)    
            cR+=hb_ntos(nR)
            oR:SetValue(cR)
            break
        endif

        DEFAULT nExit:=EXIT_MAX_RANDOM 
        aE:=Array(0)

        lI:=.F.
        nS:=oE:nInt

        while oR:lt(oE)
            nB:=Val(oB:ExactValue())
            nE:=Val(oM:ExactValue())
            nR:=__Random(nB,nE)
            cR+=hb_ntos(nR)
            nT:=nS
            if lI
                while nT>0
                    nR:=-(__Random(1,nS))
                    oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                    if oR:gte(oE)
                        exit
                    endif
                    nT+=nR
                end while
            Else
                while nT>0
                    nR:=__Random(1,nS)
                    oR:SetValue(oR:Add(SubStr(cR,1,nR)))
                    if oR:gte(oE)
                        exit
                    endif
                    nT    -= nR
                end while
            endif
            lI:=.not.(lI)
            nT:=0
            if aScan(aE,{|n|++nT,n==__Random(1,nExit)})>0
                exit
            endif
            if nT<=RANDOM_MAX_EXIT
                aAdd(aE,__Random(1,nExit))
            endif
        end while
    
    end SEQUENCE
    
    if oR:lt(oB) .or. oR:gt(oE)

        nT:=Min(oE:nInt,oM:nInt)
        while nT>htsnstcN9
            thscstcN9+=thscstcN9
            htsnstcN9+=htsnstcN9
        end while
        cR:=SubStr(thscstcN9,1,nT)
        oT:SetValue(cR)
        cR:=oM:Min(oE:Min(oT)):ExactValue()
        nT:=Val(cR)

        oT:SetValue(oE:Sub(oB):Mult(__od2):Int(.T.))

        while oR:lt(oB)
            oR:SetValue(oR:Add(oT))
            nR:=__Random(1,nT)
            cR:=hb_ntos(nR)
            oR:SetValue(oR:Sub(cR))
        end    while 
    
        while oR:gt(oE)
            oR:SetValue(oR:Sub(oT))
            nR:=__Random(1,nT)
            cR:=hb_ntos(nR)
            oR:SetValue(oR:Add(cR))
        end while

    endif

return(oR)

/*
    function    : __Random
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Define a chamada para a funcao Random Padrao
    Sintaxe     : __Random(nB,nE)
*/
static function __Random(nB,nE)

    local nR

    if nB==0
        nB:=1
    endif

    if nB==nE
        ++nE        
    endif

    #ifdef __HARBOUR__
        nR:=Abs(HB_RandomInt(nB,nE))
    #else //__PROTHEUS__
        nR:=Randomize(nB,nE)        
    #endif    

return(nR)

/*
    method      : millerRabin
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Miller-Rabin method (Primality test)
    Sintaxe     : tBigNumber():millerRabin(uI) -> lPrime
    Ref.:       : http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
method millerRabin(uI) CLASS tBigNumber

    local oN:=self:Clone()
    local oD:=tBigNumber():New(oN:OpDec())
    local oS:=__o0:Clone()
    local oI:=__o0:Clone()
    local oA:=__o0:Clone()

    local lPrime:=.T.

    BEGIN SEQUENCE

        if oN:lte(__o1)
            lPrime:=.F.
            break
        endif

        while oD:Mod(__o2):eq(__o0)
            oD:SetValue(oD:Mult(__od2))
            oS:SetValue(oS:OpInc())
        end while
    
        DEFAULT uI:=__o2:Clone()

        oI:SetValue(uI)
        while oI:gt(__o0)
            oA:SetValue(oA:Randomize(__o1,oN))
            lPrime:=mrPass(oA,oS,oD,oN)
            if .not.(lPrime)
                break
            endif
            oI:SetValue(oI:OpDec())
        end while

    end SEQUENCE

return(lPrime)

/*
    function    : mrPass
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 03/03/2013
    Descricao   : Miller-Rabin Pass (Primality test)
    Sintaxe     : mrPass(uA,uS,uD,uN)
    Ref.:       : http://en.literateprograms.org/Miller-Rabin_primality_test_(Python)
*/
static function mrPass(uA,uS,uD,uN)

    local oA:=tBigNumber():New(uA)
    local oS:=tBigNumber():New(uS)
    local oD:=tBigNumber():New(uD)
    local oN:=tBigNumber():New(uN)
    local oM:=tBigNumber():New(oN:OpDec())

    local oP:=tBigNumber():New(oA:Pow(oD):Mod(oN))
    local oW:=tBigNumber():New(oS:OpDec())
    
    local lmrP:=.T.

    BEGIN SEQUENCE

        if oP:eq(__o1)
            break
        endif

        while oW:gt(__o0)
            lmrP:=oP:eq(oM)
            if lmrP
                break
            endif
            oP:SetValue(oP:Mult(oP):Mod(oN))
            oW:SetValue(oW:OpDec())
        end while

        lmrP:=oP:eq(oM)        

    end SEQUENCE

return(lmrP)

/*
    method      : FI
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/03/2013
    Descricao   : Euler's totient function
    Sintaxe     : tBigNumber():FI() -> oT
    Ref.:       : (Euler's totient function) http://community.topcoder.com/tc?module=static&d1=tutorials&d2=primeNumbers
    Consultar   : http://www.javascripter.net/math/calculators/eulertotientfunction.htm para otimizar.
    
    int fi(int n) 
     {
       int result = n; 
       for(int i=2;i*i<=n;i++) 
       {
         if (n % i==0) result -= result/i; 
         while (n % i==0) n /= i; 
      } 
       if (n>1) result -= result/n; 
       return result; 
    } 
    
*/
method FI() CLASS tBigNumber

    local oC:=self:Clone()
    local oT:=tBigNumber():New(oC:Int(.T.))

    local oI
    local oN
    
    if oT:lte(__oMinFI)
        oT:SetValue(hb_ntos(TBIGNFI(Val(oT:Int(.F.,.F.)))))
    Else
        oI:=__o2:Clone()
        oN:=oT:Clone()
        while oI:Mult(oI):lte(oC)
            if oN:Mod(oI):eq(__o0)
                oT:SetValue(oT:Sub(oT:Div(oI,.F.)))
            endif
            while oN:Mod(oI):eq(__o0)
                oN:SetValue(oN:Div(oI,.F.))
            end while
            oI:SetValue(oI:OpInc())
        end while
        if oN:gt(__o1)
            oT:SetValue(oT:Sub(oT:Div(oN,.F.)))        
        endif
    endif
    
return(oT)
#ifdef __PROTHEUS__
    static function TBIGNFI(n)
        local i:=2
        local fi:=n
        while ((i*i)<=n)
            if ((n%i)==0)
                fi -= Int(fi/i)
            endif
            while ((n%i)==0)
                n:=Int(n/i)
            end while
            i++
        end while
           if (n>1)
               fi -= Int(fi/n)
           endif
    return(fi)
#endif //__PROTHEUS__

/*
    method      : PFactors
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 19/03/2013
    Descricao   : Fatores Primos
    Sintaxe     : tBigNumber():PFactors() -> aPFactors
*/
method PFactors() CLASS tBigNumber
    
    local aPFactors:=Array(0)
    
    local cP:=""

    local oN:=self:Clone()
    local oP:=__o0:Clone()
    local oT:=__o0:Clone()

    local otP:=tPrime():New()
    
    local nP
    local nC:=0
    
    local lPrime:=.T.

    otP:IsPReset()
    otP:nextPReset()

    while otP:nextPrime(cP)
        cP:=LTrim(otP:cPrime)
        oP:SetValue(cP)
        if oP:gte(oN) .or. if(lPrime,lPrime:=otP:IsPrime(oN:cInt),lPrime .or. (++nC>1 .and. oN:gte(otP:cLPrime)))
            aAdd(aPFactors,{oN:cInt,"1"})
            exit
        endif
        while oN:Mod(oP):eq(__o0)
            nP:=aScan(aPFactors,{|e|e[1]==cP})
            if nP==0
                aAdd(aPFactors,{cP,"1"})
            Else
                oT:SetValue(aPFactors[nP][2])
                aPFactors[nP][2]:=oT:SetValue(oT:OpInc()):ExactValue()
            endif
            oN:SetValue(oN:Div(oP,.F.))
            nC:=0
            lPrime:=.T.
        end while
        if oN:lte(__o1)
            exit
        endif
    end while

return(aPFactors)

/*
    method      : Factorial 
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 19/03/2013
    Descricao   : Fatorial de Numeros Inteiros
    Sintaxe     : tBigNumber():Factorial() -> oF
    TODO        : Otimizar. 
                  Referencias: http://www.luschny.de/math/factorial/FastFactorialfunctions.htm
                               http://www.luschny.de/math/factorial/index.html 
*/
method Factorial() CLASS tBigNumber 
    local oN:=self:Clone():Int(.T.,.F.)
    if oN:eq(__o0)
        return(__o1:Clone())
    endif
return(recFact(__o1:Clone(),oN))

/*
    function    : recFact 
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/01/2014
    Descricao   : Fatorial de Numeros Inteiros
    Sintaxe     : recFact(oS,oN)
    Referencias : http://www.luschny.de/math/factorial/FastFactorialfunctions.htm
*/
static function recFact(oS,oN)

#ifndef __PTCOMPAT__
    local aThreads
#endif

    local oI
    local oR:=__o0:Clone()
    local oSN
    local oSI
    local oNI

#ifdef __PTCOMPAT__
    if oN:lte(__o20:Mult(oN:Mult(__od2):Int(.T.,.F.)))
#else
    if oN:lte(__o20)
#endif    
        oR:SetValue(oS)
        oI:=oS:Clone()
        oI:SetValue(oI:OpInc())
        oSN:=oS:Clone()
        oSN:SetValue(oSN:Add(oN)) 
        while oI:lt(oSN)
            oR:SetValue(oR:Mult(oI))            
            oI:SetValue(oI:OpInc())
        end while
        return(oR)
    endif

    oI:=oN:Clone()
    oI:SetValue(oI:Mult(__od2):Int(.T.,.F.))

    oSI:=oS:Clone()
    oSI:SetValue(oSI:Add(oI))

    oNI:=oN:Clone()
    oNI:SetValue(oNI:Sub(oI))

#ifndef __PTCOMPAT__
    aThreads:=Array(2,2)
    aThreads[1][1]:=hb_threadStart(@recFact(),oS,oI)
    aThreads[1][2]:=hb_threadStart(@recFact(),oSI,oNI)
    hb_threadJoin(aThreads[1][1],@aThreads[2][1])                
    hb_threadJoin(aThreads[1][2],@aThreads[2][2])                        
    hb_threadWait(aThreads[1])    
return(aThreads[2][1]:Mult(aThreads[2][2]))
#else    
return(recFact(oS,oI):Mult(recFact(oSI,oNI)))
#endif

/*
    function    : egMult
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Multiplicacao Egipcia (http://cognosco.blogs.sapo.pt/arquivo/1015743.html)
    Sintaxe     : egMult(cN1,cN2,nBase,nAcc) -> oMTP
    Obs.        : Interessante+lenta... Utiliza Soma e Subtracao para obter o resultado
*/
static function egMult(cN1,cN2,nBase,nAcc)

#ifdef __PTCOMPAT__

    local aeMT:=Array(0)
                    
    local nI:=0
    local nCmp
    
    local oN1:=tBigNumber():New(cN1)
    local oMTM:=__o1:Clone()
    local oMTP:=tBigNumber():New(cN2)

    while oMTM:lte(oN1)
        ++nI
        aAdd(aeMT,{oMTM:Int(.F.,.F.),oMTP:Int(.F.,.F.)})
        oMTM:SetValue(oMTM:Add(oMTM),nBase,"0",NIL,nAcc)
        oMTP:SetValue(oMTP:Add(oMTP),nBase,"0",NIL,nAcc)
    end while

    oMTM:SetValue(__o0)
    oMTP:SetValue(__o0)
    
    while nI>0
        oMTM:SetValue(oMTM:Add(aeMT[nI][1]),nBase,"0",NIL,nAcc)
        oMTP:SetValue(oMTP:Add(aeMT[nI][2]),nBase,"0",NIL,nAcc)
        nCmp:=oMTM:cmp(oN1)
        if nCmp==0
            exit
        Elseif nCmp==1
            oMTM:SetValue(oMTM:Sub(aeMT[nI][1]),nBase,"0",NIL,nAcc)
            oMTP:SetValue(oMTP:Sub(aeMT[nI][2]),nBase,"0",NIL,nAcc)
        endif
        --nI
    end while
    
#else

    local oMTP:=__o0:Clone()
    /*thsmtN1:SetValue(cN1)
    thsmtN2:SetValue(cN2)
    if .F. .and. thsmtN1:ibtw(__o0,MAX_SYS_lMULT) .and.  thsmtN2:ibtw(__o0,MAX_SYS_lMULT)
        oMTP:SetValue(hb_ntos(tBigNlMult(Val(cN1),Val(cN2))),nBase,"0",NIL,nAcc)
    Else
        */oMTP:SetValue(TBIGNegMult(cN1,cN2,Len(cN1),nBase),nBase,"0",NIL,nAcc)
    //endif
    
#endif //__PTCOMPAT__
    
return(oMTP)
    
/*
    function    : egDiv
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Divisao Egipcia (http://cognosco.blogs.sapo.pt/13236.html)
    Sintaxe     : egDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> thseDivQ
*/
static function egDiv(cN,cD,nSize,nBase,nAcc,lFloat)

#ifdef __PTCOMPAT__
    local aeDV:=Array(0)
    local nI:=0
    local nCmp
#endif //__PTCOMPAT__

    local cRDiv

#ifndef __PTCOMPAT__
    local cQDiv
#endif //__PTCOMPAT__
    
#ifdef __PTCOMPAT__
 
    SYMBOL_UNUSED( nSize )

    thseDivN:SetValue(cN,nBase,NIL,NIL,nAcc)
    thseDivD:SetValue(cD,nBase,NIL,NIL,nAcc)
    thseDivR:SetValue(__o0,nBase,"0",NIL,nAcc)
    thseDivQ:SetValue(__o0,nBase,"0",NIL,nAcc)

    thseDivDvQ:SetValue(__o1)
    thseDivDvR:SetValue(thseDivD)

    while thseDivDvR:lte(thseDivN)
        ++nI
        aAdd(aeDV,{thseDivDvQ:Int(.F.,.F.),thseDivDvR:Int(.F.,.F.)})
        thseDivDvQ:SetValue(thseDivDvQ:Add(thseDivDvQ),nBase,"0",NIL,nAcc)
        thseDivDvR:SetValue(thseDivDvR:Add(thseDivDvR),nBase,"0",NIL,nAcc)
    end while

    while nI>0
        thseDivQ:SetValue(thseDivQ:Add(aeDV[nI][1]),nBase,"0",NIL,nAcc)
        thseDivR:SetValue(thseDivR:Add(aeDV[nI][2]),nBase,"0",NIL,nAcc)
        nCmp:=thseDivR:cmp(thseDivN)
        if nCmp==0
            exit
        Elseif nCmp==1
            thseDivQ:SetValue(thseDivQ:Sub(aeDV[nI][1]),nBase,"0",NIL,nAcc)
            thseDivR:SetValue(thseDivR:Sub(aeDV[nI][2]),nBase,"0",NIL,nAcc)
        endif
        --nI
    end while

    thseDivR:SetValue(thseDivN:Sub(thseDivR),nBase,"0",NIL,nAcc)

#else //__HARBOUR__

    cQDiv:=tBIGNegDiv(cN,cD,@cRDiv,nSize,nBase)
    
    thseDivQ:SetValue(cQDiv,NIL,"0",NIL,nAcc)
    thseDivR:SetValue(cRDiv,NIL,"0",NIL,nAcc)
    
#endif //__PTCOMPAT__
    
    cRDiv:=thseDivR:Int(.F.,.F.)

    thseDivQ:SetValue(thseDivQ,nBase,cRDiv,NIL,nAcc)
    
    if .not.(lFloat) .and. SubStr(cRDiv,thseDivR:__nInt(),1)=="0"
        cRDiv:=SubStr(cRDiv,1,thseDivR:__nInt()-1)
        if Empty(cRDiv)
            cRDiv:="0"
        endif
        thseDivQ:SetValue(thseDivQ,nBase,cRDiv,NIL,nAcc)
    endif

return(thseDivQ:Clone())

/*
    function    : ecDiv
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 18/03/2014
    Descricao   : Divisao Euclidiana (http://compoasso.free.fr/primelistweb/page/prime/euclide_en.php)
    Sintaxe     : ecDiv(cN,cD,nSize,nBase,nAcc,lFloat) -> q    
 */
static function ecDiv(pA,pB,nSize,nBase,nAcc,lFloat)

#ifdef __PTCOMPAT__

   local a:=tBigNumber():New(pA,nBase) 
   local b:=tBigNumber():New(pB,nBase)
   local r:=a:Clone()

#else
    
    local r:=__o0:Clone()   

#endif   

   local q:=__o0:Clone()

#ifdef __PTCOMPAT__

   local n:=__o1:Clone()
   local aux:=__o0:Clone()
   local tmp:=__o0:Clone()
   local base:=tBigNumber():New(hb_ntos(nBase),nBase)

#endif
   
   local cRDiv

#ifndef __PTCOMPAT__
    local cQDiv
#endif //__PTCOMPAT__
   
#ifdef __PTCOMPAT__   
   
   SYMBOL_UNUSED( nSize )

   while r:gte(b)
      aux:SetValue(b:Mult(n))
      if aux:lte(a)
        while .T.
           n:SetValue(n:Mult(base))
           tmp:SetValue(b:Mult(n))
           if tmp:gt(a)
               exit
           endif
           aux:SetValue(tmp)
        end while
      endif      
      n:Normalize(@base)  
      n:SetValue(egDiv(n:__cInt(),base:__cInt(),n:__nInt(),nBase,nAcc,.F.))
      while r:gte(aux)
        r:SetValue(r:Sub(aux))
        q:SetValue(q:Add(n))
      end while
      a:SetValue(r)
      n:SetValue(__o1)
    end while

#else

    cQDiv:=tBIGNecDiv(pA,pB,@cRDiv,nSize,nBase)
    
    q:SetValue(cQDiv,NIL,"0",NIL,nAcc)
    r:SetValue(cRDiv,NIL,"0",NIL,nAcc)

#endif    
    
    cRDiv:=r:Int(.F.,.F.)
    q:SetValue(q,nBase,cRDiv,NIL,nAcc)
    
    if .not.(lFloat) .and. SubStr(cRDiv,r:__nInt(),1)=="0"
        cRDiv:=SubStr(cRDiv,1,r:__nInt()-1)
        if Empty(cRDiv)
            cRDiv:="0"
        endif
        q:SetValue(q,nBase,cRDiv,NIL,nAcc)
    endif

return(q)

/*
    function    : nthRoot
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/02/2013
    Descricao   : Metodo Newton-Raphson
    Sintaxe     : nthRoot(oRootB,oRootE,oAcc) -> othRoot
*/
static function nthRoot(oRootB,oRootE,oAcc)   
return(__Pow(oRootB,__o1:Div(oRootE),oAcc))

/*
    function    : __Pow
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/02/2013
    Descricao   : Metodo Newton-Raphson
    Sintaxe     : __Pow(base,exp,EPS) -> oPow
    Ref.        : http://stackoverflow.com/questions/3518973/floating-point-exponentiation-without-power-function 
                : http://stackoverflow.com/questions/2882706/how-can-i-write-a-power-function-myself
*/
static function __Pow(base,expR,EPS)

    local acc
    local sqr
    local tmp

    local low
    local mid
    local lst
    local high
    
    local exp:=expR:Clone()

    if base:eq(__o1) .or. exp:eq(__o0)
        return(__o1:Clone())
    elseif base:eq(__o0)
        return(__o0:Clone())
    elseif exp:lt(__o0)
        acc:=__pow(base,exp:Abs(.T.),EPS)
        return(__o1:Div(acc))
    elseif exp:Mod(__o2):eq(__o0)
         acc:=__pow(base,exp:Mult(__od2),EPS)
        return(acc:Mult(acc))
    elseif exp:Dec(.T.):gt(__o0) .and. exp:Int(.T.):gt(__o0)
        acc:=base:Pow(expR)
        return(acc)
    elseif exp:gte(__o1)
        acc:=base:Mult(__pow(base,exp:OpDec(),EPS))
        return(acc)
    else
        low:=__o0:Clone()
        high:=__o1:Clone()
        sqr:=__SQRT(base)
        acc:=sqr:Clone()    
        mid:=high:Mult(__od2)
        tmp:=mid:Sub(exp):Abs(.T.)
        lst:=__o0:Clone()    
        while tmp:gte(EPS)
            sqr:SetValue(__SQRT(sqr))
            if mid:lte(exp)
                low:SetValue(mid)
                acc:SetValue(acc:Mult(sqr))
            else
                high:SetValue(mid)
                acc:SetValue(__o1:Div(sqr))
            endif
            mid:SetValue(low:Add(high):Mult(__od2))
            tmp:SetValue(mid:Sub(exp):Abs(.T.))
            if tmp:eq(lst)
                exit
            endif
            lst:SetValue(tmp)
        end while
    endif

return(acc)

/*
    function    : __SQRT
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 10/02/2013
    Descricao   : SQRT
    Sintaxe     : __SQRT(p) -> oSQRT
*/
static function __SQRT(p)
    local l
    local r
    local t
    local s
    local n
    local EPS
    local q:=tBigNumber():New(p)
    if q:lte(q:SysSQRT())
        r:=tBigNumber():New(hb_ntos(SQRT(Val(q:GetValue()))))
    Else
        n:=__nthRootAcc-1
        IncZeros(n)
        s:="0."+SubStr(thscstcZ0,1,n)+"1"
        EPS:=__o0:Clone()
        EPS:SetValue(s,NIL,NIL,NIL,__nthRootAcc)
        r:=q:Mult(__od2)
        t:=r:Pow(__o2):Sub(q):Abs(.T.)
        l:=__o0:Clone()
        while t:gte(EPS)
            r:SetValue(r:pow(__o2):Add(q):Div(__o2:Mult(r)))
            t:SetValue(r:Pow(__o2):Sub(q):Abs(.T.))
            if t:eq(l)
                exit
            endif
            l:SetValue(t)
        end while
    endif
return(r)

#ifdef TBN_DBFILE

    /*
        function    : Add
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Adicao
        Sintaxe     : Add(a,b,n,nBase) -> cNR
    */
    static function Add(a,b,n,nBase)
    
        local c

        local y:=n+1
        local k:=y
        
        local s:=""

        #ifdef __HARBOUR__
            FIELD FN
        #endif    
        
        IncZeros(y)

        c:=aNumber(SubStr(thscstcZ0,1,y),y,"ADD_C")
    
        while n>0
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
                #else
                    (c)->FN+=Val(a[n])+Val(b[n])
                #endif
                if (c)->FN>=nBase
                    (c)->FN    -= nBase
                    (c)->(dbUnLock())
                    (c)->(dbGoTo(k-1))
                    if (c)->(rLock())
                        (c)->FN+=1
                    endif    
                endif
                (c)->(dbUnLock())
            endif
            --k
            --n
        end while
        
        (c)->(dbGoTop())
        (c)->(dbEval({||s+=hb_ntos(FN)}))
        
    return(s)
    
    /*
        function    : Sub
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Subtracao
        Sintaxe     : Sub(a,b,n,nBase) -> cNR
    */
    static function Sub(a,b,n,nBase)

        local c

        local y:=n
        local k:=y
        
        local s:=""
    
        #ifdef __HARBOUR__
            FIELD FN
        #endif
        
        IncZeros(y)
        
        c:=aNumber(SubStr(thscstcZ0,1,y),y,"SUB_C")

        while n>0
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
                #else
                    (c)->FN+=Val(a[n])-Val(b[n])
                #endif
                if (c)->FN<0
                    (c)->FN+=nBase
                    (c)->(dbUnLock())
                    (c)->(dbGoTo(k-1))
                    if (c)->(rLock())
                        (c)->FN -= 1
                    endif
                endif
                (c)->(dbUnLock())
            endif
            --k
            --n
        end while

        (c)->(dbGoTop())
        (c)->(dbEval({||s+=hb_ntos(FN)}))

    return(s)
    
    /*
        function    : Mult
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Multiplicacao de Inteiros
        Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
        Obs.        : Mais rapida,usa a multiplicacao nativa
    */
    static function Mult(cN1,cN2,n,nBase)

        local c
        
        local a:=tBigNInvert(cN1,n)
        local b:=tBigNInvert(cN2,n)
        local y:=n+n
    
        local i:=1
        local k:=1
        local l:=2
        
        local s
        local x
        local j
        local w

        #ifdef __HARBOUR__
            FIELD FN
        #endif
        
        IncZeros(y)
        
        c:=aNumber(SubStr(thscstcZ0,1,y),y,"MULT_C")
    
        while i<=n
            s:=1
            j:=i
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                while s<=i
                    #ifdef __PROTHEUS__
                        (c)->FN+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                    #else
                        (c)->FN+=Val(a[s++])*Val(b[j--])
                    #endif
                end while
                if (c)->FN>=nBase
                    x:=k+1
                    w:=Int((c)->FN/nBase)
                    (c)->(dbGoTo(x))
                    if (c)->(rLock())
                        (c)->FN:=w
                        (c)->(dbUnLock())
                        w:=(c)->FN*nBase
                        (c)->(dbGoTo(k))
                        (c)->FN    -= w
                    endif    
                endif
                (c)->(dbUnLock())
            endif
            k++
            i++
        end while
    
        while l<=n
            s:=n
            j:=l
            (c)->(dbGoTo(k))
            if (c)->(rLock())
                while s>=l
                #ifdef __PROTHEUS__
                    (c)->FN+=Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
                #else
                    (c)->FN+=Val(a[s--])*Val(b[j++])    
                #endif
                end while
                if (c)->FN>=nBase
                    x:=k+1
                    w:=Int((c)->FN/nBase)
                    (c)->(dbGoTo(x))
                    if (c)->(rLock())
                        (c)->FN:=w
                        (c)->(dbUnLock())
                        w:=(c)->FN*nBase
                        (c)->(dbGoTo(k))
                        (c)->FN -= w
                    endif    
                endif
                (c)->(dbUnLock())
            endif
            if ++k>=y
                exit
            endif
            l++
        end while
        
        s:=dbGetcN(c,y)

    return(s)

    /*
        function    : aNumber
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : db OF Numbers
        Sintaxe     : aNumber(c,n,o) -> a
    */
    static function aNumber(c,n,o)
    
        local a:=dbNumber(o)
    
        local y:=0
    
        #ifdef __HARBOUR__
            FIELD FN
        #endif    
    
        while ++y<=n
            (a)->(dbAppend(.T.))
        #ifdef __PROTHEUS__
            (a)->FN:=Val(SubStr(c,y,1))
        #else
            (a)->FN:=Val(c[y])
        #endif    
            (a)->(dbUnLock())
        end while
    
    return(a)
    
    /*
        function    : dbGetcN
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Montar a String de Retorno
        Sintaxe     : dbGetcN(a,x) -> s
    */
    static function dbGetcN(a,n)
    
        local s:=""
        local y:=n
    
        #ifdef __HARBOUR__
            FIELD FN
        #endif    
    
        while y>=1
            (a)->(dbGoTo(y))
            while y>=1 .and. (a)->FN==0
                (a)->(dbGoTo(--y))
            end while
            while y>=1
                (a)->(dbGoTo(y--))
                s+=hb_ntos((a)->FN)
            end while
        end while
    
        if s==""
            s:="0"    
        endif
    
        if hb_bLen(s)<n
            s:=PadL(s,n,"0")
        endif
    
    return(s)
                                        
    static function dbNumber(cAlias)
        local aStru:={{"FN","N",18,0}}
        local cFile
    #ifndef __HARBOUR__
        local cLDriver
        local cRDD:=if((Type("__localDriver")=="C"),__localDriver,"DBFCDXADS")
    #else
        #ifndef TBN_MEMIO
        local cRDD:="DBFCDX"
        #endif
    #endif
    #ifndef __HARBOUR__
        if .not.(Type("__localDriver")=="C")
            private __localDriver
        endif
        cLDriver:=__localDriver
        __localDriver:=cRDD
    #endif
        if Select(cAlias)==0
    #ifndef __HARBOUR__
            cFile:=CriaTrab(aStru,.T.,GetdbExtension())
            if .not.(GetdbExtension()$cFile)
                cFile+=GetdbExtension()
            endif
            dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
    #else
            #ifndef TBN_MEMIO
                cFile:=CriaTrab(aStru,cRDD)
                dbUseArea(.T.,cRDD,cFile,cAlias,.F.,.F.)
            #else
                cFile:=CriaTrab(aStru,cAlias)
            #endif    
    #endif
            DEFAULT thsdFiles:=Array(0)
            aAdd(thsdFiles,{cAlias,cFile})
        Else
            (cAlias)->(dbRLock())
    #ifdef __HARBOUR__        
            (cAlias)->(hb_dbZap())
    #else
            (cAlias)->(__dbZap())
    #endif        
            (cAlias)->(dbRUnLock())
        endif    
    #ifndef __HARBOUR__
        if .not.(Empty(cLDriver))
            __localDriver:=cLDriver
        endif    
    #endif
    return(cAlias)
    
    #ifdef __HARBOUR__
        #ifndef TBN_MEMIO
            static function CriaTrab(aStru,cRDD)
                local cFolder:=tbNCurrentFolder()+hb_ps()+"tbigN_tmp"+hb_ps()
                local cFile:=cFolder+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)+".dbf"
                local lSuccess:=.F.
                while .not.(lSuccess)
                    Try
                      MakeDir(cFolder)
                      dbCreate(cFile,aStru,cRDD)
                      lSuccess:=.T.
                    Catch
                      cFile:="TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)+".dbf"
                      lSuccess:=.F.
                    end
                end while    
            return(cFile)
        #else
            static function CriaTrab(aStru,cAlias)
                local cFile:="mem:"+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)
                local lSuccess:=.F.     
                while .not.(lSuccess)
                    Try
                      dbCreate(cFile,aStru,NIL,.T.,cAlias)
                      lSuccess:=.T.
                    Catch
                      cFile:="mem:"+"TBN"+Dtos(Date())+"_"+StrTran(Time(),":","_")+"_"+StrZero(HB_RandomInt(1,9999),4)
                      lSuccess:=.F.
                    end
                end while    
            return(cFile)
        #endif
    #endif

#else

    #ifdef TBN_ARRAY

    /*
        function    : Add
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Adicao
        Sintaxe     : Add(a,b,n,nBase) -> cNR
    */
    static function Add(a,b,n,nBase)

        local y:=n+1
        local c:=aFill(aSize(thsaZAdd,y),0)
        local k:=y
        local s:=""

        while n>0
        #ifdef __PROTHEUS__
            c[k]+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
        #else
            c[k]+=Val(a[n])+Val(b[n])
        #endif
            if c[k]>=nBase
                c[k-1]+=1
                c[k]    -= nBase
            endif
            --k
            --n
        end while
        
        aEval(c,{|v|s+=hb_ntos(v)})

    return(s)
    
    /*
        function    : Sub
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Subtracao
        Sintaxe     : Sub(a,b,n,nBase) -> cNR
    */
    static function Sub(a,b,n,nBase)

        local y:=n
        local c:=aFill(aSize(thsaZSub,y),0)
        local k:=y
        local s:=""
    
        while n>0
        #ifdef __PROTHEUS__
            c[k]+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
        #else
            c[k]+=Val(a[n])-Val(b[n])
        #endif
            if c[k]<0
                c[k-1]    -= 1
                c[k]+=nBase
            endif
            --k
            --n
        end while
        
        aEval(c,{|v|s+=hb_ntos(v)})

    return(s)
    
    /*
        function    : Mult
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Multiplicacao de Inteiros
        Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
        Obs.        : Mais rapida,usa a multiplicacao nativa
    */
    static function Mult(cN1,cN2,n,nBase)

        local a:=tBigNInvert(cN1,n)
        local b:=tBigNInvert(cN2,n)

        local y:=n+n
        local c:=aFill(aSize(thsaZMult,y),0)
    
        local i:=1
        local k:=1
        local l:=2
        
        local s
        local x
        local j
    
        while i<=n
            s:=1
            j:=i
            while s<=i
            #ifdef __PROTHEUS__
                c[k]+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
            #else
                c[k]+=Val(a[s++])*Val(b[j--])
            #endif
            end while
            if c[k]>=nBase
                x:=k+1
                c[x]:=Int(c[k]/nBase)
                c[k]    -= c[x]*nBase
            endif
            k++
            i++
        end while
    
        while l<=n
            s:=n
            j:=l
            while s>=l
            #ifdef __PROTHEUS__
                c[k]+=Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
            #else
                c[k]+=Val(a[s--])*Val(b[j++])    
            #endif
            end while
            if c[k]>=nBase
                x:=k+1
                c[x]:=Int(c[k]/nBase)
                c[k]    -= c[x]*nBase
            endif
            if ++k>=y
                exit
            endif
            l++
        end while

    return(aGetcN(c,y))

    /*
        function    : aGetcN
        Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
        Data        : 04/02/2013
        Descricao   : Montar a String de Retorno
        Sintaxe     : aGetcN(a,x) -> s
    */
    static function aGetcN(a,n)
    
        local s:=""
        local y:=n
    
        while y>=1
            while y>=1 .and. a[y]==0
                y--
            end while
            while y>=1
                s+=hb_ntos(a[y])
                y--
            end while
        end while
    
        if s==""
            s:="0"
        endif
    
        if hb_bLen(s)<n
            s:=PadL(s,n,"0")
        endif
    
    return(s)
    
    #else

        /*
            function    : Add
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Adicao
            Sintaxe     : Add(a,b,n,nBase) -> cNR
        */
        #ifdef __PTCOMPAT__
            static function Add(a,b,n,nBase)

                local c

                local y:=n+1
                local k:=y
            
                local v:=0
                local v1
                
                IncZeros(y)
                
                c:=SubStr(thscstcZ0,1,y)

                while n>0
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,n,1))+Val(SubStr(b,n,1))
                    #else
                        v+=Val(a[n])+Val(b[n])
                    #endif
                    if v>=nBase
                        v  -= nBase
                        v1:=1
                    Else
                        v1:=0
                    endif
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k-1,1,hb_ntos(v1)) 
                    #else
                        c[k]:=hb_ntos(v)
                        c[k-1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    --k
                    --n
                end while

            return(c)
        #else //__HARBOUR__
            static function Add(a,b,n,nB)
            return(tBIGNADD(a,b,n,n,nB))
        #endif //__PTCOMPAT__
        
        /*
            function    : Sub
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Subtracao
            Sintaxe     : Sub(a,b,n,nBase) -> cNR
        */
        #ifdef __PTCOMPAT__
            static function Sub(a,b,n,nBase)

                local c

                local y:=n
                local k:=y
                
                local v:=0
                local v1
                
                IncZeros(y)
                
                c:=SubStr(thscstcZ0,1,y)
            
                while n>0
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,n,1))-Val(SubStr(b,n,1))
                    #else
                        v+=Val(a[n])-Val(b[n])
                    #endif
                    if v<0
                        v+=nBase
                        v1:=-1
                    Else
                        v1:=0
                    endif
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v)) 
                    #else
                        c[k]:=hb_ntos(v)
                    #endif
                    v:=v1
                    --k
                    --n
                end while

            return(c)
        #else //__HARBOUR__
            static function Sub(a,b,n,nB)
            return(tBIGNSUB(a,b,n,nB))
        #endif //__PTCOMPAT__
        /*
            function    : Mult
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Multiplicacao de Inteiros
            Sintaxe     : Mult(cN1,cN2,n,nBase) -> cNR
            Obs.        : Mais rapida, usa a multiplicacao nativa
        */
        #ifdef __PTCOMPAT__
            static function Mult(cN1,cN2,n,nBase)

                local c

                local a:=tBigNInvert(cN1,n)
                local b:=tBigNInvert(cN2,n)

                local y:=n+n

                local i:=1
                local k:=1
                local l:=2
                
                local s
                local j
                
                local v:=0
                local v1
                
                IncZeros(y)
                
                c:=SubStr(thscstcZ0,1,y)
                    
                while i<=n
                    s:=1
                    j:=i
                    while s<=i
                    #ifdef __PROTHEUS__
                        v+=Val(SubStr(a,s++,1))*Val(SubStr(b,j--,1))
                    #else
                        v+=Val(a[s++])*Val(b[j--])
                    #endif
                    end while
                    if v>=nBase
                        v1:=Int(v/nBase)
                        v    -= v1*nBase
                    Else
                        v1:=0    
                    endif
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k+1,1,hb_ntos(v1)) 
                    #else
                        c[k]:=hb_ntos(v)
                        c[k+1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    k++
                    i++
                end while

                while l<=n
                    s:=n
                    j:=l
                    while s>=l
                    #ifdef __PROTHEUS__
                        v+=Val(SubSTr(a,s--,1))*Val(SubSTr(b,j++,1))
                    #else
                        v+=Val(a[s--])*Val(b[j++])    
                    #endif
                    end while
                    if v>=nBase
                        v1:=Int(v/nBase)
                        v    -= v1*nBase
                    Else
                        v1:=0    
                    endif
                    #ifdef __PROTHEUS__
                        c:=Stuff(c,k,1,hb_ntos(v))
                        c:=Stuff(c,k+1,1,hb_ntos(v1)) 
                    #else
                        c[k]:=hb_ntos(v)
                        c[k+1]:=hb_ntos(v1)
                    #endif
                    v:=v1
                    if ++k>=y
                        exit
                    endif
                    l++
                end while

            return(cGetcN(c,y))
        #else //__HARBOUR__
            static function Mult(a,b,n,nB)
            return(tBIGNMULT(a,b,n,n,nB))
        #endif //__PTCOMPAT__

        /*
            function    : cGetcN
            Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
            Data        : 04/02/2013
            Descricao   : Montar a String de Retorno
            Sintaxe     : cGetcN(c,n) -> s
        */
        #ifdef __PTCOMPAT__
            static function cGetcN(c,n)
                local s:=""
                local y:=n
                while y>=1
                #ifdef __PROTHEUS__
                    while y>=1 .and. SubStr(c,y,1)=="0"
                #else
                    while y>=1 .and. c[y]=="0"
                #endif    
                        y--
                    end while
                    while y>=1
                    #ifdef __PROTHEUS__
                        s+=SubStr(c,y,1)
                    #else
                        s+=c[y]
                    #endif
                        y--
                    end while
                end while
                if s==""
                    s:="0"
                endif
            
                if hb_bLen(s)<n
                    s:=PadL(s,n,"0")
                endif
            
            return(s)
        #endif __PTCOMPAT__
    
    #endif

#endif

#ifndef __PTCOMPAT__
    static function thAdd(oN,oP)
        local othAdd:=__o0:Clone()
        othAdd:SetValue(oN:Add(oP))
    return(othAdd)
    static function thDiv(oN,oD,lFloat)
        local othDiv:=__o0:Clone()
        othDiv:SetValue(oN:Div(oD,lFloat))
    return(othDiv)
    static function thMod0(oN,oD)
        local othMod0:=__o0:Clone()
        othMod0:SetValue(oN:Mod(oD))
    return(othMod0:eq(__o0))
    static function thnthRoot(oN,oE)
        local othnthRoot:=__o0:Clone()
        othnthRoot:SetValue(oN:nthRoot(oE))
    return(othnthRoot)
    static function thMult(oN,oM)
        local othMult:=__o0:Clone()
        othMult:SetValue(oN:Mult(oM))
    return(othMult)
#endif //__PTCOMPAT__    

/*
    function    : tBigNInvert
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Inverte o Numero
    Sintaxe     : tBigNInvert(c,n) -> s
*/
#ifdef __PTCOMPAT__
    static function tBigNInvert(c,n)
        local s:=""
        local y:=n
        while y>0
        #ifdef __PROTHEUS__
            s+=SubStr(c,y--,1)
        #else
            s+=c[y--]
        #endif
        end while
    return(s)
#else //__HARBOUR__
    static function tBigNInvert(c,n)
    return(tBigNReverse(c,n))
#endif //__PTCOMPAT__

/*
    function    : MathO
    Autor       : Marinaldo de Jesus [http://www.blacktdn.com.br]
    Data        : 04/02/2013
    Descricao   : Operacoes matematicas
    Sintaxe     : MathO(uBigN1,cOperator,uBigN2,lRetObject)
*/
static function MathO(uBigN1,cOperator,uBigN2,lRetObject)

    local oBigNR:=__o0:Clone()

    local oBigN1:=tBigNumber():New(uBigN1)
    local oBigN2:=tBigNumber():New(uBigN2)

    do case
        case (aScan(OPERATOR_ADD,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Add(oBigN2))
        case (aScan(OPERATOR_SUBTRACT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Sub(oBigN2))
        case (aScan(OPERATOR_MULTIPLY,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Mult(oBigN2))
        case (aScan(OPERATOR_DIVIDE,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Div(oBigN2))
        case (aScan(OPERATOR_POW,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Pow(oBigN2))
        case (aScan(OPERATOR_MOD,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:Mod(oBigN2))
        case (aScan(OPERATOR_ROOT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:nthRoot(oBigN2))
        case (aScan(OPERATOR_SQRT,{|cOp|cOperator==cOp})>0)
            oBigNR:SetValue(oBigN1:SQRT())
    endcase

    DEFAULT lRetObject:=.T.

return(if(lRetObject,oBigNR,oBigNR:ExactValue()))

// -------------------- assign thread static values -------------------------
static Procedure __Initsthd(nBase)

    local oTBigN

    thslsdSet:=.F.
    
    thscstcZ0:="000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
    thsnstcZ0:=150
    thscstcN9:="999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999"
    htsnstcN9:=150
   
    #ifdef TBN_ARRAY
        thsaZAdd:=Array(0)
        thsaZSub:=Array(0)
        thsaZMult:=Array(0)
    #endif    

    #ifdef TBN_DBFILE
        if (thsdFiles==NIL)
            thsdFiles:=Array(0)
        endif
    #endif
    
    oTBigN:=tBigNumber():New("0",nBase)

    thseqN1:=oTBigN:Clone()
    thseqN2:=oTBigN:Clone()

    thsgtN1:=oTBigN:Clone()
    thsgtN2:=oTBigN:Clone()

    thsltN1:=oTBigN:Clone()
    thsltN2:=oTBigN:Clone()
    
    thscmpN1:=oTBigN:Clone()
    thscmpN2:=oTBigN:Clone()

    thsadNR:=oTBigN:Clone()
    thsadN1:=oTBigN:Clone()
    thsadN2:=oTBigN:Clone()

    thssbNR:=oTBigN:Clone()
    thssbN1:=oTBigN:Clone()
    thssbN2:=oTBigN:Clone()

    thsmtNR:=oTBigN:Clone()
    thsmtN1:=oTBigN:Clone()
    thsmtN2:=oTBigN:Clone()

    thsdvNR:=oTBigN:Clone()
    thsdvN1:=oTBigN:Clone()
    thsdvN2:=oTBigN:Clone()
    thsdvRDiv:=oTBigN:Clone()

    thspwA:=oTBigN:Clone()
    thspwB:=oTBigN:Clone()
    thspwNP:=oTBigN:Clone()
    thspwNR:=oTBigN:Clone()
    thspwNT:=oTBigN:Clone()
    thspwGCD:=oTBigN:Clone()
    
#ifdef __PTCOMPAT__
    thseDivN:=oTBigN:Clone()
    thseDivD:=oTBigN:Clone()
#endif //__PTCOMPAT__
    thseDivR:=oTBigN:Clone()
    thseDivQ:=oTBigN:Clone()
#ifdef __PTCOMPAT__
    thseDivDvQ:=oTBigN:Clone()
    thseDivDvR:=oTBigN:Clone()
#endif //__PTCOMPAT__

    thsSysSQRT:=oTBigN:Clone()
    
    thslsdSet:=.T.

return

// -------------------- assign static values --------------------------------
static Procedure __InitstbN(nBase)
    __lstbNSet:=.F.
    __o0:=tBigNumber():New("0",nBase)
    __o1:=tBigNumber():New("1",nBase)
    __o2:=tBigNumber():New("2",nBase)
    __o10:=tBigNumber():New("10",nBase)
    __o20:=tBigNumber():New("20",nBase)
    __od2:=tBigNumber():New("0.5",nBase)
    __oMinFI:=tBigNumber():New(MAX_SYS_FI,nBase)
    __oMinGCD:=tBigNumber():New(MAX_SYS_GCD,nBase)
    __nMinLCM:=Int(hb_bLen(MAX_SYS_LCM)/2)
    #ifdef __PROTHEUS__
        DEFAULT __cEnvSrv:=GetEnvServer()
    #endif
    __lstbNSet:=.T.
return

#ifdef __PROTHEUS__

    static function __eTthD()
    return(staticCall(__pteTthD,__eTthD))
    static function __PITthD()
    return(staticCall(__ptPITthD,__PITthD))

#else //__HARBOUR__

    static function __eTthD()
    return(__hbeTthD())
    static function __PITthD()
    return(__hbPITthD())
    
    /* warning: 'void HB_FUN_...()'  defined but not used [-Wunused-function]...*/    
    static function __Dummy(lDummy)
        lDummy:=.F.
        if (lDummy)
            __Dummy()
            EGDIV()
            ECDIV()
            TBIGNPADL()
            TBIGNPADR()
            TBIGNINVERT()
            TBIGNREVERSE()
            TBIGNADD()
            TBIGNSUB()
            TBIGNMULT()
            TBIGNEGMULT()
            TBIGNEGDIV()
            TBIGNECDIV()
            TBIGNGDC()
            TBIGNLCM()
            TBIGNFI()
            TBIGNALEN()
            TBIGNMEMCMP()
            TBIGN2MULT()
            TBIGNIMULT()
            TBIGNIADD()
            TBIGNISUB()
            TBIGNLMULT()
            TBIGNLADD()
            TBIGNLSUB()
            TBIGNNORMALIZE()
        endif
    return(lDummy)
    
#endif //__PROTHEUS__

#ifdef __HARBOUR__

    #pragma BEGINDUMP

        #include <stdio.h>
        #include <string.h>
        #include <hbapi.h>
        #include <hbdefs.h>
        #include <hbstack.h>
        #include <hbapiitm.h>

        static char * TBIGNReplicate(const char * szText,HB_ISIZ nTimes){
            HB_SIZE nLen    = strlen(szText);       
            HB_ISIZ nRLen   = (nLen*nTimes);
            char * szResult = (char*)hb_xgrab(nRLen+1);
            char * szPtr    = szResult;
            HB_ISIZ n;
            for(n=0;n<nTimes;++n)
            {
                hb_xmemcpy(szPtr,szText,nLen);
                szPtr+=nLen;
            }
            return szResult;
        }

        static char * tBIGNPadL(const char * szItem,HB_ISIZ nLen,const char * szPad){
            int itmLen = strlen(szItem);
            int padLen = nLen-itmLen;
            char * pbuffer;
            if((padLen)>0){
                if(szPad==NULL){szPad="0";}
                char *padding  = TBIGNReplicate(szPad,nLen); 
                pbuffer = (char*)hb_xgrab(nLen+1);
                sprintf(pbuffer,"%*.*s%s",padLen,padLen,padding,szItem);
                hb_xfree(padding);
            }else{
                pbuffer = hb_strdup(szItem);
            }
            return pbuffer;
        }

        HB_FUNC_STATIC( TBIGNPADL ){      
            const char * szItem = hb_parc(1);
            HB_ISIZ nLen        = hb_parns(2);
            const char * szPad  = hb_parc(3);
            char * szRet        = tBIGNPadL(szItem,nLen,szPad);
            hb_retclen(szRet,(HB_SIZE)nLen);
            hb_xfree(szRet);
        }

        static char * tBIGNPadR(const char * szItem,HB_ISIZ nLen,const char * szPad){    
            int itmLen = strlen(szItem);
            int padLen = nLen-itmLen;
            char * pbuffer;
            if((padLen)>0){
                if(szPad==NULL){szPad="0";}
                char *padding  = TBIGNReplicate(szPad,nLen); 
                pbuffer = (char*)hb_xgrab(nLen+1);
                sprintf(pbuffer,"%s%*.*s",szItem,padLen,padLen,padding);
                hb_xfree(padding);
            }else{
                pbuffer = hb_strdup(szItem);
            }
            return pbuffer;
        }
       
        HB_FUNC_STATIC( TBIGNPADR ){
            const char * szItem = hb_parc(1);
            HB_ISIZ nLen        = hb_parns(2);
            const char * szPad  = hb_parc(3);
            char * szRet        = tBIGNPadR(szItem,nLen,szPad);
            hb_retclen(szRet,(HB_SIZE)nLen);
            hb_xfree(szRet);
        }

        static char * tBIGNReverse(const char * szF,const HB_SIZE s){
            HB_SIZE f  = s;
            HB_SIZE t  = 0;
            char * szT = (char*)hb_xgrab(s+1);
            for(;f;){
                szT[t++]=szF[--f];
            }
            szT[t]=szF[t];
            return szT;
        }

        HB_FUNC_STATIC( TBIGNREVERSE ){
            const char * szF = hb_parc(1);
            const HB_SIZE s  = (HB_SIZE)hb_parnint(2);
            char * szR       = tBIGNReverse(szF,s);
            hb_retclen(szR,s);
            hb_xfree(szR);
        }

        static char * tBIGNAdd(const char * a, const char * b, int n, const HB_SIZE y, const HB_MAXUINT nB){    
            char * c         = (char*)hb_xgrab(y+1);
            HB_SIZE k        = y-1;
            HB_MAXUINT v     = 0;
            HB_MAXUINT v1;
            while (--n>=0){
                v+=(*(&a[n])-'0')+(*(&b[n])-'0');
                if ( v>=nB ){
                    v  -= nB;
                    v1 = 1;
                }    
                else{
                    v1 = 0;
                }
                c[k]   = "0123456789"[v];
                c[k-1] = "0123456789"[v1];
                v = v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNADD ){    
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = (HB_SIZE)(hb_parnint(4)+1);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            char * szRet        = tBIGNAdd(a,b,(int)n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }
        
        static char * tBigNiADD(char * sN ,  HB_MAXUINT a, const int isN, const HB_MAXUINT nB){
            HB_BOOL bAdd  = HB_TRUE;
            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            int i         = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                if (bAdd){
                    v    += a;
                    bAdd =  HB_FALSE;
                }    
                v += v1;
                if ( v>=nB ){
                    v  -= nB;
                    v1 = 1;
                }    
                else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
                if (v1==0){
                    break;
                }
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGNIADD ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1)+1);
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            HB_MAXUINT a        = (HB_MAXUINT)hb_parnint(2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(3);
            hb_retclen(tBigNiADD(szRet,a,(int)n,nB),n);
            hb_xfree(szRet);
        }
        
        HB_FUNC_STATIC( TBIGNLADD ){
            hb_retnint((HB_MAXUINT)hb_parnint(1)+(HB_MAXUINT)hb_parnint(2));
        }
   
        static char * tBIGNSub(const char * a, const char * b, int n, const HB_SIZE y, const HB_MAXUINT nB){
            char * c      = (char*)hb_xgrab(y+1);
            HB_SIZE k     = y-1;
            int v         = 0;
            int v1;
            while (--n>=0){
                v+=(*(&a[n])-'0')-(*(&b[n])-'0');
                if ( v<0 ){
                    v+=nB;
                    v1 = -1;
                }    
                else{
                    v1 = 0;
                }
                c[k]   = "0123456789"[v];
                c[k-1] = "0123456789"[v1];
                v = v1;
                --k;
            }
            return c;
        }

        HB_FUNC_STATIC( TBIGNSUB ){    
            const char * a      = hb_parc(1);
            const char * b      = hb_parc(2);
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            const HB_SIZE y     = n;
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(4);
            char * szRet        = tBIGNSub(a,b,(int)n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(szRet);
        }
        
        static char * tBigNiSUB(char * sN , const HB_MAXUINT s, const int isN, const HB_MAXUINT nB){
            HB_BOOL bSub  = HB_TRUE;
            int v;
            int v1        = 0;
            int i         = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                if (bSub){
                    v    -= s;
                    bSub =  HB_FALSE;
                }                
                v += v1;
                if ( v<0 ){
                    v+=nB;
                    v1 = -1;
                }    
                else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
                if (v1==0){
                    break;
                }
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGNISUB ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1));
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            int s               = (HB_MAXUINT)hb_parnint(2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(3);
            hb_retclen(tBigNiSUB(szRet,s,(int)n,nB),n);
            hb_xfree(szRet);
        }
        
        HB_FUNC_STATIC( TBIGNLSUB ){
            hb_retnint((HB_MAXUINT)hb_parnint(1)-(HB_MAXUINT)hb_parnint(2));
        }
 
        static char * tBIGNMult(const char * a, const char * b, HB_SIZE n, const HB_SIZE y, const HB_MAXUINT nB){
            
            char * c     = (char*)hb_xgrab(y+1);
            
            HB_SIZE i    = 0;
            HB_SIZE k    = 0;
            HB_SIZE l    = 1;
            HB_SIZE s;
            HB_SIZE j;
            
            HB_MAXUINT v = 0;
            HB_MAXUINT v1;
            
            n-=1;
            
            while (i<=n){
                s = 0;
                j = i;
                while (s<=i){
                    v+=(*(&a[s++])-'0')*(*(&b[j--])-'0');
                }
                if (v>=nB){
                    v1 = v/nB;
                    v %= nB;
               }else{
                    v1 = 0;
                 };
                c[k]   = "0123456789"[v];
                c[k+1] = "0123456789"[v1];
                v = v1;
                k++;
                i++;
            }
        
            while (l<=n){
                s = n;
                j = l;
                while (s>=l){
                    v+=(*(&a[s--])-'0')*(*(&b[j++])-'0');
                }
                if (v>=nB){
                    v1 = v/nB;
                    v %= nB;
                }else{
                    v1     = 0;                    
                }
                c[k]   = "0123456789"[v];
                c[k+1] = "0123456789"[v1];
                v = v1;
                if (++k>=y){
                    break;
                }
                l++;
            }        
            
            char * r = tBIGNReverse(c,y);
            hb_xfree(c);
    
            return r;
        }
    
        HB_FUNC_STATIC( TBIGNMULT ){
            HB_SIZE n           = (HB_SIZE)hb_parnint(3);
            char * a            = tBIGNReverse(hb_parc(1),n);
            char * b            = tBIGNReverse(hb_parc(2),n);
            const HB_SIZE y     = (HB_SIZE)(hb_parnint(4)*2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
            char * szRet        = tBIGNMult(a,b,n,y,nB);
            hb_retclen(szRet,y);
            hb_xfree(a);
            hb_xfree(b);
            hb_xfree(szRet);
        }
        
        typedef struct
        {
            char * cMultM;
            char * cMultP;
        } stBIGNeMult, * ptBIGNeMult;

        static void tBIGNegMult(const char * pN, const char * pD, int n, const HB_MAXUINT nB , ptBIGNeMult pegMult){
    
            HB_MAXUINT szptBIGNeMult = sizeof(ptBIGNeMult*);
            HB_MAXUINT szstBIGNeMult = sizeof(stBIGNeMult);            
            
            ptBIGNeMult *peMTArr     = (ptBIGNeMult*)hb_xgrab(szptBIGNeMult);        
            ptBIGNeMult pegMultTmp   = (ptBIGNeMult)hb_xgrab(szstBIGNeMult);
            
            char * Tmp               = tBIGNPadL("1",n,"0");
            pegMultTmp->cMultM       = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            pegMultTmp->cMultP       = hb_strdup(pD);
    
            Tmp                      = tBIGNPadL("0",n,"0");
            pegMult->cMultM          = hb_strdup(Tmp);
            pegMult->cMultP          = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            int nI                   = 0;

            do {
            
                peMTArr     = (ptBIGNeMult*)hb_xrealloc(peMTArr,(nI+1)*szptBIGNeMult);
                peMTArr[nI] = (ptBIGNeMult)hb_xgrab(szstBIGNeMult);
                
                peMTArr[nI]->cMultM = hb_strdup(pegMultTmp->cMultM);
                peMTArr[nI]->cMultP = hb_strdup(pegMultTmp->cMultP);  

                char * tmp = tBIGNAdd(pegMultTmp->cMultM,pegMultTmp->cMultM,n,n,nB);
                hb_xmemcpy(pegMultTmp->cMultM,tmp,n);
                hb_xfree(tmp);
                    
                tmp        = tBIGNAdd(pegMultTmp->cMultP,pegMultTmp->cMultP,n,n,nB);                
                hb_xmemcpy(pegMultTmp->cMultP,tmp,n);
                hb_xfree(tmp);
                
                if (memcmp(pegMultTmp->cMultM,pN,n)==1){
                    break;
                }
                
                ++nI;

            } while (HB_TRUE);
            
            hb_xfree(pegMultTmp->cMultM);
            hb_xfree(pegMultTmp->cMultP);
            
            int nF = nI;

            do {
               
                pegMultTmp->cMultM = tBIGNAdd(pegMult->cMultM,peMTArr[nI]->cMultM,n,n,nB);
                hb_xmemcpy(pegMult->cMultM,pegMultTmp->cMultM,n);
                hb_xfree(pegMultTmp->cMultM);
    
                pegMultTmp->cMultP = tBIGNAdd(pegMult->cMultP,peMTArr[nI]->cMultP,n,n,nB);
                hb_xmemcpy(pegMult->cMultP,pegMultTmp->cMultP,n);
                hb_xfree(pegMultTmp->cMultP);
                
                int iCmp = memcmp(pegMult->cMultM,pN,n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){
    
                            pegMultTmp->cMultM = tBIGNSub(pegMult->cMultM,peMTArr[nI]->cMultM,n,n,nB);
                            hb_xmemcpy(pegMult->cMultM,pegMultTmp->cMultM,n);
                            hb_xfree(pegMultTmp->cMultM);
    
                            pegMultTmp->cMultP = tBIGNSub(pegMult->cMultP,peMTArr[nI]->cMultP,n,n,nB);
                            hb_xmemcpy(pegMult->cMultP,pegMultTmp->cMultP,n);
                            hb_xfree(pegMultTmp->cMultP);
    
                    }
                }  
                
            } while (--nI>=0);
            
            for(nI=nF;nI>=0;nI--){
                hb_xfree(peMTArr[nI]->cMultM);
                hb_xfree(peMTArr[nI]->cMultP);
                hb_xfree(peMTArr[nI]);
            }
            hb_xfree(peMTArr);
            peMTArr = NULL;

            hb_xfree(pegMultTmp);
                
        }
        
        HB_FUNC_STATIC( TBIGNEGMULT ){
            
            HB_SIZE n           = (HB_SIZE)(hb_parnint(3)*2);            
            char * pN           = tBIGNPadL(hb_parc(1),n,"0");
            char * pD           = tBIGNPadL(hb_parc(2),n,"0");
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(4);
            
            ptBIGNeMult pegMult = (ptBIGNeMult)hb_xgrab(sizeof(stBIGNeMult));
            
            tBIGNegMult(pN,pD,(int)n,nB,pegMult);
        
            hb_retclen(pegMult->cMultP,n);

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pegMult->cMultM);
            hb_xfree(pegMult->cMultP);
            hb_xfree(pegMult);
        }
        
        static char * tBigN2Mult(char * sN , const int isN, const HB_MAXUINT nB){
            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            int i = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                v <<= 1;
                v += v1;
                if (v>=nB){
                    v1 = v/nB;
                    v  %= nB;
                }else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGN2MULT ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1)+1);
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(2);
            hb_retclen(tBigN2Mult(szRet,(int)n,nB),n);
            hb_xfree(szRet);
        }
        
        static char * tBigNiMult(char * sN , const HB_MAXUINT m, const HB_SIZE isN, const HB_MAXUINT nB){
            HB_MAXUINT v;
            HB_MAXUINT v1 = 0;
            int i = isN;
            while(--i>=0){
                v = (*(&sN[i])-'0');
                v *= m;
                v += v1;
                if (v>=nB){
                    v1 = v/nB;
                    v  %= nB;
                }else{
                    v1 = 0;
                }
                sN[i] = "0123456789"[v];
            }
            return sN;
        }
        
        HB_FUNC_STATIC( TBIGNIMULT ){
            HB_SIZE n           = (HB_SIZE)(hb_parclen(1)*2);
            char * szRet        = tBIGNPadL(hb_parc(1),n,"0");
            HB_MAXUINT m        = (HB_MAXUINT)hb_parnint(2);
            const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(3);
            hb_retclen(tBigNiMult(szRet,m,n,nB),n);
            hb_xfree(szRet);
        }
        
        HB_FUNC_STATIC( TBIGNLMULT ){
            hb_retnint((HB_MAXUINT)hb_parnint(1)*(HB_MAXUINT)hb_parnint(2));
        }

        typedef struct
        {
            char * cDivQ;
            char * cDivR;
        } stBIGNeDiv, * ptBIGNeDiv;

        static void tBIGNegDiv(const char * pN, const char * pD, int n, const HB_MAXUINT nB , ptBIGNeDiv pegDiv){
    
            HB_MAXUINT szptBIGNeDiv = sizeof(ptBIGNeDiv*);
            HB_MAXUINT szstBIGNeDiv = sizeof(stBIGNeDiv);
    
            ptBIGNeDiv *peDVArr     = (ptBIGNeDiv*)hb_xgrab(szptBIGNeDiv);
            ptBIGNeDiv pegDivTmp    = (ptBIGNeDiv)hb_xgrab(szstBIGNeDiv);
            
            char * Tmp              = tBIGNPadL("1",n,"0");
            pegDivTmp->cDivQ        = hb_strdup(Tmp);
            hb_xfree(Tmp);
            
            pegDivTmp->cDivR        = hb_strdup(pD);
            
            int nI = 0;
 
            do {

                peDVArr     = (ptBIGNeDiv*)hb_xrealloc(peDVArr,(nI+1)*szptBIGNeDiv);
                peDVArr[nI] = (ptBIGNeDiv)hb_xgrab(szstBIGNeDiv);
                
                peDVArr[nI]->cDivQ = hb_strdup(pegDivTmp->cDivQ);
                peDVArr[nI]->cDivR = hb_strdup(pegDivTmp->cDivR);  

                char * tmp = tBIGNAdd(pegDivTmp->cDivQ,pegDivTmp->cDivQ,n,n,nB);
                hb_xmemcpy(pegDivTmp->cDivQ,tmp,n);
                hb_xfree(tmp);
                    
                tmp        = tBIGNAdd(pegDivTmp->cDivR,pegDivTmp->cDivR,n,n,nB);
                hb_xmemcpy(pegDivTmp->cDivR,tmp,n);
                hb_xfree(tmp);

                if (memcmp(pegDivTmp->cDivR,pN,n)==1){
                    break;
                }
                
                ++nI;

            } while (HB_TRUE);
  
            hb_xfree(pegDivTmp->cDivQ);
            hb_xfree(pegDivTmp->cDivR);

            int nF = nI;
  
            Tmp                     = tBIGNPadL("0",n,"0");
            pegDiv->cDivQ           = hb_strdup(Tmp);
            pegDiv->cDivR           = hb_strdup(Tmp);
            hb_xfree(Tmp);
  
            do {
                
                pegDivTmp->cDivQ = tBIGNAdd(pegDiv->cDivQ,peDVArr[nI]->cDivQ ,n,n,nB);
                hb_xmemcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,n);
                hb_xfree(pegDivTmp->cDivQ);
    
                pegDivTmp->cDivR = tBIGNAdd(pegDiv->cDivR,peDVArr[nI]->cDivR ,n,n,nB);
                hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
                hb_xfree(pegDivTmp->cDivR);
                
                int iCmp = memcmp(pegDiv->cDivR,pN,n);

                if (iCmp==0){
                    break;
                } else{
                        if (iCmp==1){
    
                            pegDivTmp->cDivQ = tBIGNSub(pegDiv->cDivQ,peDVArr[nI]->cDivQ ,n,n,nB);
                            hb_xmemcpy(pegDiv->cDivQ,pegDivTmp->cDivQ,n);
                            hb_xfree(pegDivTmp->cDivQ);
    
                            pegDivTmp->cDivR = tBIGNSub(pegDiv->cDivR,peDVArr[nI]->cDivR ,n,n,nB);
                            hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
                            hb_xfree(pegDivTmp->cDivR);
    
                    }
                }  
                
            } while (--nI>=0);
            
            for(nI=nF;nI>=0;nI--){
                hb_xfree(peDVArr[nI]->cDivQ);
                hb_xfree(peDVArr[nI]->cDivR);
                hb_xfree(peDVArr[nI]);
            }
            hb_xfree(peDVArr);
            peDVArr = NULL;
   
            pegDivTmp->cDivR = tBIGNSub(pN,pegDiv->cDivR,n,n,nB);
            hb_xmemcpy(pegDiv->cDivR,pegDivTmp->cDivR,n);
            hb_xfree(pegDivTmp->cDivR);
            hb_xfree(pegDivTmp);
                
        }
        
        HB_FUNC_STATIC( TBIGNEGDIV ){
 
            HB_SIZE n           = (HB_SIZE)(hb_parnint(4)+1); 
            char * pN           = tBIGNPadL(hb_parc(1),n,"0");
            char * pD           = tBIGNPadL(hb_parc(2),n,"0");
            ptBIGNeDiv pegDiv   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            int iCmp            = memcmp(pN,pD,n);
          
            switch(iCmp){
                case -1:{
                    pegDiv->cDivQ = tBIGNPadL("0",n,"0");
                    pegDiv->cDivR = hb_strdup(pN);
                    break;
                }
                case 0:{
                    pegDiv->cDivQ = tBIGNPadL("1",n,"0");
                    pegDiv->cDivR = tBIGNPadL("0",n,"0");
                    break;
                }
                default:{
                    const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
                    tBIGNegDiv(pN,pD,(int)n,nB,pegDiv);
                }
            }
            
            hb_storclen(pegDiv->cDivR,n,3);
            hb_retclen(pegDiv->cDivQ,n);

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pegDiv->cDivR);
            hb_xfree(pegDiv->cDivQ);
            hb_xfree(pegDiv);
        }
        
        static void tBIGNecDiv(const char * pA, const char * pB, int ipN, const HB_MAXUINT nB , ptBIGNeDiv pecDiv){
            
            int n                   = 0;
            
            pecDiv->cDivR           = hb_strdup(pA);
            char * aux              = hb_strdup(pB);
             
            HB_MAXUINT v1;
          
            ptBIGNeDiv  pecDivTmp   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));

            HB_MAXUINT szHB_MAXUINT = sizeof(HB_MAXUINT);
            HB_MAXUINT snHB_MAXUINT = ipN*szHB_MAXUINT;
            
            HB_MAXUINT *ipA         = (HB_MAXUINT*)hb_xgrab(snHB_MAXUINT);
            HB_MAXUINT *iaux        = (HB_MAXUINT*)hb_xgrab(snHB_MAXUINT);
                        
            int i = ipN;
            while(--i>=0){
                ipA[i]  = (*(&pecDiv->cDivR[i])-'0');
                iaux[i] = (*(&aux[i])-'0');
            }
 
            while (memcmp(iaux,ipA,ipN)<=0){
                n++;
                v1 = 0;
                i = ipN;
                while(--i>=0){
                    iaux[i] <<= 1;
                    iaux[i] += v1;
                    if (iaux[i]>=nB){
                        v1 = iaux[i]/nB;
                        iaux[i] %= nB;
                    }else{
                        v1 = 0;
                    }
                }
            }

            hb_xfree(ipA);
            ipA = NULL;
 
            i = ipN;
            while(--i>=0){
                aux[i]   = "0123456789"[iaux[i]];
            }
            
            hb_xfree(iaux);
            iaux = NULL;
            
            HB_MAXUINT *idivQ = (HB_MAXUINT*)calloc(ipN,szHB_MAXUINT);
            char * sN2        = tBIGNPadL("2",ipN,"0");
 
            while (n--){            
                tBIGNegDiv(aux,sN2,ipN,nB,pecDivTmp);
                hb_xmemcpy(aux,pecDivTmp->cDivQ,ipN);
                hb_xfree(pecDivTmp->cDivQ);
                hb_xfree(pecDivTmp->cDivR);    
                v1 = 0;
                i = ipN;
                while(--i>=0){
                    idivQ[i] <<= 1;
                    idivQ[i] += v1;
                    if (idivQ[i]>=nB){
                        v1 = idivQ[i]/nB;
                        idivQ[i] %= nB;
                    }else{
                        v1 = 0;
                    }
                }
                if (memcmp(pecDiv->cDivR,aux,ipN)>=0){
                    char * tmp = tBIGNSub(pecDiv->cDivR,aux,ipN,ipN,nB);
                    hb_xmemcpy(pecDiv->cDivR,tmp,ipN);
                    hb_xfree(tmp);
                    v1 = 0;
                    i  = ipN;
                    HB_BOOL bAdd = HB_TRUE;
                    while(--i>=0){
                        if (bAdd){
                            idivQ[i]++;
                            bAdd = HB_FALSE;
                        }    
                        idivQ[i] += v1;
                        if (idivQ[i]>=nB){
                            idivQ[i] -= nB;
                            v1 = 1;
                        }else{
                            v1 = 0;
                        }
                    } 
                }
            }
            
            hb_xfree(aux);
            hb_xfree(sN2);
            hb_xfree(pecDivTmp);
            
            pecDiv->cDivQ = (char*)hb_xgrab(ipN+1);

            i = ipN;
            while(--i>=0){
                pecDiv->cDivQ[i] = "0123456789"[idivQ[i]];
            }
            
            free(idivQ);
            idivQ = NULL;
            
        }
        
        HB_FUNC_STATIC( TBIGNECDIV ){
            
            HB_SIZE n           = (HB_SIZE)(hb_parnint(4)+1);
            char * pN           = tBIGNPadL(hb_parc(1),n,"0");
            char * pD           = tBIGNPadL(hb_parc(2),n,"0");
            ptBIGNeDiv pecDiv   = (ptBIGNeDiv)hb_xgrab(sizeof(stBIGNeDiv));
            int iCmp            = memcmp(pN,pD,n);
          
            switch(iCmp){
                case -1:{
                    pecDiv->cDivQ = tBIGNPadL("0",n,"0");
                    pecDiv->cDivR = hb_strdup(pN);
                    break;
                }
                case 0:{
                    pecDiv->cDivQ = tBIGNPadL("1",n,"0");
                    pecDiv->cDivR = tBIGNPadL("0",n,"0");
                    break;
                }
                default:{
                    const HB_MAXUINT nB = (HB_MAXUINT)hb_parnint(5);
                    tBIGNecDiv(pN,pD,(int)n,nB,pecDiv);
                }
            }
            
            hb_storclen(pecDiv->cDivR,n,3);
            hb_retclen(pecDiv->cDivQ,n);

            hb_xfree(pN);
            hb_xfree(pD);
            hb_xfree(pecDiv->cDivR);
            hb_xfree(pecDiv->cDivQ);
            hb_xfree(pecDiv);
        }
                
        /*
        static HB_MAXUINT tBIGNGDC(HB_MAXUINT x, HB_MAXUINT y){
            HB_MAXUINT nGCD = x;  
            x = HB_MAX(y,nGCD);
            y = HB_MIN(nGCD,y);
            if (y==0){
               nGCD = x;
            } else {
                  nGCD = y;
                  while (HB_TRUE){
                      if ((y=(x%y))==0){
                          break;
                      }
                      x    = nGCD;
                      nGCD = y;
                  }
            }
            return nGCD;
        }*/
        
        //http://en.wikipedia.org/wiki/Binary_GCD_algorithm
        static HB_MAXUINT tBIGNGDC(HB_MAXUINT u, HB_MAXUINT v){
          int shift;
         
          /* GCD(0,v) == v; GCD(u,0) == u, GCD(0,0) == 0 */
          if (u == 0) return v;
          if (v == 0) return u;
         
          /* Let shift:=lg K, where K is the greatest power of 2
                dividing both u and v. */
          for (shift = 0; ((u | v) & 1) == 0; ++shift) {
                 u >>= 1;
                 v >>= 1;
          }
         
          while ((u & 1) == 0)
            u >>= 1;
         
          /* From here on, u is always odd. */
          do {
               /* remove all factors of 2 in v -- they are not common */
               /*   note: v is not zero, so while will terminate */
               while ((v & 1) == 0)  /* Loop X */
                   v >>= 1;
         
               /* Now u and v are both odd. Swap if necessary so u <= v,
                  then set v = v - u (which is even). for bignums, the
                  swapping is just pointer movement, and the subtraction
                  can be done in-place. */
               if (u > v) {
                 unsigned int t = v; v = u; u = t;}  // Swap u and v.
               v = v - u;                            // Here v >= u.
             } while (v != 0);
         
          /* restore common factors of 2 */
          return u << shift;
        }

        HB_FUNC_STATIC( TBIGNGDC ){
            hb_retnint(tBIGNGDC((HB_MAXUINT)hb_parnint(1),(HB_MAXUINT)hb_parnint(2)));
        }

        /*
        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x, HB_MAXUINT y){
             
            HB_MAXUINT nLCM = 1;
            HB_MAXUINT i    = 2;
        
            HB_BOOL lMx;
            HB_BOOL lMy;
        
            while (HB_TRUE){
                lMx = ((x%i)==0);
                lMy = ((y%i)==0);
                while (lMx||lMy){
                    nLCM *= i;
                    if (lMx){
                        x   /= i;
                        lMx = ((x%i)==0);
                    }
                    if (lMy){
                        y   /= i;
                        lMy = ((y%i)==0);
                    }
                }
                if ((x==1)&&(y==1)){
                    break;
                }
                ++i;
            }
            
            return nLCM;

        }
        */

        static HB_MAXUINT tBIGNLCM(HB_MAXUINT x, HB_MAXUINT y){
            return ((y/tBIGNGDC(x,y))*x);
        }    
        
        HB_FUNC_STATIC( TBIGNLCM ){
            hb_retnint(tBIGNLCM((HB_MAXUINT)hb_parnint(1),(HB_MAXUINT)hb_parnint(2)));
        }

        static HB_MAXUINT tBIGNFI(HB_MAXUINT n){
            HB_MAXUINT i;
            HB_MAXUINT fi = n;
            for(i=2;((i*i)<=n);i++){
                if ((n%i)==0){
                    fi -= fi/i;
                }    
                while ((n%i)==0){
                    n /= i;
                }    
            } 
               if (n>1){
                   fi -= fi/n;
               }     
               return fi; 
        }
        
        HB_FUNC_STATIC( TBIGNFI ){
            hb_retnint(tBIGNFI((HB_MAXUINT)hb_parnint(1)));
        }
        
        HB_FUNC_STATIC( TBIGNALEN ){
           hb_retns(hb_arrayLen(hb_param(1,HB_IT_ARRAY)));
        }
      
        HB_FUNC_STATIC( TBIGNMEMCMP ){
           hb_retnint(memcmp(hb_parc(1),hb_parc(2),hb_parclen(1)));
        }

        HB_FUNC_STATIC( TBIGNMAX ){
           hb_retnint(HB_MAX(hb_parnint(1),hb_parnint(2)));
        }
        
        HB_FUNC_STATIC( TBIGNMIN ){
           hb_retnint(HB_MIN(hb_parnint(1),hb_parnint(2)));
        }
         
        HB_FUNC_STATIC( TBIGNNORMALIZE ){
            
            HB_SIZE nInt1 = (HB_SIZE)hb_parnint(2);
            HB_SIZE nInt2 = (HB_SIZE)hb_parnint(7);
            HB_SIZE nPadL = HB_MAX(nInt1,nInt2);
 
            HB_SIZE nDec1 = (HB_SIZE)hb_parnint(4);
            HB_SIZE nDec2 = (HB_SIZE)hb_parnint(9);            
            HB_SIZE nPadR = HB_MAX(nDec1,nDec2);
    
            HB_BOOL lPadL = nPadL!=nInt1;
            HB_BOOL lPadR = nPadR!=nDec1;
        
            char * tmpPad;
    
            if (lPadL || lPadR){
                if (lPadL){
                    tmpPad = tBIGNPadL(hb_parc(1),nPadL,"0");
                    hb_storclen(tmpPad,nPadL,1);
                    hb_stornint(nPadL,2);
                    hb_xfree(tmpPad);
                }
                if (lPadR){
                    tmpPad = tBIGNPadR(hb_parc(3),nPadR,"0");
                    hb_storclen(tmpPad,nPadR,3);
                    hb_stornint(nPadR,4);
                    hb_xfree(tmpPad);
                }
                hb_stornint(nPadL+nPadR,5);
            }

            lPadL = nPadL!=nInt2;
            lPadR = nPadR!=nDec2;
           
            if (lPadL || lPadR){
                if (lPadL){
                    tmpPad = tBIGNPadL(hb_parc(6),nPadL,"0");
                    hb_storclen(tmpPad,nPadL,6);
                    hb_stornint(nPadL,7);
                    hb_xfree(tmpPad);
                }
                if (lPadR){
                    tmpPad = tBIGNPadR(hb_parc(8),nPadR,"0");
                    hb_storclen(tmpPad,nPadR,8);
                    hb_stornint(nPadR,9);
                    hb_xfree(tmpPad);
                }
                hb_stornint(nPadL+nPadR,10);
            }
       
        }
        
    #pragma endDUMP

#endif // __HARBOUR__