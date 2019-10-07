Class Demo.FTP.BMDailyRead.FileTransformDTL Extends Ens.DataTransformDTL [ DependsOn = Demo.FTP.BMDailyRead.Record ]
{

Parameter IGNOREMISSINGSOURCE = 1;

Parameter REPORTERRORS = 1;

Parameter TREATEMPTYREPEATINGFIELDASNULL = 0;

XData DTL [ XMLNamespace = "http://www.intersystems.com/dtl" ]
{
<transform sourceClass='Demo.FTP.BMDailyRead.Record' targetClass='Demo.FTP.BMDailyRead.Record' create='new' language='objectscript' >
<assign value='$PIECE(source.MemLastDroppedDate,"-",3)_"-"_$PIECE(source.MemLastDroppedDate,"-",2)_"-"_$PIECE(source.MemLastDroppedDate,"-",1)' property='target.MemLastDroppedDate' action='set' />
<assign value='$PIECE(source.MemDateJoined,"-",3)_"-"_$PIECE(source.MemDateJoined,"-",2)_"-"_$PIECE(source.MemDateJoined,"-",1)' property='target.MemDateJoined' action='set' />
<assign value='$PIECE(source.MemCurExpiryDate,"-",3)_"-"_$PIECE(source.MemCurExpiryDate,"-",2)_"-"_$PIECE(source.MemCurExpiryDate,"-",1)' property='target.MemCurExpiryDate' action='set' />
<assign value='source.MemCnSolCd101SolicitCode' property='target.MemCnSolCd101SolicitCode' action='set' />
<assign value='source.MemData01' property='target.MemData01' action='set' />
<assign value='source.MemData02' property='target.MemData02' action='set' />
<if condition='source.MemCnSolCd101SolicitCode="Requests only Membership admin emails"' >
<true>
<assign value='source.MemCnSolCd101SolicitCode' property='target.MemData03' action='set' />
</true>
<false>
<assign value='source.MemData03' property='target.MemData03' action='set' />
</false>
</if>
</transform>
}

}
