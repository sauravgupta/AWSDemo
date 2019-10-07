Class Demo.Messages.RetrieveImageRequest Extends Ens.Request
{

Property URL As %String(MAXLEN = "");

Storage Default
{
<Data name="RetrieveImageRequestDefaultData">
<Subscript>"RetrieveImageRequest"</Subscript>
<Value name="1">
<Value>URL</Value>
</Value>
</Data>
<DefaultData>RetrieveImageRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
