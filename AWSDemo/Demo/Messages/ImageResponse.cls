Class Demo.Messages.ImageResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property Copyright As %String(MAXLEN = 200);

Property Date As %String;

Property Explanation As %String(MAXLEN = "");

Property HDURL As %String(MAXLEN = 200);

Property MediaType As %String;

Property ServiceVersion As %String;

Property Title As %String(MAXLEN = 200);

Property URL As %String(MAXLEN = 200);

Storage Default
{
<Data name="ImageResponseDefaultData">
<Subscript>"ImageResponse"</Subscript>
<Value name="1">
<Value>Copyright</Value>
</Value>
<Value name="2">
<Value>Date</Value>
</Value>
<Value name="3">
<Value>Explanation</Value>
</Value>
<Value name="4">
<Value>HDURL</Value>
</Value>
<Value name="5">
<Value>MediaType</Value>
</Value>
<Value name="6">
<Value>ServiceVersion</Value>
</Value>
<Value name="7">
<Value>Title</Value>
</Value>
<Value name="8">
<Value>URL</Value>
</Value>
</Data>
<DefaultData>ImageResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
