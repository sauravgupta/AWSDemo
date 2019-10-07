Class Demo.AWSIntegration.SQS.Send
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
set AttributesList=##class(%ListOfObjects).%New()
set Attribute=##class(Demo.AWSIntegration.SQS.MessageAttributes).%New()
set Attribute.Name="TestAttributeName"
Set Attribute.Type="String"
set Attribute.Value="Test Attribute Value"
do AttributesList.Insert(Attribute)
set status=##class(Demo.AWSIntegration.SQS.Send).SendMessage(,,,,AttributesList,,,.MessageId,.ErrorObj)
**/
ClassMethod SendMessage(SSLConfig As %String = "AWS", AWSService As %String = "sqs", Region As %String = "eu-west-2", QueueURL As %String = "https://sqs.eu-west-2.amazonaws.com/091533082706/TestDemo.AWSIntegrationQueue", MessageAttributes As %ListOfObjects, MessageBody As %String = "This is a Test Message", CredentialName As %String = "AWSSQSAccess", Output MessageId As %String, Output ErrorObject As Demo.AWSIntegration.ErrorObject) As %Status
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
		/// Get the Message Attributes
		set tAttributesString=""
		If $IsObject(MessageAttributes){
			for i=1:1:MessageAttributes.Count() {
				set tAttributesString="&MessageAttribute.1.Name="_MessageAttributes.GetAt(i).Name_"&MessageAttribute.1.Value.StringValue="_MessageAttributes.GetAt(i).Value_"&MessageAttribute.1.Value.DataType="_MessageAttributes.GetAt(i).Type
			}
		}	
		
		Set tQueryParams = "Action=SendMessage&MessageBody=" _ MessageBody_tAttributesString
		
		///Create the Signature 
		Set tSC = ##class(Demo.AWSIntegration.Utils).CreateSignature(CredentialName,"GET", tHTTPRequest.ReturnHeaders(), tQueryParams, $PIECE(QueueURL,"amazonaws.com",2), Region,AWSService, tTimeStampISO8601Format, tDate, .SignedHeaders, .AccessKeyId, .URIEncodedPath,.Signature)
		
		///Create the Authorization
		set tSC = ##class(Demo.AWSIntegration.Utils).CreateAuthorization(AccessKeyId,tDate,Region,AWSService,SignedHeaders,Signature,.tAuthorization)
	   	
		set tHTTPRequest.Authorization = tAuthorization
		
    	set tURL = URIEncodedPath
    	set tSC = tHTTPRequest.Get(tURL)
		do tHTTPRequest.HttpResponse.OutputToDevice()
   		set ErrorObject=""
   		If (tSC) && (tHTTPRequest.HttpResponse.StatusCode="200")  {
			Set OutputStream = ##class(%Stream.GlobalCharacter).%New()
   			If $isobject(tHTTPRequest.HttpResponse.Data){
				set vDoc=##class(EnsLib.EDI.XML.Document).ImportFromString(tHTTPRequest.HttpResponse.Data.Read(),.tSC)
				If tSC{
					set MessageId=vDoc.GetValueAt("/SendMessageResponse/SendMessageResult/MessageId")
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
