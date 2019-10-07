Class Demo.Data.ImageRepository Extends %Persistent
{

Property ImageDate As %String;

Property Copyright As %String(MAXLEN = 200);

Property Explanation As %String(MAXLEN = "");

Property HDURL As %String(MAXLEN = 200);

Property MediaType As %String;

Property ServiceVersion As %String;

Property Title As %String(MAXLEN = 200);

Property OriginalURL As %String(MAXLEN = 200);

Property URL As %String(MAXLEN = 200);

Storage Default
{
<Data name="ImageRepositoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ImageDate</Value>
</Value>
<Value name="3">
<Value>Copyright</Value>
</Value>
<Value name="4">
<Value>Explanation</Value>
</Value>
<Value name="5">
<Value>HDURL</Value>
</Value>
<Value name="6">
<Value>MediaType</Value>
</Value>
<Value name="7">
<Value>ServiceVersion</Value>
</Value>
<Value name="8">
<Value>Title</Value>
</Value>
<Value name="9">
<Value>OriginalURL</Value>
</Value>
<Value name="10">
<Value>URL</Value>
</Value>
</Data>
<DataLocation>^Demo.Data.ImageRepositoryD</DataLocation>
<DefaultData>ImageRepositoryDefaultData</DefaultData>
<IdLocation>^Demo.Data.ImageRepositoryD</IdLocation>
<IndexLocation>^Demo.Data.ImageRepositoryI</IndexLocation>
<StreamLocation>^Demo.Data.ImageRepositoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
