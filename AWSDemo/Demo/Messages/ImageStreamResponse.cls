Class Demo.Messages.ImageStreamResponse Extends Ens.Response
{

Property FileStream As %Stream.GlobalBinary;

Storage Default
{
<Data name="ImageStreamResponseDefaultData">
<Subscript>"ImageStreamResponse"</Subscript>
<Value name="1">
<Value>FileStream</Value>
</Value>
</Data>
<DefaultData>ImageStreamResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
