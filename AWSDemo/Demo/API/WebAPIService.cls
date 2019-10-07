Class Demo.API.WebAPIService Extends Ens.BusinessService
{

Property TargetConfigName As %String [ InitialExpression = "WebAPIProcess" ];

Parameter SETTINGS = "TargetConfigName";

Method OnProcessInput(pInput As %RegisteredObject, Output pOutput As %RegisteredObject) As %Status
{

	set tSC = $$$OK
	try {
		set tSC = ..SendRequestSync(..TargetConfigName,pInput,.pOutput)
		$$$ThrowOnError(tSC)		
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	return tSC
}

}
