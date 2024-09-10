component {

	// this Application.cfc is for turning on the ORM 

	this.name = hash( getCurrentTemplatePath() );

	this.datasource =  server.getDatasource( "h2", server._getTempDir( "LDEV5806" ) );
	
	this.ormEnabled = true;
	this.ormSettings.dbcreate = 'dropcreate';	

	public function onRequestStart() {
		setting requesttimeout=10;
	}
}