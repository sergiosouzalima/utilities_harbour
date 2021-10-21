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
					context "and new method" expect(oUtilities) TO_BE_CLASS_NAME("Utilities")
				enddescribe
			enddescribe

			describe "oUtilities:isValidDate( xDate )"
				describe "When invalid parameter"
					describe "and no parameters given: oUtilities:isValidDate()"
						oUtilities:isValidDate()
						context "oUtilities:Valid" expect(oUtilities:Valid) TO_BE_FALSY
					enddescribe
					describe "and string given is invalid date: oUtilities:isValidDate( '32011980' )"
						oUtilities:isValidDate( '32011980'  )
						context "oUtilities:Valid" expect(oUtilities:Valid) TO_BE_FALSY
					enddescribe
					describe "and string and no separators given: oUtilities:isValidDate( '31011980' )"
						oUtilities:isValidDate( '31011980'  )
					context "oUtilities:Valid" expect(oUtilities:Valid) TO_BE_FALSY
				enddescribe

				enddescribe

				describe "When valid parameter"
					describe "and date given: oUtilities:isValidDate( date() )"
						oUtilities:isValidDate( date() )
						context "oUtilities:Valid" expect(oUtilities:Valid) TO_BE_TRUTHY
					enddescribe
					describe "and string given: oUtilities:isValidDate( '31/01/1980' )"
						oUtilities:isValidDate( '31/01/1980'  )
						context "oUtilities:Valid" expect(oUtilities:Valid) TO_BE_TRUTHY
					enddescribe
					describe "and string given: oUtilities:isValidDate( '31-01-1980' )"
						oUtilities:isValidDate( '31-01-1980'  )
						context "oUtilities:Valid" expect(oUtilities:Valid) TO_BE_TRUTHY
					enddescribe
				enddescribe
			enddescribe

			oUtilities := oUtilities:Destroy()

		enddescribe

	endhbexpect

RETURN NIL
