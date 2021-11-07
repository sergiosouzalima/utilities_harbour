/*
    System.......:
    Program......: utilities_class.prg
    Description..: Commum methods class
    Author.......: Sergio Lima
    Updated at...: Oct, 2021
*/


#include "hbclass.ch"
#include "custom_commands_v1.0.0.ch"


CREATE CLASS Utilities
    EXPORTED:
        METHOD  New() CONSTRUCTOR
        METHOD  Destroy()
        METHOD  isValidDate(cDate, cDateFormat)
        METHOD  GetGUID(cParamGUID)
        METHOD  GetTimeStamp()
        METHOD  getNumericValueFromHash( hHash, xKey )
        METHOD  getStringValueFromHash( hHash, xKey )

    ERROR HANDLER OnError( xParam )
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

METHOD ONERROR( xParam ) CLASS Utilities
    LOCAL cCol := __GetMessage(), xResult

    IF Left( cCol, 1 ) == "_" // underscore means it's a variable
       cCol = Right( cCol, Len( cCol ) - 1 )
       IF ! __objHasData( Self, cCol )
          __objAddData( Self, cCol )
       ENDIF
       IF xParam == NIL
          xResult = __ObjSendMsg( Self, cCol )
       ELSE
          xResult = __ObjSendMsg( Self, "_" + cCol, xParam )
       ENDIF
    ELSE
       xResult := "Method not created " + cCol
    ENDIF
    ? "*** Error => ", xResult
RETURN xResult