<cfscript>
try {
    // run this test with /loader>>ant -DtestLabels="orm"
    // it will be called 3 times by test/tickets/LDEV5086.cfc
	param name="form.scene" default="0";

    bigDecimalNumber = 12345.123456;

	if(form.scene eq 1) {
        person = entityNew( "Person", { firstName : "Susi", lastName: "Doe", balance : bigDecimalNumber } ) ;
        EntitySave(person);
        ormFlush();
        writeOutput( "success1" );
	}

	else if(form.scene eq 2) {
		minBalance = 10000.023423430;
        queryStr = "FROM Person WHERE balance > :minBalance";
        results = ORMExecuteQuery(queryStr, {minBalance: minBalance});

        if(arrayIsEmpty(results))
        {
            writeOutput( "failure, query did not find Susi" );
        }

        else if(arrayLen(results) neq 1)
        {
            writeOutput( "failure, too many results, expected 1, got #arrayLen(results)# " );
        }
        else
        {
            writeOutput( "success2" );
        } 
	}

    else if(form.scene eq 3) {
		minBalance = 10000.023423430;
        queryStr = "FROM Person WHERE balance > :minBalance";
        results = ORMExecuteQuery(queryStr, {minBalance: minBalance});

        if(arrayLen(results) eq 1)
        {
            // check that roundtrip has not changed the balance
            for (person in results) {
                balance = person.getBalance()
                if(balance eq bigDecimalNumber )
                {
                    writeOutput( "success3" );
                }
                else
                {
                    writeOutput( "failure, balance was #balance#, but should be #bigDecimalNumber#" );
                }
            }
        }
        else
        {
            writeOutput( "failure, could not find right number of records" );
        }
	}
		
}
catch(any e) {
    writeoutput(e.message);
}
</cfscript>