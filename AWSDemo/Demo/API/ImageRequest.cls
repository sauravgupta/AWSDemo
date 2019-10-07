Class Demo.API.ImageRequest Extends Ens.Request
{

Property Date As %String;

Property Type As %String;

Property ServiceName As %String;

Storage Default
{
<Data name="ImageRequestDefaultData">
<Subscript>"ImageRequest"</Subscript>
<Value name="1">
<Value>Date</Value>
</Value>
<Value name="2">
<Value>Type</Value>
</Value>
<Value name="3">
<Value>ServiceName</Value>
</Value>
</Data>
<DefaultData>ImageRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
