Class Demo.API.RestServer Extends %CSP.REST
{

Parameter TargetConfigName = "WebAPIService";

XData UrlMap
{
<Routes>
<Route Url="/getDetails/:Date" Method="GET" Call="GetImageSQLData"/>
<Route Url="/getPicture/:Date" Method="GET" Call="GetImage"/>
<Route Url="/ImageDownload/:Date" Method="Post" Call="DownloadImage"/>
<Route Url="/TaskStatus/:ServiceName/:Date" Method="GET" Call="GetTaskStatus"/>

</Routes>
}

/// <METHOD>GetImageSQLData</METHOD> Gets Image data from SQL Database
ClassMethod GetImageSQLData(Date As %String) As %Status
{
	set tSC=$$$OK
	try 
	{
		set tRequest=##class(Demo.API.ImageRequest).%New()
		set tRequest.Type="ImageRecord"
		set tRequest.Date=Date
		set tSC = ##class(Ens.Director).CreateBusinessService(..#TargetConfigName,.tService)
		set tResponse=##class(Demo.Messages.ImageResponse).%New()
		set tSC = tService.ProcessInput(tRequest,.tResponse)
		set tSC= tResponse.%JSONExportToString(.JSONStr)
	
		set %response.ContentType = "application/json"
		If (JSONStr '="{}"){
			write JSONStr
		}Else{
			set %response.ContentType = "text"
			write "No record found"
		}
	}
	catch ex 
	{
		set tSC = ex.AsStatus()
	}
	return tSC
}

/// <METHOD>GetImage</METHOD> Gets Image from Cloud Storage
ClassMethod GetImage(Date As %String) As %Status
{
	set tSC=$$$OK
	try 
	{
		set tRequest=##class(Demo.API.ImageRequest).%New()
		set tRequest.Type="Image"
		set tRequest.Date=Date
		set tSC = ##class(Ens.Director).CreateBusinessService(..#TargetConfigName,.tService)
		set tResponse=##class(Demo.API.ImageStreamResponse).%New()
		set tSC = tService.ProcessInput(tRequest,.tResponse)
			
		If (tResponse.ImageStream.Size>0){
			set %response.ContentType = "image/jpg"
			While 'tResponse.ImageStream.AtEnd{
				write tResponse.ImageStream.Read()
			}
		}Else{
			set %response.ContentType = "text"
			write "No record found"
		}		
	}
	catch ex 
	{
		set tSC = ex.AsStatus()
	}
	return tSC
}

/// <METHOD>GetImage</METHOD> Gets Image from Cloud Storage
ClassMethod DownloadImage(Date As %String) As %Status
{
	set tSC=$$$OK
	try 
	{
		set tRequest=##class(Demo.API.ImageRequest).%New()
		set tRequest.Type="ImageDownload"
		set tRequest.Date=Date
		set tSC = ##class(Ens.Director).CreateBusinessService(..#TargetConfigName,.tService)
		set tSC = tService.ProcessInput(tRequest,.tResponse)
		If $IsObject(tResponse){
			set tSC= tResponse.%JSONExportToString(.JSONStr)
			set %response.ContentType = "application/json"
			write JSONStr
		}
		Else{
			set %response.ContentType = "text"
			write $system.Status.GetOneErrorText(tSC)	
		}
				
		
	}
	catch ex 
	{
		set tSC = ex.AsStatus()
		set %response.ContentType = "text"
		write $system.Status.GetOneErrorText(tSC)
	}
	return $$$OK
}

/// <METHOD>GetImage</METHOD> Gets Image status
ClassMethod GetTaskStatus(ServiceName As %String, Date As %String) As %Status
{
	set tSC=$$$OK
	try 
	{
		set tRequest=##class(Demo.API.ImageRequest).%New()
		set tRequest.Type="ImageStatus"
		set tRequest.Date=Date
		set tRequest.ServiceName=ServiceName
	
		set tSC = ##class(Ens.Director).CreateBusinessService(..#TargetConfigName,.tService)
		set tSC = tService.ProcessInput(tRequest,.tResponse)
		If $IsObject(tResponse){
			set tSC= tResponse.%JSONExportToString(.JSONStr)
			set %response.ContentType = "application/json"
			write JSONStr
		}
		Else{
			set %response.ContentType = "text"
			write $system.Status.GetOneErrorText(tSC)	
		}
				
		
	}
	catch ex 
	{
		set tSC = ex.AsStatus()
		set %response.ContentType = "text"
		write $system.Status.GetOneErrorText(tSC)
	}
	return $$$OK
}

}
