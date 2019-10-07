Class Demo.Messages.ImageStatusRequest Extends Ens.Request
{

Property Date As %String;

Property ServiceName As %String;

Storage Default
{
<Data name="ImageStatusRequestDefaultData">
<Subscript>"ImageStatusRequest"</Subscript>
<Value name="1">
<Value>Date</Value>
</Value>
<Value name="2">
<Value>ServiceName</Value>
</Value>
</Data>
<DefaultData>ImageStatusRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
