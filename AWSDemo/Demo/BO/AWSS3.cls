Class Demo.BO.AWSS3 Extends Ens.BusinessOperation
{

Parameter ADAPTER = "Ens.OutboundAdapter";

Property Adapter As Ens.OutboundAdapter;

Property AWSCredentials As %String [ InitialExpression = "AWSS3Access" ];

Parameter SETTINGS = "AWSCredentials";

Parameter INVOCATION = "Queue";

Method PutFileOnS3(pRequest As Demo.Messages.AWSRequestMessage, Output pResponse As Demo.Messages.AWSResponseMessage) As %Status
{
	set tSC = $$$OK
	try {
		//S3 Bucket URL based on Bucket Name
		set tServer = $ZCONVERT(pRequest.BucketName_"."_pRequest.Service_".amazonaws.com","L")
		set tHTTPRequest = ##class(%Net.HttpRequest).%New()        
    	set tHTTPRequest.Https=1
   		set tHTTPRequest.SSLConfiguration=pRequest.SSLConfig                         
    	set tHTTPRequest.Server = tServer                                       

		///Get Date Formats required for Authorisation Header
		set tSC = ##class(Demo.AWSIntegration.Utils).GetAWSDateFormats(.tTimeStampISO8601Format,.tAWSDate,.tDate)
       
		///Set the AWS specific Headers. 
    	set tHTTPRequest.Date= tAWSDate
		do tHTTPRequest.SetHeader("x-amz-date", tTimeStampISO8601Format)
		do tHTTPRequest.SetHeader("x-amz-storage-class","STANDARD")
		
		
		//Set tOutFile = ##class(%FileBinaryStream).%New()
    	//Set tSC = tOutFile.CopyFrom(pRequest.FileStream)
    	Set tSC = tHTTPRequest.EntityBody.CopyFromAndSave(pRequest.FileStream)
	    set tNormalizedFileName = pRequest.FileName
    	Set tHTTPRequest.ContentType = "image/jpg"
    	
    	/// x-amz-content-sha256 value is the hex of hash of the request body.  
		Set tHashedPayload = ""
    	set tSC=##class(Demo.AWSIntegration.Utils).CreateHashedPayload(tHTTPRequest.EntityBody,.tHashedPayload)
    	do tHTTPRequest.SetHeader("x-amz-content-sha256",tHashedPayload)
		/// Content Length must be set
		do tHTTPRequest.SetHeader("Content-Length",tHTTPRequest.EntityBody.Size)
	
		///Create the Signature 
		Set tSC = ##class(Demo.AWSIntegration.Utils).CreateSignature(pRequest.CredentialName,"PUT", tHTTPRequest.ReturnHeaders(), "", "/"_tNormalizedFileName,pRequest.Region,pRequest.Service, tTimeStampISO8601Format, tDate, .SignedHeaders, .AccessKeyId, .URIEncodedPath,.Signature)
		
		///Create the Authorization
		set tSC = ##class(Demo.AWSIntegration.Utils).CreateAuthorization(AccessKeyId,tDate,pRequest.Region,pRequest.Service,SignedHeaders,Signature,.tAuthorization)
	   	
		set tHTTPRequest.Authorization = tAuthorization
		set tURL =  URIEncodedPath
		$$$TRACE(tURL)
		set tSC = tHTTPRequest.Put(tURL)
		
		set ErrorObject=""
		set pResponse=##class(Demo.Messages.AWSResponseMessage).%New()
		set pResponse.HTTPResponseCode=tHTTPRequest.HttpResponse.StatusCode
		$$$TRACE(tHTTPRequest.HttpResponse.StatusCode)

   		If (tSC) && (tHTTPRequest.HttpResponse.StatusCode="200")  {
			If $IsObject(tHTTPRequest.HttpResponse.Data){
				Set status = tHTTPRequest.HttpResponse.Data.Rewind()
				Set status = pResponse.OutputStream.CopyFromAndSave(tHTTPRequest.HttpResponse.Data)
			}	
		}
		Else{
			set ErrorObject=##class(Demo.AWSIntegration.ErrorObject).%New()
			set ErrorObject.HTTPResponseStatusCode=tHTTPRequest.HttpResponse.StatusCode
			set vErrorDoc=##class(EnsLib.EDI.XML.Document).ImportFromString(tHTTPRequest.HttpResponse.Data.Read(),.tSC)
			If tSC{
				set ErrorObject.ErrorCode= vErrorDoc.GetValueAt("/Error/Code")
				set ErrorObject.ErrorDescription= vErrorDoc.GetValueAt("/Error/Message")	
			}
			Set status = tHTTPRequest.HttpResponse.Data.Rewind()
			Set status = pResponse.OutputStream.CopyFromAndSave(tHTTPRequest.HttpResponse.Data)
			set pResponse.ErrorObject=ErrorObject
		}	
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/// Sample URL https://irisawss3integration.s3-eu-west-1.amazonaws.com/2019-08-02.jpg
Method GetFileFromS3(pRequest As Demo.API.ImageGetRequest, Output pResponse As Demo.API.ImageStreamResponse) As %Status
{
	set tSC = $$$OK
	try {

		//S3 Bucket URL based on Bucket Name
		set tServer = $P($p(pRequest.URL,"//",*),"/",1)
		set tHTTPRequest = ##class(%Net.HttpRequest).%New()        
    	set tHTTPRequest.Https=1
   		set tHTTPRequest.SSLConfiguration=pRequest.SSLConfig                          
    	set tHTTPRequest.Server = tServer                                       
		set FileName=$PIECE($EXTRACT(pRequest.URL,9,*),"/","2")
		set Region=$EXTRACT($P($P($p(pRequest.URL,"//",*),"/",1),".",2),4,*)
		Set AWSService=$EXTRACT($P($P($p(pRequest.URL,"//",*),"/",1),".",2),1,2)
		///Get Date Formats required for Authorisation Header
		set tSC = ##class(Demo.AWSIntegration.Utils).GetAWSDateFormats(.tTimeStampISO8601Format,.tAWSDate,.tDate)
    
    	///Set the AWS specific Headers. 
		set tHTTPRequest.Date= tAWSDate
    	do tHTTPRequest.SetHeader("x-amz-date", tTimeStampISO8601Format)
    	Set tHashedPayload = ""
		/// Because this GET request does not provide any body content, the x-amz-content-sha256 value is the hex of hash of the empty request body.  
		set tSC=##class(Demo.AWSIntegration.Utils).CreateHashedPayload(tHTTPRequest.EntityBody,.tHashedPayload)
		do tHTTPRequest.SetHeader("x-amz-content-sha256",tHashedPayload)
		Set tHTTPRequest.ContentType = "image/jpg"
		///Create the Signature 
		$$$TRACE(FileName)
		Set tSC = ##class(Demo.AWSIntegration.Utils).CreateSignature(pRequest.CredentialName,"GET", tHTTPRequest.ReturnHeaders(), "", "/"_FileName, Region,AWSService, tTimeStampISO8601Format, tDate, .SignedHeaders, .AccessKeyId, .URIEncodedPath,.Signature)
	
		///Create the Authorization
		set tSC = ##class(Demo.AWSIntegration.Utils).CreateAuthorization(AccessKeyId,tDate,Region,AWSService,SignedHeaders,Signature,.tAuthorization)
	   	
		set tHTTPRequest.Authorization = tAuthorization
    	set tURL = URIEncodedPath
    	$$$TRACE(tURL)
		set tSC = tHTTPRequest.Get(tURL)
   		set ErrorObject=""
   		Set pResponse = ##class(Demo.API.ImageStreamResponse).%New()
   		If (tSC) && (tHTTPRequest.HttpResponse.StatusCode="200")  {
			
   			If $IsObject(tHTTPRequest.HttpResponse.Data){
				$$$TRACE(tHTTPRequest.HttpResponse.Data.Read())
				Set status = tHTTPRequest.HttpResponse.Data.Rewind()
				Set status = pResponse.ImageStream.CopyFromAndSave(tHTTPRequest.HttpResponse.Data)
			}	
		}
		Else{
			set ErrorObject=##class(Demo.AWSIntegration.ErrorObject).%New()
			set ErrorObject.HTTPResponseStatusCode=tHTTPRequest.HttpResponse.StatusCode
			set vErrorDoc=##class(EnsLib.EDI.XML.Document).ImportFromString(tHTTPRequest.HttpResponse.Data.Read(),.tSC)
			If tSC{
				set ErrorObject.ErrorCode= vErrorDoc.GetValueAt("/Error/Code")
				set ErrorObject.ErrorDescription= vErrorDoc.GetValueAt("/Error/Message")	
			}	
			$$$TRACE(ErrorObject.ErrorDescription)
			set pResponse.ErroObject=ErrorObject
		}	
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Demo.Messages.AWSRequestMessage"> 
		<Method>PutFileOnS3</Method>
	</MapItem>
		<MapItem MessageType="Demo.API.ImageGetRequest"> 
		<Method>GetFileFromS3</Method>
	</MapItem>
</MapItems>
}

}
