/**
 * Test HTML documentation strategy
 */
component extends="testbox.system.BaseSpec" {

	variables.testOutputDir = expandPath( "/tests/tmp/html" );

	/*********************************** LIFE CYCLE Methods ***********************************/

	/*********************************** BDD SUITES ***********************************/

	function run(){
		// all your suites go here.
		describe( "CommandBoxStrategy", function(){
			beforeEach( function(){
				variables.docbox = new docbox.DocBox(
					strategy   = "docbox.strategy.CommandBox.CommandBoxStrategy",
					properties = {
						projectTitle : "DocBox Tests",
						outputDir    : variables.testOutputDir
					}
				);
				// empty the directory so we know if it has been populated
				if ( directoryExists( variables.testOutputDir ) ) {
					directoryDelete( variables.testOutputDir, true );
				}
				directoryCreate( variables.testOutputDir );
			} );

			it( "can run without failure", function(){
				variables.docbox.generate(
					source   = expandPath( "/tests" ),
					mapping  = "tests",
					excludes = "(coldbox|build\-docbox)"
				);
			} );

			it( "throws exception when outputDir does not exist", function() {
				expect( function(){
					var testDocBox = new docbox.DocBox(
						strategy   = "docbox.strategy.CommandBox.CommandBoxStrategy",
						properties = {
							projectTitle : "DocBox Tests",
							outputDir    : expandPath( "nowhere/USA" )
						}
					);
					testDocBox.generate(
						source   = expandPath( "/tests" ),
						mapping  = "tests",
						excludes = "(coldbox|build\-docbox)"
					);
				}).toThrow( "InvalidConfigurationException" );
			});

			it( "produces HTML output in the correct directory", function(){
				variables.docbox.generate(
					source   = expandPath( "/tests" ),
					mapping  = "tests",
					excludes = "(coldbox|build\-docbox)"
				);

				var overviewFile = variables.testOutputDir & "/overview-frame.html";
				expect( fileExists( overviewFile ) ).toBeTrue(
					"should generate overview-frame.html file to list all commands"
				);

				var overviewHTML = fileRead( overviewFile );
				expect( overviewHTML ).toInclude(
					"Create",
					"should document commands/Create.cfc in list of classes."
				);

				var testFile = variables.testOutputDir & "/commands/create.html";
				expect( fileExists( testFile ) ).toBeTrue(
					"should generate #testFile# to document 'testmodule create' command.cfc"
				);
			} );
		} );
	}

}

