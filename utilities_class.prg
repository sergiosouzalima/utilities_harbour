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
    DATA lValid                     AS LOGICAL  INIT .F.

    EXPORTED:
        METHOD  New() CONSTRUCTOR
        METHOD  Destroy()
        METHOD  isValidDate(cDate, cDateFormat)
        METHOD  Valid( lValid ) SETGET

    ERROR HANDLER OnError( xParam )
ENDCLASS

METHOD New() CLASS Utilities
RETURN Self

METHOD Destroy() CLASS Utilities
    Self := NIL
RETURN Self

METHOD Valid( lValid ) CLASS Utilities
    ::lValid := lValid IF hb_isLogical(lValid)
RETURN ::lValid

METHOD isValidDate(xDate, cDateFormat) CLASS Utilities
    LOCAL cDtFrmt := hb_defaultValue(cDateFormat, 'DD/MM/YYYY')
    TRY
        ::Valid := .F.
        BREAK IF (::Valid := (ValType(xDate) == "D"))
        BREAK IF Empty(hb_CtoD(xDate, cDtFrmt))
        ::Valid := .T.
    CATCH
    ENDTRY
RETURN ::Valid

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