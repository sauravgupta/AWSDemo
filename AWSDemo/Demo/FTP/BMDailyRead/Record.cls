/// RECORDMAP: Generated from RecordMap 'Demo.FTP.BMDailyRead'
/// on 2019-08-03 at 10:19:24.086 [2019-08-03 10:19:24.086 UTC]
/// by user krakshit
Class Demo.FTP.BMDailyRead.Record Extends (%Persistent, %XML.Adaptor, Ens.Request, EnsLib.RecordMap.Base) [ Inheritance = right ]
{

Parameter INCLUDETOPFIELDS = 1;

Property MemLastDroppedDate As %String [ SqlColumnNumber = 2 ];

Property MemCnSolCd101SolicitCode As %String [ SqlColumnNumber = 3 ];

Property MemDateJoined As %String [ SqlColumnNumber = 4 ];

Property MemCurExpiryDate As %String [ SqlColumnNumber = 5 ];

Property MemData01 As %String [ SqlColumnNumber = 6 ];

Property MemData02 As %String [ SqlColumnNumber = 7 ];

Property MemData03 As %String [ SqlColumnNumber = 8 ];

Parameter RECORDMAPGENERATED = 1;

Storage Default
{
<Data name="RecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MemLastDroppedDate</Value>
</Value>
<Value name="3">
<Value>%Source</Value>
</Value>
<Value name="4">
<Value>MemDateJoined</Value>
</Value>
<Value name="5">
<Value>MemCurExpiryDate</Value>
</Value>
<Value name="6">
<Value>MemData01</Value>
</Value>
<Value name="7">
<Value>MemData02</Value>
</Value>
<Value name="8">
<Value>MemData03</Value>
</Value>
<Value name="9">
<Value>MemCnSolCd101SolicitCode</Value>
</Value>
</Data>
<DataLocation>^Demo.FTP.BMDailyRead.RecordD</DataLocation>
<DefaultData>RecordDefaultData</DefaultData>
<ExtentSize>2000000</ExtentSize>
<IdLocation>^Demo.FTP.BMDailyRead.RecordD</IdLocation>
<IndexLocation>^Demo.FTP.BMDailyRead.RecordI</IndexLocation>
<StreamLocation>^Demo.FTP.BMDailyRead.RecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
