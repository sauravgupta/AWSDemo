Class Demo.Messages.AWSRequestMessage Extends Ens.Request
{

Property SSLConfig As %String;

Property Service As %String;

Property BucketName As %String;

Property Region As %String;

Property FileStream As %Stream.GlobalBinary;

Property FileName As %String;

Property CredentialName As %String;

Storage Default
{
<Data name="AWSRequestMessageDefaultData">
<Subscript>"AWSRequestMessage"</Subscript>
<Value name="1">
<Value>SSLConfig</Value>
</Value>
<Value name="2">
<Value>Service</Value>
</Value>
<Value name="3">
<Value>BucketName</Value>
</Value>
<Value name="4">
<Value>Region</Value>
</Value>
<Value name="5">
<Value>FileStream</Value>
</Value>
<Value name="6">
<Value>FileName</Value>
</Value>
<Value name="7">
<Value>CredentialName</Value>
</Value>
</Data>
<DefaultData>AWSRequestMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
