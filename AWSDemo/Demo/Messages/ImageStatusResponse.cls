Class Demo.Messages.ImageStatusResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property Date As %String;

Property ServiceName As %String;

Property Status As %String;

Property Description As %String(MAXLEN = "");

Storage Default
{
<Data name="ImageStatusResponseDefaultData">
<Subscript>"ImageStatusResponse"</Subscript>
<Value name="1">
<Value>Date</Value>
</Value>
<Value name="2">
<Value>ServiceName</Value>
</Value>
<Value name="3">
<Value>Status</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
</Data>
<DefaultData>ImageStatusResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
