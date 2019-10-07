/// 
Class Demo.Analytics.Cube.TaskHistory Extends %DeepSee.CubeDefinition [ DependsOn = Demo.Analytics.TaskHistory ]
{

/// Cube definition from Architect.
XData Cube [ XMLNamespace = "http://www.intersystems.com/deepsee" ]
{
<cube xmlns="http://www.intersystems.com/deepsee" name="TaskHistory" displayName="Task History" disabled="false" abstract="false" sourceClass="Demo.Analytics.TaskHistory" countMeasureName="%COUNT" bucketSize="8" bitmapChunkInMemory="false" precompute="0" disableListingGroups="false" enableSqlRestrict="false">
  <dimension name="TaskName" disabled="false" hasAll="false" allCaption="All TaskName" allDisplayName="TaskName" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="TaskName" disabled="false" sourceProperty="TaskName" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="ServiceDate" disabled="false" hasAll="false" allCaption="All DateForWhichTaskRun" allDisplayName="DateForWhichTaskRun" sourceProperty="DateForWhichTaskRun" type="time" calendar="gregorian" iKnowType="entity" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Service Year" disabled="false" timeFunction="DayMonthYear" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
  <dimension name="Status" disabled="false" hasAll="false" allCaption="All Status" allDisplayName="Status" type="data" hidden="false" showHierarchies="default">
    <hierarchy name="H1" disabled="false" hidden="false">
      <level name="Status" disabled="false" sourceProperty="Status" list="false" useDisplayValue="true" useAsFilter="true" hidden="false">
      </level>
    </hierarchy>
  </dimension>
</cube>
}

Parameter DOMAIN;

}
