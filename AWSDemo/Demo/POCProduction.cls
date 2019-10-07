Class Demo.POCProduction Extends Ens.Production
{

XData ProductionDefinition
{
<Production Name="Demo.POCProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>2</ActorPoolSize>
  <Item Name="AWSS3Storage" Category="" ClassName="Demo.BO.AWSS3" PoolSize="5" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
  </Item>
  <Item Name="NASAImageProcessing" Category="" ClassName="Demo.BP.DailyImageProcessing" PoolSize="5" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="WebAPIService" Category="" ClassName="Demo.API.WebAPIService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SQLOperation" Category="" ClassName="Demo.BO.SQL" PoolSize="5" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">SQLServer</Setting>
    <Setting Target="Adapter" Name="DSN">ImageStore</Setting>
  </Item>
  <Item Name="NASARESTOperation" Category="" ClassName="Demo.BO.GetImageDetails" PoolSize="5" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="HTTPServer">api.nasa.gov</Setting>
    <Setting Target="Adapter" Name="URL">/planetary/apod</Setting>
    <Setting Target="Adapter" Name="SSLConfig">NASATest</Setting>
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">0</Setting>
    <Setting Target="Host" Name="FailureTimeout">15</Setting>
    <Setting Target="Host" Name="ApiKey">zfAgijFyTwKCk5PYtmnObuEgF82ohGNV2wTj9ULz</Setting>
  </Item>
  <Item Name="WebAPIProcess" Category="" ClassName="Demo.BP.WebApIProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="FileTransformProcess" Category="" ClassName="Demo.FTP.BMDailyRead.TransformProcess" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="SFTPOperation" Category="" ClassName="EnsLib.RecordMap.Operation.FTPOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Filename">retoadestra-export.csv</Setting>
    <Setting Target="Host" Name="RecordMap">Demo.FTP.BMDailyRead</Setting>
    <Setting Target="Adapter" Name="Credentials">FTPOut</Setting>
    <Setting Target="Adapter" Name="FTPServer">127.0.0.1</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\BM\FTPOut</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Adapter" Name="Overwrite">1</Setting>
    <Setting Target="Adapter" Name="FTPPort">22</Setting>
  </Item>
  <Item Name="SFTPService" Category="" ClassName="EnsLib.RecordMap.Service.FTPService" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="RecordMap">Demo.FTP.BMDailyRead</Setting>
    <Setting Target="Adapter" Name="ArchivePath">C:\BM\FTPArchive</Setting>
    <Setting Target="Adapter" Name="Credentials">FTPIn</Setting>
    <Setting Target="Adapter" Name="FTPServer">127.0.0.1</Setting>
    <Setting Target="Adapter" Name="FilePath">C:\BM\FTPIn</Setting>
    <Setting Target="Adapter" Name="FileSpec">*.csv</Setting>
    <Setting Target="Adapter" Name="Protocol">SFTP</Setting>
    <Setting Target="Host" Name="TargetConfigNames">FileTransformProcess</Setting>
    <Setting Target="Adapter" Name="ServerListStyle">MSDOS</Setting>
    <Setting Target="Adapter" Name="FTPPort">22</Setting>
    <Setting Target="Host" Name="HeaderCount">1</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="NASATaskService" Category="" ClassName="Demo.BS.ImageDownloadService" PoolSize="0" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="TargetConfigName">NASAImageProcessing</Setting>
    <Setting Target="Adapter" Name="CallInterval">5</Setting>
  </Item>
  <Item Name="TaskStatusOperation" Category="" ClassName="Demo.BO.TaskStatusOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
</Production>
}

}
