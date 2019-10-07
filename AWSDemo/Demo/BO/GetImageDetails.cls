Class Demo.BO.GetImageDetails Extends Ens.BusinessOperation
{

Parameter ADAPTER = "EnsLib.HTTP.OutboundAdapter";

Property Adapter As EnsLib.HTTP.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property ApiKey As %String [ InitialExpression = "IXgJgIaA8CjRfxwKOeP6rsMdE60HoRVsaGXFgtPE" ];

Parameter SETTINGS = "ApiKey";

Method GetImageDataURL(pRequest As Demo.Messages.Schedule, Output pResponse As Demo.Messages.ImageResponse) As %Status
{
	set tSC=$$$OK
	
	try
	{
	
		//set tFormVar="date,api_key"
		set tFormVar="api_key"
		//Get API Key
		set apiKey = ""
		//Call  GET
		set tHttpResponse=##class(%Net.HttpResponse).%New()
		//set tSC = ..Adapter.Get(.tHttpResponse,tFormVar,pRequest.ImageDate,..ApiKey)
		set tSC = ..Adapter.Get(.tHttpResponse,tFormVar,..ApiKey)

		//Handle Response Errors
		if $$$ISERR(tHttpResponse)
		{
			do $system.Status.DisplayError(tHttpResponse)
		}
		else 
		{
			set pResponse=##class(Demo.Messages.ImageResponse).%New()
		
			If $IsObject(tHttpResponse.Data){
				do tHttpResponse.Data.Rewind()
				set imageJSON = {}.%FromJSON($ZCONVERT(tHttpResponse.Data.Read(),"I","JSON"))
				set pResponse.Date=imageJSON.date
				set pResponse.Copyright=imageJSON.copyright
				set pResponse.Explanation=imageJSON.explanation
				set pResponse.HDURL=imageJSON.hdurl
				set pResponse.MediaType=imageJSON."media_type"
				set pResponse.ServiceVersion=imageJSON."service_version"
				set pResponse.Title=imageJSON.title
				set pResponse.URL=imageJSON.url
				
				
			}

		}
	} catch ex {
		s tSC = ex.AsStatus()
	}
	
	Quit tSC
}

Method GetImage(pRequest As Demo.Messages.RetrieveImageRequest, Output pResponse As Demo.Messages.ImageStreamResponse) As %Status
{
	set tSC=$$$OK
	
	try
	{
	
		set ..Adapter.URL= pRequest.URL
		set tHttpResponse=""
		set tSC = ..Adapter.Get(.tHttpResponse)
		$$$TRACE(tSC)
		//Handle Response Errors
		
		if $$$ISERR(tHttpResponse)
		{
			do $system.Status.DisplayError(tHttpResponse)
		}
		else 
		{
			Set pResponse = ##class(Demo.Messages.ImageStreamResponse).%New()
   			If $IsObject(tHttpResponse.Data){
				
				Set status = tHttpResponse.Data.Rewind()
				Set status = pResponse.FileStream.CopyFromAndSave(tHttpResponse.Data)
			}	
				

		}
	} catch ex {
		s tSC = ex.AsStatus()
	}
	
	Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.Messages.Schedule"> 
		<Method>GetImageDataURL</Method>
	</MapItem>
	<MapItem MessageType="Demo.Messages.RetrieveImageRequest"> 
		<Method>GetImage</Method>
	</MapItem>
</MapItems>
}

}
