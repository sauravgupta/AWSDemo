Class Demo.AWSIntegration.S3.Put Extends %RegisteredObject
{

/***
AWS Signature Version 4
Put /test2.txt HTTP/1.1
Host: examplebucket.s3.amazonaws.com
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
set status=##class(Demo.AWSIntegration.S3.Put).PutFileOnS3(,,,,,,.stream,.ErrorObj)
**/
ClassMethod PutFileOnS3(SSLConfig As %String = "AWS", AWSService As %String = "s3", BucketName As %String = "irisawss3integration", Region As %String = "eu-west-1", FileName As %String = "C:\ISC\Data Platform\AWS\AWSIntegration\Test2.txt", CredentialName As %String = "AWSS3Access", Output OutputStream As %Stream.GlobalCharacter, Output ErrorObject As Demo.AWSIntegration.ErrorObject) As %Status
{
	set tSC = $$$OK
	try {
		//S3 Bucket URL based on Bucket Name
		set tServer = $ZCONVERT(BucketName_"."_AWSService_".amazonaws.com","L")
		set tHTTPRequest = ##class(%Net.HttpRequest).%New()        
    	set tHTTPRequest.Https=1
   		set tHTTPRequest.SSLConfiguration=SSLConfig                          
    	set tHTTPRequest.Server = tServer                                       
	
		///Get Date Formats required for Authorisation Header
		set tSC = ##class(Demo.AWSIntegration.Utils).GetAWSDateFormats(.tTimeStampISO8601Format,.tAWSDate,.tDate)
       
		///Set the AWS specific Headers. 
    	set tHTTPRequest.Date= tAWSDate
		do tHTTPRequest.SetHeader("x-amz-date", tTimeStampISO8601Format)
		do tHTTPRequest.SetHeader("x-amz-storage-class","STANDARD")
		
		///Get the content of the file
	   	Set tOutFile = ##class(%FileCharacterStream).%New()
    	Set tSC = tOutFile.LinkToFile(FileName)
    	Set tSC = tHTTPRequest.EntityBody.CopyFromAndSave(tOutFile)
    	
    	set tNormalizedFileName = $PIECE(FileName,"\",*)
    	Set tHTTPRequest.ContentType = "application/xml"
    	
    	/// x-amz-content-sha256 value is the hex of hash of the request body.  
		Set tHashedPayload = ""
    	set tSC=##class(Demo.AWSIntegration.Utils).CreateHashedPayload(tHTTPRequest.EntityBody,.tHashedPayload)
    	do tHTTPRequest.SetHeader("x-amz-content-sha256",tHashedPayload)
		/// Content Length must be set
		do tHTTPRequest.SetHeader("Content-Length",tHTTPRequest.EntityBody.Size)
			
		///Create the Signature 
		Set tSC = ##class(Demo.AWSIntegration.Utils).CreateSignature(CredentialName,"PUT", tHTTPRequest.ReturnHeaders(), "", "/"_tNormalizedFileName,Region,AWSService, tTimeStampISO8601Format, tDate, .SignedHeaders, .AccessKeyId, .URIEncodedPath,.Signature)
		set ^sau($i(^sau))=SignedHeaders
		set ^sau($i(^sau))=AccessKeyId
		set ^sau($i(^sau))=Signature
		///Create the Authorization
		set tSC = ##class(Demo.AWSIntegration.Utils).CreateAuthorization(AccessKeyId,tDate,Region,AWSService,SignedHeaders,Signature,.tAuthorization)
	   	
		set tHTTPRequest.Authorization = tAuthorization
		set tURL =  URIEncodedPath
		set ^sau($i(^sau))=tAuthorization
		set ^sau($i(^sau))=tURL
		
		set tSC = tHTTPRequest.Put(tURL)
		
		set ErrorObject=""
   		If (tSC) && (tHTTPRequest.HttpResponse.StatusCode="200")  {
			Set OutputStream = ##class(%Stream.GlobalCharacter).%New()
   			If $IsObject(tHTTPRequest.HttpResponse.Data){
				Set status = tHTTPRequest.HttpResponse.Data.Rewind()
				Set status = OutputStream.CopyFromAndSave(tHTTPRequest.HttpResponse.Data)
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
