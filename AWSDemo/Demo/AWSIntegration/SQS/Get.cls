Class Demo.AWSIntegration.SQS.Get
{

/***
AWS Signature Version 4
GET / HTTP/1.1
Host: sqs.s3.amazonaws.com
x-amz-date:20130524T000000Z
Authorization: SignatureToBeCalculated
Range: bytes=0-9 
x-amz-content-sha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date: 20130524T000000Z 
***/

/**
In AWS Signature Version 4, instead of using your AWS access keys to sign a request, you first create a
signing key that is scoped to a specific region and service.
1. String to Sign
	a. Canonical Request
	b. String to Sign
2. Signing Key
3. Signature
4. Authorization Header

Default 
set status=##class(Demo.AWSIntegration.SQS.Get).GetQueueURL(,,,,,,.URL,.ErrorObj)
**/
ClassMethod GetQueueURL(SSLConfig As %String = "AWS", AWSService As %String = "sqs", Region As %String = "eu-west-2", QueueName As %String = "TestDemo.AWSIntegrationQueue", QueueOwnerAWSAccountId As %String = "091533082706", CredentialName As %String = "AWSSQSAccess", Output QueueURL As %String, Output ErrorObject As Demo.AWSIntegration.ErrorObject) As %Status
{
	set tSC = $$$OK
	try {

		//S3 Bucket URL based on Bucket Name
		set tServer = $ZCONVERT(AWSService_"."_Region_".amazonaws.com","L")
		set tHTTPRequest = ##class(%Net.HttpRequest).%New()        
    	set tHTTPRequest.Https=1
   		set tHTTPRequest.SSLConfiguration=SSLConfig                          
    	set tHTTPRequest.Server = tServer                                       
		
		///Get Date Formats required for Authorisation Header
		set tSC = ##class(Demo.AWSIntegration.Utils).GetAWSDateFormats(.tTimeStampISO8601Format,.tAWSDate,.tDate)
    
    	///Set the AWS specific Headers. 
		set tHTTPRequest.Date= tAWSDate
    	do tHTTPRequest.SetHeader("x-amz-date", tTimeStampISO8601Format)
    	
    	Set tHashedPayload = ""
		/// Because this GET request does not provide any body content, the x-amz-content-sha256 value is the hex of hash of the empty request body.  
		set tSC=##class(Demo.AWSIntegration.Utils).CreateHashedPayload(tHTTPRequest.EntityBody,.tHashedPayload)
		do tHTTPRequest.SetHeader("x-amz-content-sha256",tHashedPayload)
		Set tQueryParams = "Action=GetQueueUrl&QueueName="_QueueName_"&QueueOwnerAWSAccountId=" _ QueueOwnerAWSAccountId
	
		///Create the Signature 
		Set tSC = ##class(Demo.AWSIntegration.Utils).CreateSignature(CredentialName,"GET", tHTTPRequest.ReturnHeaders(), tQueryParams, "/", Region,AWSService, tTimeStampISO8601Format, tDate, .SignedHeaders, .AccessKeyId, .URIEncodedPath,.Signature)
		
		///Create the Authorization
		set tSC = ##class(Demo.AWSIntegration.Utils).CreateAuthorization(AccessKeyId,tDate,Region,AWSService,SignedHeaders,Signature,.tAuthorization)
	   	
		set tHTTPRequest.Authorization = tAuthorization
		
    	set tURL = "/"_URIEncodedPath
    	set tSC = tHTTPRequest.Get(tURL)
		
   		set ErrorObject=""
   		If (tSC) && (tHTTPRequest.HttpResponse.StatusCode="200")  {
			Set OutputStream = ##class(%Stream.GlobalCharacter).%New()
   			If $isobject(tHTTPRequest.HttpResponse.Data){
				set vDoc=##class(EnsLib.EDI.XML.Document).ImportFromString(tHTTPRequest.HttpResponse.Data.Read(),.tSC)
				If tSC{
					set QueueURL=vDoc.GetValueAt("/GetQueueUrlResponse/GetQueueUrlResult/QueueUrl")
				}
				
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
		}	
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

}
