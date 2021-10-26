/*
    System.......:
    Program......: utilities_class.prg
    Description..: Commum methods class test.
    Author.......: Sergio Lima
    Updated at...: Oct, 2021

	How to compile:
	hbmk2 utilities_test.hbp

	How to run:
	./utilities_test

*/

#include "hbclass.ch"
#include "../../hbexpect/lib/hbexpect.ch"

FUNCTION Main()

	begin hbexpect
		LOCAL oUtilities

		describe "Utilities Class"
			oUtilities := Utilities():New()

			describe "When instantiate"
				describe "Utilities():New() --> oUtilities"
					context "and oUtilities object" expect(oUtilities) TO_BE_CLASS_NAME("Utilities")
					context "and oUtilities object" expect(oUtilities) NOT_TO_BE_NIL
				enddescribe
			enddescribe

			isValidate_test(oUtilities) WITH CONTEXT

			GetGUID_test(oUtilities) WITH CONTEXT

			GetTimeStamp_test(oUtilities) WITH CONTEXT

			oUtilities := oUtilities:Destroy()

		enddescribe

	endhbexpect

RETURN NIL

FUNCTION isValidate_test(oUtilities) FROM CONTEXT
	describe "oUtilities:isValidDate( xDate ) --> true/false"
		describe "When invalid parameter"
			describe "and no parameters given"
				context "isValidDate()" expect(oUtilities:isValidDate()) TO_BE_FALSY
			enddescribe
			describe "and string given is invalid date"
				context "isValidDate()" expect(oUtilities:isValidDate('32011980')) TO_BE_FALSY
			enddescribe
			describe "and string has no separators: oUtilities:isValidDate( '31011980' )"
				context "isValidDate()" expect(oUtilities:isValidDate('31011980')) TO_BE_FALSY
			enddescribe
		enddescribe

		describe "When valid parameter"
			describe "and current date given"
				context "isValidDate()" expect(oUtilities:isValidDate( date() )) TO_BE_TRUTHY
			enddescribe
			describe "and string is '31/01/1980'"
				context "isValidDate()" expect(oUtilities:isValidDate( '31/01/1980' )) TO_BE_TRUTHY
			enddescribe
			describe "and string is '31-01-1980'"
				context "isValidDate()" expect(oUtilities:isValidDate( '31-01-1980' )) TO_BE_TRUTHY
			enddescribe
		enddescribe
	enddescribe
RETURN NIL

FUNCTION GetGUID_test(oUtilities) FROM CONTEXT
	LOCAL cGUID := ""
	describe "oUtilities:GetGUID() --> cGUID"
		describe "cGUID hexa randomic value in the format 00000000-0000-0000-0000-000000000000"
		enddescribe
		describe "When getting GUID"
			context "GUID value" expect( cGUID := oUtilities:GetGUID() ) NOT_TO_BE_NIL
			context "GUID length" expect( Len(cGUID) ) TO_BE(36)
			context "GUID version-4, 15th position of the string" expect(substr(cGUID,15,1)) TO_BE("4")
			context "GUID variant 'DCE 1.1, ISO/IEC 11578:1996' 20th position of the string" expect(substr(cGUID,20,1)) TO_BE("A")
		enddescribe
	enddescribe
RETURN NIL

FUNCTION GetTimeStamp_test(oUtilities) FROM CONTEXT
	LOCAL cTimeStamp := ""
	describe "oUtilities:GetTimeStamp() --> cTimeStamp"
		describe "Example 2021-10-25 19:54:03.023 (Date Hour.Miliseconds)"
		enddescribe
		describe "When getting GetTimeStamp()"
			context "cTimeStamp value" expect( cTimeStamp := oUtilities:GetTimeStamp() ) NOT_TO_BE_NIL
			context "cTimeStamp length" expect( Len(cTimeStamp) ) TO_BE(23)
		enddescribe
	enddescribe
RETURN NIL