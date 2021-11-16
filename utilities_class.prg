/*
    System.......:
    Program......: utilities_class.prg
    Description..: Commum methods class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/


#include "hbclass.ch"
#include "custom_commands_v1.1.0.ch"


CREATE CLASS Utilities

    EXPORTED:
        METHOD  New() CONSTRUCTOR
        METHOD  Destroy()
        METHOD  isValidDate(cDate, cDateFormat)
        METHOD  GetGUID(cParamGUID)
        METHOD  GetTimeStamp()
        METHOD  getNumericValueFromHash( hHash, xKey )
        METHOD  getStringValueFromHash( hHash, xKey )
ENDCLASS

METHOD New() CLASS Utilities
RETURN Self

METHOD Destroy() CLASS Utilities
    Self := NIL
RETURN Self

METHOD isValidDate(xDate, cDateFormat) CLASS Utilities
    LOCAL lOk := .F., cDtFrmt := hb_defaultValue(cDateFormat, 'DD/MM/YYYY')
    TRY
        BREAK IF (lOk := (ValType(xDate) == "D"))
        BREAK IF Empty(hb_CtoD(xDate, cDtFrmt))
        lOk := .T.
    CATCH
    ENDTRY
RETURN lOk

METHOD GetGUID(cParamGUID) CLASS Utilities
/*
    UUID version: version-4
    UUID variant: DCE 1.1, ISO/IEC 11578:1996
    Examples:   18475806-4d57-40d0-b5ab-b59c9b6df4c9
                2f8128b8-031c-413c-b046-a5a03aaa22ea
                816b80c0-184d-4c1e-917f-bd2c928a74a7
*/
  LOCAL cGUID := hb_defaultValue(cParamGUID, "")
  LOCAL lSetFormat := Len(cGUID) == 32
  IF lSetFormat
    cGUID := Stuff( cGUID, 09, 00, "-")
    cGUID := Stuff( cGUID, 14, 01, "-4")
    cGUID := Stuff( cGUID, 19, 01, "-A")
    cGUID := Stuff( cGUID, 24, 00, "-")
    RETURN cGUID
  ENDIF
RETURN ::GetGUID( cGUID + hb_StrToHex(hb_RandStr(02)) )

METHOD GetTimeStamp() CLASS Utilities
/*
    Returns current datetime as a datetimestamp string.
    Examples: 2021-10-25 19:54:03.023, 2021-10-25 19:54:04.051
*/
RETURN hb_TsTOStr( Hb_DateTime() )

METHOD getNumericValueFromHash( hHash, xKey )
    LOCAL nValue := 0, lHasKey := hb_hHasKey( hHash, xKey )
    LOCAL lOk := .F.

    IF lHasKey
        TRY
            BREAK IF (lOk := hb_IsNumeric(hHash[xKey]))
            BREAK IF (nValue := hb_Val(hHash[xKey]))
        CATCH
        ENDTRY
    ENDIF
    nValue := hHash[xKey] IF lOk
RETURN nValue

METHOD getStringValueFromHash( hHash, xKey )
    LOCAL cValue := "", lHasKey := hb_hHasKey( hHash, xKey )
    cValue := hHash[xKey] IF lHasKey .AND. hb_IsString(hHash[xKey])
RETURN cValue

/*METHOD getErrorDescription( cParamSql, nParamSqlErrorCode )
    LOCAL cErrorDescription := "", i := 0
    LOCAL cSql := hb_defaultValue(cParamSql, "")
    LOCAL cSqlErrorCode := lTrim(hb_ValToStr(hb_defaultValue(nParamSqlErrorCode, 0)))

    cErrorDescription :=  "SqlErrorCode:" + cSqlErrorCode + "; Sql:" + cSql
    while ( !Empty(ProcName(++i)) )
        cErrorDescription += "; Called from: " + Trim(ProcName(i)) + "(" + ;
            ALLTRIM(STR(ProcLine(i))) + ") - "+ ;
            SubStr(ProcFile(i),RAT("/",ProcFile(i))+1)
    end
RETURN cErrorDescription*/
