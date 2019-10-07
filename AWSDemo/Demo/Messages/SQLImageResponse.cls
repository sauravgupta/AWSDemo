Class Demo.Messages.SQLImageResponse Extends (Ens.Response, %JSON.Adaptor)
{

Property Date As %String;

Property Status As %String(VALUELIST = ",Pending,Completed,Error") [ InitialExpression = "Pending" ];

Property Description As %String(MAXLEN = 200);

Property ErrorDescription As %String(MAXLEN = "");

Storage Default
{
<Data name="SQLImageResponseDefaultData">
<Subscript>"SQLImageResponse"</Subscript>
<Value name="1">
<Value>Date</Value>
</Value>
<Value name="2">
<Value>Status</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>ErrorDescription</Value>
</Value>
</Data>
<DefaultData>SQLImageResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
