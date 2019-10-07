Class Demo.Messages.AWSResponseMessage Extends Ens.Response
{

Property OutputStream As %Stream.GlobalCharacter;

Property HTTPResponseCode As %String;

Property ErrorObject As Demo.AWSIntegration.ErrorObject;

Storage Default
{
<Data name="AWSResponseMessageDefaultData">
<Subscript>"AWSResponseMessage"</Subscript>
<Value name="1">
<Value>OutputStream</Value>
</Value>
<Value name="2">
<Value>HTTPResponseCode</Value>
</Value>
<Value name="3">
<Value>ErrorObject</Value>
</Value>
</Data>
<DefaultData>AWSResponseMessageDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
