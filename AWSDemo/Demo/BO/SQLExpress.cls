Class Demo.BO.SQLExpress extends Ens.BusinessOperation {

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Method InsertImageData(pRequest As Demo.Messages.SQLImageRequest, Output pResponse As Demo.Messages.SQLImageResponse) As %Status
{
	try {
		Set tSC=$$$OK
		set pResponse=$$$NULLOREF
		set pResponse=##class(Demo.Messages.SQLImageResponse).%New()
		set pResponse.Date=pRequest.Date
		///Check if the record based on GUID already exists within Staging table
		set sqlSelect="Select 1 from [dbo].[NasaImages] where [ImageDate] = "_"'"_pRequest.Date_"'"
		$$$TRACE("Select Query "_sqlSelect)
		set tSC = ..Adapter.ExecuteQuery(.tResultSet,sqlSelect)
		If tSC{
			$$$TRACE("Query Status "_tSC)
			set recordFound=tResultSet.%Next()
			$$$TRACE("Existing Record Found for Date:"_pRequest.Date_" = "_recordFound)
			If 'recordFound{	
				$$$TRACE("Insert")	
				//Create the SQL String 
 				set sql="INSERT INTO [dbo].[NasaImages]"_
           			"([ImageDate]"_
           			",[Copyright]"_
          	 		",[Explanation]"_
           			",[HDURL]"_
           			",[MediaType]"_
           			",[ServiceVersion]"_
           			",[Title]"_
           			",[OriginalURL]"_
           			",[URL])"_
           			"values (?,?,?,?,?,?,?,?,?)"
            		
            	///Create an array of parameters
				set paramArray(1)=pRequest.Date
				set paramArray(2)=pRequest.Copyright
				set paramArray(3)=pRequest.Explanation
				set paramArray(4)=pRequest.HDURL
				set paramArray(5)=pRequest.MediaType
				set paramArray(6)=pRequest.ServiceVersion
				set paramArray(7)=pRequest.Title
				set paramArray(8)=pRequest.OriginalURL
				set paramArray(9)="https://"_pRequest.BucketName_"."_pRequest.Service_"-"_pRequest.Region_".amazonaws.com/"_pRequest.Date_"."_pRequest.Extension
				//perform the Insert
 				set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,paramArray(1),paramArray(2),paramArray(3),paramArray(4),paramArray(5),paramArray(6),paramArray(7),paramArray(8),paramArray(9))
				$$$TRACE("No of Records Inserted "_nrows)
				If tSC{
					set pResponse.Status="Completed"
					set pResponse.Description="Record Inserted"
					set pResponse.ErrorDescription=""
				}
				Else{
					set pResponse.Status="Error"
					set pResponse.Description="Error Inserting Record"
					set pResponse.ErrorDescription=$system.Status.GetOneErrorText(tSC)
				}	
			
			}
			Else{
				$$$TRACE("Update")		
				set sql="Update [dbo].[NasaImages]"_
           			" set [Copyright]=? "_
           			",[Explanation]=? "_
          			",[HDURL]=? "_
           			",[MediaType]=? "_
           			",[ServiceVersion]=? "_
           			",[Title]=? "_
           			",[OriginalURL]=? "_
           			",[URL]=? "_
           			"WHERE  [ImageDate]"_"="_"'"_pRequest.Date_"'"
					
				///Create an array of parameters
				set paramArray(1)=pRequest.Copyright
				set paramArray(2)=pRequest.Explanation
				set paramArray(3)=pRequest.HDURL
				set paramArray(4)=pRequest.MediaType
				set paramArray(5)=pRequest.ServiceVersion
				set paramArray(6)=pRequest.Title
				set paramArray(7)=pRequest.OriginalURL
				set paramArray(8)="https://"_pRequest.BucketName_"."_pRequest.Service_"-"_pRequest.Region_".amazonaws.com/"_pRequest.Date_"."_pRequest.Extension
	
				//perform the Update
 				set tSC = ..Adapter.ExecuteUpdate(.nrows,sql,paramArray(1),paramArray(2),paramArray(3),paramArray(4),paramArray(5),paramArray(6),paramArray(7),paramArray(8))
				$$$TRACE("No of Records Updated "_nrows)
				If tSC{
					set pResponse.Status="Completed"
					set pResponse.Description="Record Updated"
					set pResponse.ErrorDescription=""
				}
				Else{
					set pResponse.Status="Error"
					set pResponse.Description="Error Updating Record"
					set pResponse.ErrorDescription=$system.Status.GetOneErrorText(tSC)
				}
			}
			///Task History
			set tSC=##class(Demo.Analytics.Utils).CreateOrUpdateTaskHistory(pRequest.ServiceName,$ZDATETIME($H,3),$ZDATEH(pRequest.Date,5),"COMPLETED")

		
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

Method GetImageData(pRequest As Demo.Messages.ImageRecordDetailsRequest, Output pResponse As Demo.Messages.ImageResponse) As %Status
{
	try {
		Set tSC=$$$OK
		set pResponse=$$$NULLOREF
		///Check if the record based on GUID already exists within Staging table
		set sqlSelect="Select ImageDate,Copyright,Explanation,HDURL,MediaType,ServiceVersion,Title,URL from [dbo].[NasaImages] where [ImageDate] = "_"'"_pRequest.Date_"'"
		$$$TRACE("Select Query "_sqlSelect)
		set tSC = ..Adapter.ExecuteQuery(.tResultSet,sqlSelect)
		If tSC{
			$$$TRACE("Query Status "_tSC)
			set recordFound=tResultSet.%Next()
			$$$TRACE("Existing Record Found for Date:"_pRequest.Date_" = "_recordFound)
			set pResponse=##class(Demo.Messages.ImageResponse).%New()
			If recordFound{	
				
				set pResponse.Date=tResultSet.Get("ImageDate")
				set pResponse.Copyright=tResultSet.Get("Copyright")
				set pResponse.Explanation=tResultSet.Get("Explanation")
				set pResponse.HDURL=tResultSet.Get("HDURL")
				set pResponse.MediaType=tResultSet.Get("MediaType")
				set pResponse.ServiceVersion=tResultSet.Get("ServiceVersion")
				set pResponse.Title=tResultSet.Get("Title")
				set pResponse.URL=tResultSet.Get("URL")
			
			}
		}
	} Catch ex {
		Set tSC=ex.AsStatus()
	}
	Quit tSC
}

XData MessageMap {
<MapItems>
    <MapItem MessageType="Demo.Messages.SQLImageRequest">
        <Method>InsertImageData</Method>
    </MapItem>
    <MapItem MessageType="Demo.Messages.ImageRecordDetailsRequest">
        <Method>GetImageData</Method>
    </MapItem>
</MapItems>
}

}