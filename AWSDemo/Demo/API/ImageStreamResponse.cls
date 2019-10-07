Class Demo.API.ImageStreamResponse Extends Ens.Response
{

Property ImageStream As %Stream.GlobalBinary;

Property ErroObject As Demo.AWSIntegration.ErrorObject;

Storage Default
{
<Data name="ImageStreamResponseDefaultData">
<Subscript>"ImageStreamResponse"</Subscript>
<Value name="1">
<Value>ImageStream</Value>
</Value>
<Value name="2">
<Value>ErroObject</Value>
</Value>
</Data>
<DefaultData>ImageStreamResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
