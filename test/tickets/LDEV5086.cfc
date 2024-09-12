component extends = "org.lucee.cfml.test.LuceeTestCase" labels="orm" {
	// run this test with /loader>ant -DtestLabels="orm"
    // it will be call test/tickets/LDEV5086/LDEV5086.cfm three times 
    this.name = "LDEV5086";

	public function onRequestStart() {
		setting requesttimeout=10;
	}

	function beforeAll() {
		variables.uri = createURI("LDEV5086");
	}

	function run( testResults , testBox ) {
		describe( "Testcase for LDEV-5086 - save bigdecimal via orm", function() {

			it(title = "Test that we can save an orm entity with bigdecimal field", body = function( currentSpec ) {
				local.result = _InternalRequest(
					template : "#uri#/LDEV5086.cfm",
					forms :	{ scene = 1 }
				);
				expect(trim(result.filecontent)).toBe('success1');
			});

			it(title = "Test query of orm entity with bigdecimal field", body = function( currentSpec ) {
				local.result = _InternalRequest(
					template : "#uri#/LDEV5086.cfm",
					forms :	{ scene = 2 }
				);
				expect(trim(result.filecontent)).toBe('success2');
			});

			it(title = "Test roundtrip of orm entity with double field", body = function( currentSpec ) {
				local.result = _InternalRequest(
					template : "#uri#/LDEV5086.cfm",
					forms :	{ scene = 3 }
				);
				expect(trim(result.filecontent)).toBe('success3');
			});

			it(title = "Test roundtrip of orm entity with bigdecimal field", body = function( currentSpec ) {
				local.result = _InternalRequest(
					template : "#uri#/LDEV5086.cfm",
					forms :	{ scene = 4 }
				);
				expect(trim(result.filecontent)).toBe('success4');
			});
		});
	}

	private string function createURI(string calledName){
		var baseURI = "/test/#listLast(getDirectoryFromPath(getCurrenttemplatepath()),"\/")#/";
		return baseURI&""&calledName;
	}
}