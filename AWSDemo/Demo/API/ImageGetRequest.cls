Class Demo.API.ImageGetRequest Extends Ens.Request
{

Property URL As %String(MAXLEN = 200);

Property CredentialName As %String;

Property SSLConfig As %String;

Storage Default
{
<Data name="ImageGetRequestDefaultData">
<Subscript>"ImageGetRequest"</Subscript>
<Value name="1">
<Value>URL</Value>
</Value>
<Value name="2">
<Value>CredentialName</Value>
</Value>
<Value name="3">
<Value>SSLConfig</Value>
</Value>
</Data>
<DefaultData>ImageGetRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
