Class Demo.AWSIntegration.Utils Extends %RegisteredObject
{

/** 
HashedPayload is the hexadecimal value of the SHA256 hash of the request payload.
**/
ClassMethod CreateHashedPayload(HTTPRequestBody As %GlobalCharacterStream, Output HashedPayload As %String(MAXLEN="")) As %Status
{
	set tSC = $$$OK
	try {
		Set tBodyHash = ""
		set HashedPayload = ""
		set tBodyHash = $SYSTEM.Encryption.SHAHashStream(256,HTTPRequestBody,.tSC)
		For i = 1:1:$LENGTH(tBodyHash){
			Set tHexValue = $ZHEX($ASCII($EXTRACT(tBodyHash,i)))
			If $Length(tHexValue)=1 {
				Set tHexValue = "0" _ tHexValue
			}
			Set HashedPayload = HashedPayload _ $ZCONVERT(tHexValue,"L")
		}
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/**
To calculate a signature, you first need a string to sign. You then calculate a HMAC-SHA256 hash of the
string to sign by using a signing key. 
When Amazon Service receives an authenticated request, it computes the signature and then compares it
with the signature that you provided in the request. For that reason, you must compute the signature by
using the same method that is used by Amazon Service. The process of putting a request in an agreed-upon
form for signing is called canonicalization.

Task 1: Create a Canonical Request

GET
/test.txt
host:{AmazonService}.amazonaws.com
range:bytes=0-9
x-amz-contentsha256:e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
x-amz-date:20130524T000000Z
host;range;x-amz-content-sha256;x-amz-date
e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855 

Task 2: Create a String to Sign

AWS4-HMAC-SHA256
20130524T000000Z
20130524/us-east-1/{AmazonService}/aws4_request
7344ae5b7ee6c3e7e6b0fe0640412a37625d1fbfff95c48bbb2dc43964946972

Task 3: Calculate Signature

SigningKey = HMAC-SHA256(HMAC-SHA256(HMAC-SHA256(HMAC-SHA256("AWS4" +
 "<YourSecretAccessKey>","20130524"),"us-east-1"),{AmazonService}),"aws4_request")

Signature HEX(HMAC-SHA256(SigningKey, StringToSign))
f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41 
**/
ClassMethod CreateSignature(CredentialName As %String, Verb As %String, Headers As %String, QueryParams As %String, FileName As %String, Region As %String, AWSService As %String, timeStampISO8601Format As %String, Date As %String, Output SignedHeaders As %String, Output AccessKeyId As %String = "", Output URIEncodedPath As %String = "", Output Signature As %String(MAXLEN="")) As %Status
{
	set tSC = $$$OK
	try {
		Set Signature = "", tCanonicalQueryString = ""
		
		//Get the Access key Id and Secret Access Key
		set tSC= ..GetCredentials(CredentialName,.AccessKeyId,.SecretAccessKey)
		
		///Create Signed and Canonical Headers
		Set tSC = ..CreateSignedAndCanonicalHeaders(Headers, FileName, .SignedHeaders, .HashedPayload,.CanonicalHeaders)
		///Create Canonical Query String
		Set tSC = ..CreateCanonicalQueryString(QueryParams,.tCanonicalQueryString)
		
		If $LENGTH(tCanonicalQueryString) > 0 {
			Set URIEncodedPath = ..UriEncode(FileName,0) _ "?" _ tCanonicalQueryString	
		}
		Else{
			Set URIEncodedPath = ..UriEncode(FileName,0)
		}
	
		/// Create the Canonical Request
		Set tSC = ..CreateCanonicalRequest(Verb, CanonicalHeaders, tCanonicalQueryString, FileName, SignedHeaders, HashedPayload,.CanonicalRequest)
		/// Create the String to Sign
		Set tSC = ..CreateStringToSign(CanonicalRequest,timeStampISO8601Format, Date,Region,AWSService,.StringToSign)
		/// Create the Signing key
		
		Set tSC = ..CreateSigningKey(StringToSign, Date, Region,AWSService,SecretAccessKey,.SigningKey)
		/// Signature HEX(HMAC-SHA256(SigningKey, StringToSign))
		Set tSignaturePreHex = $SYSTEM.Encryption.HMACSHA(256,StringToSign,SigningKey)
		For i = 1:1:$LENGTH(tSignaturePreHex){
			Set tHexValue = $ZHEX($ASCII($EXTRACT(tSignaturePreHex,i)))
			If $Length(tHexValue)=1{
				Set tHexValue = "0" _ tHexValue
			}
			Set Signature = Signature _ $ZCONVERT(tHexValue,"L")
		}
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/*** Creating a Canonical Request
<HTTPMethod>\n
<CanonicalURI>\n
<CanonicalQueryString>\n
<CanonicalHeaders>\n
<SignedHeaders>\n
<HashedPayload>
***/
ClassMethod CreateCanonicalRequest(HTTPVerb As %String, CanonicalHeaders As %String, Query As %String = "", FileName As %String, SignedHeaders As %String, HashedPayload As %String(MAXLEN=""), Output CanonicalRequest As %String(MAXLEN="")) As %Status
{
	set tSC = $$$OK
	try {
		#define EOL $Char(10)   
  		Set CanonicalRequest = ""
		//HTTP Method
		Set CanonicalRequest = HTTPVerb _ $$$EOL
		//CanonicalURI
		Set CanonicalRequest = CanonicalRequest _ ..UriEncode(FileName,0) _ $$$EOL
		//CanonicalQueryString
		Set CanonicalRequest = CanonicalRequest _ Query _ $$$EOL
		//CanonicalHeaders
		Set CanonicalRequest = CanonicalRequest _ $REPLACE(CanonicalHeaders,"\n",$$$EOL) _ $$$EOL
		//Signed headers
		Set CanonicalRequest = CanonicalRequest _ SignedHeaders _ $$$EOL
		//Hashed payload
		Set CanonicalRequest = CanonicalRequest _ HashedPayload
		
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/** 
"AWS4-HMAC-SHA256" + "\n" +
timeStampISO8601Format + "\n" +
<Scope> + "\n" +
Hex(SHA256Hash(<CanonicalRequest>))
Scope binds the resulting Signature to a specific date, AWS region and Service
date.Format(<YYYYMMDD>) + "/" + <region> + "/" + <service> + "/aws4_request"
**/
ClassMethod CreateStringToSign(CanonicalRequest As %String, timeStampISO8601Format As %String, Date As %String, Region As %String, AWSService As %String, Output StringToSign As %String) As %Status
{

    set tSC = $$$OK
	try {
		#define EOL $Char(10)
    	Set StringToSign = "", tHashedCanonicalRequestHex="", tHashedCanonicalRequest=""
		Set tHashedCanonicalRequest = $SYSTEM.Encryption.SHAHash(256,CanonicalRequest)
		Set StringToSign = "AWS4-HMAC-SHA256" _ $$$EOL
		Set StringToSign = StringToSign _ timeStampISO8601Format _ $$$EOL
		Set StringToSign = StringToSign _ Date _"/"_Region_"/" _ AWSService_ "/aws4_request" _ $$$EOL
		For i = 1:1:$LENGTH(tHashedCanonicalRequest){
			Set tHexValue = $ZHEX($ASCII($EXTRACT(tHashedCanonicalRequest,i)))
			If $Length(tHexValue)=1{
				Set tHexValue = "0" _ tHexValue
			}
			Set StringToSign = StringToSign _ $ZCONVERT(tHexValue,"L")
			Set tHashedCanonicalRequestHex=tHashedCanonicalRequestHex_$ZCONVERT(tHexValue,"L")
		}
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/**
DateKey = HMAC-SHA256("AWS4"+"<SecretAccessKey>", "<YYYYMMDD>")
DateRegionKey = HMAC-SHA256(<DateKey>, "<aws-region>")
DateRegionServiceKey = HMAC-SHA256(<DateRegionKey>, "<aws-service>")
SigningKey = HMAC-SHA256(<DateRegionServiceKey>, "aws4_request")
**/
ClassMethod CreateSigningKey(StringToSign As %String(MAXLEN=""), Date As %String, Region As %String, AWSService As %String, SecretAccessKey As %String, Output SigningKey As %String(MAXLEN="")) As %Status
{
	set tSC = $$$OK
	try {
		Set SigningKey = "", tDateKey="", tDateRegionkey="", tDateRegionServiceKey=""
		Set tDateKey = $SYSTEM.Encryption.HMACSHA(256,Date,"AWS4" _ SecretAccessKey)
		Set tDateRegionKey = $SYSTEM.Encryption.HMACSHA(256,Region,tDateKey)
		Set tDateRegionServiceKey = $SYSTEM.Encryption.HMACSHA(256,AWSService,tDateRegionKey)
		Set SigningKey = $SYSTEM.Encryption.HMACSHA(256,"aws4_request",tDateRegionServiceKey)
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/**
Sample Authorization
AWS4-HMAC-SHA256 Credential=AKIAIOSFODNN7EXAMPLE/20130524/us-east-1/
{AmazonService}/aws4_request,SignedHeaders=host;range;x-amz-content-sha256;x-amzdate,Signature=f0e8bdb87c964420e857bd35b5d6ed310bd44f0170aba48dd91039c6036bdb41
**/
ClassMethod CreateAuthorization(AccessKeyId As %String, Date As %String, Region As %String, AWSService As %String, SignedHeaders As %String, Signature As %String, Output Authorization As %String(MAXLEN="")) As %Status
{
	set tSC = $$$OK
	try {
		Set Authorization = ""
		Set Authorization = "AWS4-HMAC-SHA256 Credential=" _ AccessKeyId _ "/"_ Date _"/"_ Region _ "/"_AWSService_"/aws4_request,SignedHeaders=" _ SignedHeaders _ ",Signature=" _ Signature
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/**
Lowercase(<HeaderName1>)+":"+Trim(<value>)+"\n"
Lowercase(<HeaderName2>)+":"+Trim(<value>)+"\n"
...
Lowercase(<HeaderNameN>)+":"+Trim(<value>)+"\n"
**/
ClassMethod CreateSignedAndCanonicalHeaders(Headers As %String, Key As %String, Output SignedHeaders As %String, Output HashedPayload As %String, Output CanonicalHeaders As %String) As %Status
{
    set tSC = $$$OK
	try {
		#define EOL $Char(13,10)
    	Set CanonicalHeaders = "", SignedHeaders = ""
		set oHttpHeaderArray=##class(%ArrayOfDataTypes).%New()
		For i = 1:1:$LENGTH(Headers,$$$EOL)-1{
			do oHttpHeaderArray.SetAt($PIECE($PIECE(Headers,$$$EOL,i),":",2,*),$PIECE($PIECE(Headers,$$$EOL,i),":",1))
		}
		Set tHttpHeader = "", tHttpPrevHeader = ""
		for {
			set tHttpHeaderValue= oHttpHeaderArray.GetNext(.tHttpHeader)
			quit:(tHttpHeader="")
			If tHttpPrevHeader '= tHttpHeader{
				If tHttpPrevHeader = ""{
					Set CanonicalHeaders = CanonicalHeaders _ $ZCONVERT(tHttpHeader,"L") _ ":" _ $ZSTRIP(tHttpHeaderValue,"<>W")
				}
				Else{
					Set CanonicalHeaders = CanonicalHeaders _ "\n" _ $ZCONVERT(tHttpHeader,"L") _ ":" _ $ZSTRIP(tHttpHeaderValue,"<>W")
				}
			}
			Set SignedHeaders = SignedHeaders _ $ZCONVERT(tHttpHeader,"L") _ ";"
			Set tHttpPrevHeader = tHttpHeader
	
			If $ZCONVERT(tHttpHeader,"L") = "x-amz-content-sha256"{
				Set HashedPayload = $ZCONVERT($ZSTRIP(tHttpHeaderValue,"<>W"),"L")
			}
		}
		Set CanonicalHeaders = CanonicalHeaders _ "\n"
		Set SignedHeaders = $EXTRACT(SignedHeaders,1,$LENGTH(SignedHeaders) - 1)
	}	
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/**
UriEncode(<QueryParameter1>) + "=" + " UriEncode(<value>) + "&" +
UriEncode(<QueryParameter2>) + "=" + " UriEncode(<value>) + "&" +
...
UriEncode(<QueryParameterN>) + "=" + " UriEncode(<value>)
**/
ClassMethod CreateCanonicalQueryString(QueryParams As %String, Output CanonicalQueryString As %String(MAXLEN="")) As %Status
{
	set tSC = $$$OK
	try {
		Set CanonicalQueryString = ""
		set oHttpParamsArray=##class(%ArrayOfDataTypes).%New()
		If QueryParams '= ""
		{
			for i = 1:1:$LENGTH(QueryParams,"&"){
				Set tParamName = $PIECE($PIECE(QueryParams,"&",i),"=",1)
				Set tParamValue = $PIECE($PIECE(QueryParams,"&",i),"=",2,*)
				do oHttpParamsArray.SetAt(tParamValue,tParamName)
			}
			set key=""
			for {
				set value= oHttpParamsArray.GetNext(.key)
				quit:(key="")
				Set CanonicalQueryString = CanonicalQueryString _ "&" _ ..UriEncode(key) _ "=" _ ..UriEncode(value)
			}
			
			Set CanonicalQueryString = $EXTRACT(CanonicalQueryString,2,*)
		}
	}	
	catch ex {
		set tSC = ex.AsStatus()
	}
	Quit tSC
}

/**
public static String UriEncode(CharSequence input, boolean
 encodeSlash) {
 StringBuilder result = new StringBuilder();
 for (int i = 0; i < input.length(); i++) {
 char ch = input.charAt(i);
 if ((ch >= 'A' && ch <= 'Z') || (ch >= 'a'
 && ch <= 'z') || (ch >= '0' && ch <= '9') || ch == '_' ||
 ch == '-' || ch == '~' || ch == '.') {
 result.append(ch);
 } else if (ch == '/') {
 result.append(encodeSlash ? "%2F" : ch);
 } else {
 result.append(toHexUTF8(ch));
 }
 }
 return result.toString();
 }
**/
/// Based on URI Encode function implementation in Java from AWS {AmazonService} API Docs
ClassMethod UriEncode(CharSequence As %String, encodeSlash As %Boolean = 1) As %String
{
	Set result = ""
	For i = 1:1:$LENGTH(CharSequence)
	{
		Set char = $extract(CharSequence,i)
		if (char="A") || (char="B") || (char="C") || (char="D") || (char="E") || (char="F") || (char="G") || (char="H") || (char="I") || (char="J") || (char="K") || (char="L") || (char="M") || (char="N") || (char="O") || (char="P") || (char="Q") || (char="R") || (char="S") || (char="T") || (char="U") || (char="V") || (char="W") || (char="X") || (char="Y") || (char="Z") || (char="a") || (char="b") || (char="c") || (char="d") || (char="e") || (char="f") || (char="g") || (char="h") || (char="i") || (char="j") || (char="k") || (char="l") || (char="m") || (char="n") || (char="o") || (char="p") || (char="q") || (char="r") || (char="s") || (char="t") || (char="u") || (char="v") || (char="w") || (char="x") || (char="y") || (char="z") || (char="0") || (char="1") || (char="2") || (char="3") || (char="4") || (char="5") || (char="6") || (char="7") || (char="8") || (char="9") || (char="_") || (char="-") || (char="~") || (char="."){
        	Set result = result _ char
        } 
        elseif (char = "/") {
	        If encodeSlash{
                Set result = result _ "%2F"
	        }
	        else{
		        Set result = result _ char
	        }
        } 
        else{
	        Set result = result _ "%" _ $ZHEX($ASCII(char))
        }
	}
	set result= $ZCONVERT(result,"O","UTF8")
	Quit result
}

/** 
AWS {AmazonService} AccessKeyId and SecretAccessKey can be stored in IRIS Interoperability Credentials
**/
ClassMethod GetCredentials(CredentialName As %String, Output AccessKeyId As %String, SecretAccessKey As %String(MAXLEN=250)) As %Status
{
	set tSC = $$$OK
	try {	
		///Get the Access Key anf Secret Access Key based on Credentials Configuration
		set AccessKeyId="", SecretAccessKey=""
    	set AccessKeyId = ##class(Ens.Config.Credentials).GetValue(CredentialName,"Username")
    	set SecretAccessKey = ##class(Ens.Config.Credentials).GetValue(CredentialName,"Password")
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	return tSC
}

ClassMethod GetAWSDateFormats(Output tTimeStampISO8601Format As %String, tAWSDate As %String, tDate As %String) As %Status
{
	set tSC = $$$OK
	try {	
		Set tTimeStampISO8601Format = $ZDATE($ZTIMESTAMP,8) _ "T" _ $REPLACE($ZTIME($PIECE($ZTIMESTAMP,",",2),9),":","")  _ "Z"
		Set tAWSDate = $ZDATE($ZTIMESTAMP,11) _ ", " _ $ZDATE($ZTIMESTAMP,2) _ " " _ $ZTIME($PIECE($ZTIMESTAMP,",",2),9) _ " GMT"
		Set tDate = $ZDATE($ZTIMESTAMP,8)
	}
	catch ex {
		set tSC = ex.AsStatus()
	}
	return tSC
}

}
