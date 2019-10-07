/// 
Class Demo.FTP.BMDailyRead.TransformProcess Extends Ens.BusinessProcessBPL [ ClassType = persistent ]
{

/// BPL Definition
XData BPL [ XMLNamespace = "http://www.intersystems.com/bpl" ]
{
<process language='objectscript' request='Demo.FTP.BMDailyRead.Record' response='Ens.Response' height='2000' width='2000' >
<context>
<property name='TransformMessage' type='Demo.FTP.BMDailyRead.Record' instantiate='0' />
</context>
<sequence xend='200' yend='450' >
<transform name='Map to export format' class='Demo.FTP.BMDailyRead.FileTransformDTL' source='request' target='context.TransformMessage' xpos='200' ypos='250' />
<call name='Call write operation' target='SFTPOperation' async='1' xpos='200' ypos='350' >
<request type='Demo.FTP.BMDailyRead.Record' >
<assign property="callrequest" value="context.TransformMessage" action="set" />
</request>
<response type='Ens.Response' >
<assign property="response" value="callresponse" action="set" />
</response>
</call>
</sequence>
</process>
}

Storage Default
{
<Type>%Storage.Persistent</Type>
}

}
