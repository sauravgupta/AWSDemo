Class Demo.Messages.SQLImageRequest Extends Ens.Request
{

Property Copyright As %String(MAXLEN = 200);

Property Date As %String;

Property Explanation As %String(MAXLEN = "");

Property HDURL As %String(MAXLEN = 200);

Property MediaType As %String;

Property ServiceVersion As %String;

Property Title As %String(MAXLEN = 200);

Property OriginalURL As %String(MAXLEN = 200);

Property BucketName As %String(MAXLEN = 200);

Property Service As %String;

Property Region As %String;

Property Extension As %String;

Property ServiceName As %String;

Storage Default
{
<Data name="SQLImageRequestDefaultData">
<Subscript>"SQLImageRequest"</Subscript>
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
<Value>OriginalURL</Value>
</Value>
<Value name="9">
<Value>BucketName</Value>
</Value>
<Value name="10">
<Value>Service</Value>
</Value>
<Value name="11">
<Value>Region</Value>
</Value>
<Value name="12">
<Value>Extension</Value>
</Value>
<Value name="13">
<Value>ServiceName</Value>
</Value>
</Data>
<DefaultData>SQLImageRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
