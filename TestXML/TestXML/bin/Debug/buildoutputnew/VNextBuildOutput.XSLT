<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">

  <xsl:output method="html" indent="yes"/>
  <xsl:key name="AssinedTo" match="workitem" use="@AssinedTo"/>
  <xsl:key name="RWAssginedTo" match="RemainingWorkItem" use="@RWAssginedTo"/>
  <xsl:key name="OEAssinedTo" match="OrgEstWorkItem" use="@OEAssinedTo"/>
  <xsl:key name="ChangedDate" match="workitem" use="@ChangedDate"/>
  <xsl:key name="ModifiedDate" match="RemainingWorkItem" use="@ModifiedDate"/>
  <xsl:key name="OEChangedDate" match="OrgEstWorkItem" use="@OEChangedDate"/>
  <xsl:key name="Context" match="Reason" use="@Context"/>
  <xsl:key name="ProcedureNameValue" match="Result" use="ProcedureNameValue"/>
  <xsl:template match="IGDBuild" >
    <html>
      <head>
        <style type="text/css">
          body {
          font-family:Segoe UI Light;
          /*font-size:80%;*/
          }
          .toolsuggest
          {
          font-family:Segoe UI Light;
          background-color:#FF9900;<!--rgb(250, 104, 0); red orange-->
          color:black;


          }
          .highlight
          {
          font-weight:bold
          background-color:#FFC425;<!--rgb(250, 104, 0); red orange-->
          color:black;

          }
          .roundbackgroundProject{
          vertical-align:top;
          display: inline-block;
          color: black;
          background-color:#F7BE81; <!--#7200ad;--> <!--#78ba00;; <background:#dddddd; grey-->
          text-align: center;
          padding: 2px;
          text-decoration: none;
          margin:2px;
          <!--border: 0px solid voilet;-->
          <!--white-space: nowrap;-->
          border-radius:5px;

          }
          .roundborderFile{
          vertical-align:middle;
          display: inline-block;
          color: black;
          background-color:#F7BE81; <!--#FF9900-->
          text-align: center;
          padding: 2px;
          text-decoration: none;
          margin:2px;
          <!--border: 2px solid;-->
          <!--white-space: nowrap;-->
          border-radius: 5px;
          }

          table {
          border-collapse: collapse;
          border-style: hidden;
          }

          table td, table th {
          border: 1px solid #f0f0f0;
          vertical-align:top;
          aling:left
          }

          .noborder {
          border:none;
          }

          .subtext{
          font-size:80%;
          }

          .minutetext{
          font-size:75%;
          }

          .header
          {
          font-family:Segoe UI Light;
          color:#007ACC;
          font-size:120%;
          }
          .subheading
          {
          font-family:Segoe UI Light;
          background-color:#007ACC;
          color:white;
          font-size:60%;
          }
          .colored
          {
          color:#007ACC;
          }

          .bgcolored
          {
          font-family:Segoe UI Light;
          background-color:#007ACC;
          color:white;

          }

          .bgcoloredDiagnostics
          {
          text-align:left
          font-family:Segoe UI Light;
          border-color:#D11141;color:#ffffff;background:#D11141;
          }

          .bgcoloredsmall
          {
          font-family:Segoe UI Light;
          font-size:13px;
          font-weight:bold;
          background-color:#007ACC;
          color:white;

          }

          .bgcoloredGreen
          {
          font-family:Segoe UI Light;
          background-color:#78ba00;
          color:white;
          margin:1px
          }
          .bgcoloredViolet
          {
          font-family:Segoe UI Light;
          background-color:#7200ad;
          color:white;
          margin:1px
          }


          .smallheader
          {
          font-family:Segoe UI Light;
          color:#007ACC;
          font-size:100%;
          }

          .mainTile
          {display:inline-block; width: 200px;height: 200px; background-color: #007ACC}


          .subTile { border:none;width: 100px;height: 100px;background-color: #007ACC}

          .tileNumberStyle{  font-family:Segoe UI Light;font-size:24px;color:white}

          .tileTextStyle{ font-family:Segoe UI Light;font-size:14px;color:white}

          .altSubtile { border:none;width: 100px;height: 100px; background-color: #0099FF}

          .tileTitle {font-family:Segoe UI Light;font-size:14px;font-weight:bold;color:white}

          /* Highlight */
          .ui-state-highlight{border-color:#E5F2FF;color:#525252;background:#E5F2FF;font-family:Segoe UI Light;}
          /*.ui-state-highlight .ui-icon{background-image:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAGFSURBVDhPjVM9SEJRFP6e7wUt+TNV4hRUgzqKk0saCOEmgVuTQ0vgIiKmBaHo2BISQeCm4lKLqOTWUKKCiRYuUYNDouBgmqf3XvkT5s+5nOXe+93zne98lyE+sGBknjNw37qRf8tDs6YBBPAiEXmMEOtgCUcghUtB2ZcsLQROVpPEOTmCAyRzySj3mhPrzQXXPmqkOFUQnBAfSFVTQ6KSWe32+j3YojY0PhsACwT2AjBuGkeQWf1677wEHwjHIPO1mfr8Gg9mmtqFegG6Kx26vS7kS3KUDktQrij/EB3S7va7wwO+Auw3dgz2grvBCaB4WaASvg+T6kxF5XpZZBV+CP/QPQHpL/UTdAfU2cpGxedP+9HqtJB4SkC6LIUn7UG70+ZNAMT341BJVf/qyhTfi2Q4N6DZaYqKQmhESAawaqyI2qJTByLRrmsRO4iBYzjgi7/3m0yfgW/HN9O4omCmLRNClhAvwAhs2bZAvaqe7frxuZkvzMQ5ODGTleRcy0+d8yIf7Rsw7Ys8NNs3jAAAAABJRU5ErkJggg==);}
          url(images/ui-icons_525252_0.png);*/

          /* Notavailable */
          .ui-state-notavailable{border-color:#FFC425 ;color:red;background:#FFC425 ;font-family:Segoe UI Light;}
          /* .ui-state-notavailable .ui-icon{background-image:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAGFSURBVDhPjVM9SEJRFP6e7wUt+TNV4hRUgzqKk0saCOEmgVuTQ0vgIiKmBaHo2BISQeCm4lKLqOTWUKKCiRYuUYNDouBgmqf3XvkT5s+5nOXe+93zne98lyE+sGBknjNw37qRf8tDs6YBBPAiEXmMEOtgCUcghUtB2ZcsLQROVpPEOTmCAyRzySj3mhPrzQXXPmqkOFUQnBAfSFVTQ6KSWe32+j3YojY0PhsACwT2AjBuGkeQWf1677wEHwjHIPO1mfr8Gg9mmtqFegG6Kx26vS7kS3KUDktQrij/EB3S7va7wwO+Auw3dgz2grvBCaB4WaASvg+T6kxF5XpZZBV+CP/QPQHpL/UTdAfU2cpGxedP+9HqtJB4SkC6LIUn7UG70+ZNAMT341BJVf/qyhTfi2Q4N6DZaYqKQmhESAawaqyI2qJTByLRrmsRO4iBYzjgi7/3m0yfgW/HN9O4omCmLRNClhAvwAhs2bZAvaqe7frxuZkvzMQ5ODGTleRcy0+d8yIf7Rsw7Ys8NNs3jAAAAABJRU5ErkJggg==);}
          url(images/ui-icons_525252_0.png);*/


          /* Parse Error */
          .ui-state-parseError{border-color:#EEEEEE ;color:#F45A16;background:#EEEEEE ;font-family:Segoe UI Light;}
          /* .ui-state-parseError .ui-icon{background-image:url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA8AAAAPCAYAAAA71pVKAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAGFSURBVDhPjVM9SEJRFP6e7wUt+TNV4hRUgzqKk0saCOEmgVuTQ0vgIiKmBaHo2BISQeCm4lKLqOTWUKKCiRYuUYNDouBgmqf3XvkT5s+5nOXe+93zne98lyE+sGBknjNw37qRf8tDs6YBBPAiEXmMEOtgCUcghUtB2ZcsLQROVpPEOTmCAyRzySj3mhPrzQXXPmqkOFUQnBAfSFVTQ6KSWe32+j3YojY0PhsACwT2AjBuGkeQWf1677wEHwjHIPO1mfr8Gg9mmtqFegG6Kx26vS7kS3KUDktQrij/EB3S7va7wwO+Auw3dgz2grvBCaB4WaASvg+T6kxF5XpZZBV+CP/QPQHpL/UTdAfU2cpGxedP+9HqtJB4SkC6LIUn7UG70+ZNAMT341BJVf/qyhTfi2Q4N6DZaYqKQmhESAawaqyI2qJTByLRrmsRO4iBYzjgi7/3m0yfgW/HN9O4omCmLRNClhAvwAhs2bZAvaqe7frxuZkvzMQ5ODGTleRcy0+d8yIf7Rsw7Ys8NNs3jAAAAABJRU5ErkJggg==);}
          url(images/ui-icons_525252_0.png);*/


          /* Error */
          .ui-state-error{border-color:#D11141;color:#ffffff;background:#D11141;;font-family:Segoe UI;}
          .ui-state-error .ui-icon{background-image:url(images/ui-icons_ffffff_0.png);}

          /* Overlays */
          .ui-widget-overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; }
          .ui-widget{font-family:"Segoe UI", Helvetica, Verdana;}
          /* states and images */
          .ui-icon { display: block; text-indent: -99999px; overflow: hidden; background-repeat: no-repeat; }
          .ui-icon-alert { background-position: 0 -144px; }

        </style>
        <script language="JavaScript">
          <![CDATA[
     
        function flip (currentRowNode){
        // currentRowNode.nextSibling.childNodes[0] == td
        var expand;

        if(currentRowNode.childNodes[0].getElementsByTagName("A")[0].firstChild.nodeValue == '+')
        {
        currentRowNode.childNodes[0].getElementsByTagName("A")[0].firstChild.nodeValue  = "-"
        expand = true;
        }
        else
        {
        currentRowNode.childNodes[0].getElementsByTagName("A")[0].firstChild.nodeValue  = "+"
        expand = false;
        }


        expandCollapse(expand,  currentRowNode.parentNode.parentNode.rows[ currentRowNode.parentNode.rowIndex + 1 ]);

        }

        function expandCollapse(expand, currentRowNode) {

       
        if (expand) {
        currentRowNode.style.display = "block";

        }
        else {
        currentRowNode.style.display = "none";
        }

       

        }
        
       
        
        ]]>
        </script>
      </head>
      <body>


        <table style="width: 900pt;" class="noborder">
          <xsl:variable name="ReportsLocation" select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ReportsLocation"/>
          <xsl:variable name="GDBuildOutput" select="GDBuildOutput"/>
          <tr>
            <td class="noborder ">
              <span class="colored">
                Hi <strong>
                  <xsl:value-of select="GetBuildDefinition/project/name"></xsl:value-of>
                </strong> Team,
              </span>
              <br />
            </td>
          </tr>
          <tr>
            <td class="noborder">
              <span class="colored">
                The <xsl:value-of select="GetBuildDefinition/reason" /> ServicesBuild  for build definition    <u>
                  <xsl:value-of select="GetBuildDefinition/definition/name"/>
                </u>&#160;<!--<xsl:value-of select="translate(substring(GetBuildDefinition/result,1,1),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                <xsl:value-of select="substring(GetBuildDefinition/result,2)"/>-->
                <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TFSBuildStatus"/>
                <xsl:call-template name="StatusImage">
                  <xsl:with-param name="Status" select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TFSBuildStatus"/>
                </xsl:call-template>
              </span>
              <br />
              <br />
            </td>
          </tr>

          <xsl:if test="not(GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Errors[@Actual > 0])">
            <tr>
              <td class="noborder">
                <span class="header" style="color:red">
                  Build Errors
                </span>
              </td>
            </tr>
            <tr>
              <td class="noborder">
                <table width="100%" border="1" class="noborder subtext " cellpadding="5">
                  <tr width="100%;" class="bgcolored" >
                    <td>Error Type</td>
                    <td>File Path</td>
                    <td>Line</td>
                    <td>Description</td>
                  </tr>
                  <xsl:for-each  select="GetBuildDetails/records">
                    <xsl:choose>
                      <xsl:when test="starts-with(name, 'Build solution') or starts-with(name, 'Build Project') " >
                        <xsl:for-each  select="issues">
                          <xsl:if test="type='error'">
                            <tr style="color:#FF0000" >
                              <td>
                                <xsl:value-of select="category"/>
                              </td>
                              <td>
                                <xsl:value-of select="data/sourcepath"/>
                              </td>
                              <td>
                                <xsl:value-of select="data/linenumber"/>
                              </td>
                              <td>
                                <xsl:value-of select="message"/>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:for-each>
                </table>
              </td>
            </tr>
            <tr>
              <td class="noborder">
                <br/>
              </td>
            </tr>
          </xsl:if>
          <xsl:if test="(GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UserFriendlyMessage) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UserFriendlyMessage[@Actual > 0])">
            <tr>
              <td class="noborder">
                <span class="header" style="color:red">
                  Partial/Incomplete Report
                </span>
              </td>
            </tr>
            <tr>
              <td class="noborder">
                <table width="100%" border="1" class="noborder subtext " cellpadding="5">
                  <tr width="100%;" class="bgcolored" >
                    <td align="center">Possible Reason(s)</td>
                    <td align="center">Action Required(s)</td>
                  </tr>
                  <xsl:for-each  select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UserFriendlyMessage/Messages[position() &lt;=3]">
                    <xsl:if test="@message!=''">
                      <tr style="color:#FF0000" >
                        <td>
                          <xsl:if test="@message = 'No files checked in.'">
                            It appears that you haven't got a TFVC repo created in your team project. Currently, Services DevOps tasks require one and because of which build/tool reports could not be checked-in and links below may be broken.
                          </xsl:if>
                        </td>
                        <td>
                          A TFVC repo should be available in the team project. Please create TFVC repo and requeue the build.
                        </td>
                      </tr>
                    </xsl:if>
                  </xsl:for-each>
                </table>
              </td>
            </tr>
            <tr>
              <td class="noborder">
                <br/>
              </td>
            </tr>
          </xsl:if>
          <tr>
            <td class="noborder">
              <table cellpadding="5">
                <tr>
                  <td style="width:170px;text-align: right; " class="bgcolored">
                    Project Name
                  </td>
                  <td>
                    <xsl:value-of select ="GetBuildDefinition/project/name"></xsl:value-of>
                  </td>
                  <td style="width:170px;text-align: right; " class="bgcolored">
                    TPC URL
                  </td>
                  <td>
                    <xsl:value-of select ="substring-before(GetBuildDefinition/project/url,'/_apis')"></xsl:value-of>
                  </td>
                </tr>
                <tr>
                  <td style="width:170px;text-align: right; " class="bgcolored">
                    Team Project
                  </td>
                  <td>
                    <xsl:value-of select ="GetBuildDefinition/project/name"></xsl:value-of>
                  </td>
                  <td style="width:170px;text-align: right; " class="bgcolored">
                    Build Definition Name
                  </td>
                  <td>
                    <xsl:value-of select ="GetBuildDefinition/definition/name"></xsl:value-of>
                  </td>
                </tr>
                <tr>
                  <td style="width:170px;text-align: right; " class="bgcolored">
                    Build Summary
                  </td>
                  <td>
                    <a href="{substring-before(GetArtifacts/value[last()]/resource/downloadUrl,'_apis/')}_build?buildId={GetBuildDefinition/id}&amp;_a=summary&amp;tab=summary">here</a>
                  </td>
                  <td style="width:170px;text-align: right; " class="bgcolored">
                    <xsl:if test="GetBuildDefinition/repository/type='TfsGit'">
                      Repo (Branch name)
                    </xsl:if>
                    <xsl:if test="GetBuildDefinition/repository/type='TfsVersionControl'">
                      Branch
                    </xsl:if>
                  </td>
                  <td>
                     <xsl:if test="GetBuildDefinition/repository/type='TfsGit'">
                      <xsl:value-of select ="GetBuildDefinitionSpecs/repository/name"></xsl:value-of>
                      (<xsl:value-of select ="GetBuildDefinition/sourceBranch"></xsl:value-of>)
                     </xsl:if>
                    <xsl:if test="GetBuildDefinition/repository/type='TfsVersionControl'">
                      <xsl:value-of select ="GetBuildDefinition/sourceBranch"></xsl:value-of>
                    </xsl:if>
                  </td>
                </tr>
                <tr>
                  <td style="text-align: right; " class="bgcolored">
                    Build Number
                  </td>
                  <td>
                    <xsl:value-of select="GetBuildDefinition/buildNumber"></xsl:value-of>
                  </td>
                  <td style="text-align: right; " class="bgcolored">
                    Triggered By
                  </td>
                  <td>
                    <xsl:value-of select="GetBuildDefinition/requestedFor/displayName"></xsl:value-of>
                  </td>
                </tr>
                <tr>
                  <td style="text-align: right; " class="bgcolored">
                    Time (UTC)
                  </td>
                  <td>
                    <xsl:value-of select="substring-before(GetBuildDefinition/startTime,'T')"/>&#160;
                    <xsl:value-of select="substring-after(substring-before(GetBuildDefinition/startTime,'.'),'T')"/>
                    <xsl:if test="GetBuildDefinition/finishTime != ''">&#160;To&#160;</xsl:if>
                    <xsl:value-of select="substring-before(GetBuildDefinition/finishTime,'T')"/>&#160;
                    <xsl:value-of select="substring-after(substring-before(GetBuildDefinition/finishTime,'.'),'T')"/>
                  </td>
                  <td style="text-align: right; " class="bgcolored">
                    Configuration Analysed
                  </td>
                  <td>
                    <xsl:value-of select="GetBuildDefinitionSpecs/variables/BuildConfiguration/value"/>/<xsl:value-of select="GetBuildDefinitionSpecs/variables/BuildPlatform/value"/>
                  </td>
                </tr>
                <tr>
                  <td style="text-align: right; " class="bgcolored">
                    Build Artifacts
                  </td>
                  <td>
                    <a href="{substring-before(GetArtifacts/value[last()]/resource/downloadUrl,'_apis/')}_build/explorer?buildId={GetBuildDefinition/id}&amp;_a=summary&amp;tab=artifacts">here</a>
                  </td>
                  <td style="text-align: right; " class="bgcolored">
                    Agent Pool Name
                  </td>
                  <td>
                    <xsl:value-of select="GetBuildDefinition/queue/name"/>
                  </td>
                </tr>
                <tr>
                  <td style="text-align: right; " class="bgcolored">
                    ServicesBuild Web
                  </td>
                  <td>
                    <a href="{substring-before(GetArtifacts/value[last()]/resource/downloadUrl,'_apis/')}_build/explorer?buildId={GetBuildDefinition/id}&amp;_a=summary&amp;tab=EnterpriseServicesDevOpsTeam.ServicesCode-BuildReportTab.build-info-tab">here</a>
                  </td>
                  <td style="text-align: right; " class="bgcolored">
                    Is Registered
                  </td>
                  <td>
                    <!--<xsl:choose>
                      <xsl:when test="GDBuildOutput/GlobalInputArguments/UpdateVirtuoso [text()='true'] and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/BuildDBID != -1) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/BuildDBID != 1)">
                        Yes
                      </xsl:when>
                      <xsl:otherwise>
                        No
                      </xsl:otherwise>
                    </xsl:choose>-->
                    <xsl:choose>
                      <!--<xsl:if test="(GDBuildOutput/DynamicConfigOutput/BuildRunSummary/BuildDBID = -1) or (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/BuildDBID = 1)">-->
                      <xsl:when test="(GDBuildOutput/GlobalInputArguments/RegStatusID=1)">
                        <span style="color:red">[Virtuoso Project is not registered with ServicesDevOps Database.<br/> Please configure the Services DevOps tasks on your build as per <a href="https://aka.ms/registerservicesbuild" >https://aka.ms/registerservicesbuild</a> ]</span>
                      </xsl:when>
                      <xsl:when test="(GDBuildOutput/GlobalInputArguments/RegStatusID=2)">
                        <xsl:choose>
                          <xsl:when test="GDBuildOutput/GlobalInputArguments/RegisteredVPID=-1">
                            <span style="color:DarkOrange">
                              [This team project appears to be an Internal/Non-Virtuoso registration. <br/> If not then please confirm the change to override through a Misc. request @ <a href="https://aka.ms/esdevopsrequest">https://aka.ms/esdevopsrequest</a>]
                            </span>
                          </xsl:when>
                          <!--<xsl:when test="matches(GDBuildOutput/GlobalInputArguments/RegisteredVPID,'^([0-9a-fA-F]){8}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){4}-([0-9a-fA-F]){12}')">-->
                            <xsl:when test="contains(GDBuildOutput/GlobalInputArguments/RegisteredVPID,'-')">
                            <span style="color:green">
                              [Virtuoso Project ID <xsl:value-of select="GDBuildOutput/GlobalInputArguments/RegisteredVPID"/> is registered with ServicesDevOps database.
                            </span>
                          </xsl:when>
                          
                          <xsl:otherwise>
                            <span style="color:green">[Virtuoso Project ID <a href="https://virtuosoworldwide.azurewebsites.net/ProjectDetail?ProjectId={GDBuildOutput/GlobalInputArguments/RegisteredVPID}"><xsl:value-of select="GDBuildOutput/GlobalInputArguments/RegisteredVPID"/>
                            </a> is registered with ServicesDevOps Database]
                            </span>
                          </xsl:otherwise>
                        </xsl:choose>
                      </xsl:when>
                      <xsl:when test="(GDBuildOutput/GlobalInputArguments/RegStatusID=3)">
                        <span style="color:red">
                          [The virtuoso project ID <xsl:value-of select="GDBuildOutput/GlobalInputArguments/ActualVPId"/> configured in the ServiceEndpoint is different <br/> from what is already registered <xsl:value-of select="GDBuildOutput/GlobalInputArguments/RegisteredVPID"/> with ServicesDevOps Database.
                          <br/>Please confirm the change to override through a Misc. request @ <a href="https://aka.ms/esdevopsrequest">https://aka.ms/esdevopsrequest</a> ]
                        </span>
                      </xsl:when>
                      <xsl:when test="(GDBuildOutput/GlobalInputArguments/RegStatusID=-1)">
                        <span style="color:red">
                          Virtuoso Project registration not verified with ServicesDevOps database.
                        </span>
                      </xsl:when>
                    </xsl:choose>
                  </td>
                </tr>
                <!--
                <tr>
                  <td style="text-align: right; " class="bgcolored">
                    IS QG Build
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="GDBuildOutput/GlobalInputArguments/IsQGBuild [text()='true']">
                        Yes
                      </xsl:when>
                      <xsl:otherwise>
                        No
                      </xsl:otherwise>
                    </xsl:choose>
                  </td>
                  <td style="text-align: right; " class="bgcolored">
                    Posted to Virtuoso
                  </td>
                  <td>
                    <xsl:choose>
                      <xsl:when test="GDBuildOutput/GlobalInputArguments/UpdateVirtuoso [text()='true'] and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/BuildDBID != -1)">
                        Yes
                      </xsl:when>
                      <xsl:otherwise>
                        No
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/BuildDBID = -1">
                      <span style="color:red">[Definition not registered with ServicesBuild Database]</span>
                    </xsl:if>
                  </td>
                </tr>-->
              </table>
            </td>
          </tr>
          <tr>
            <td class="noborder" colspan="3" style="text-align:left;vertical-align:middle;">
              <table >
                <tr>
                  <td class="noborder">
                    <br/>
                  </td>
                </tr>
                <tr>
                  <td class="header" >
                    Legend
                  </td>
                  <td class="noborder">                       </td>
                  <td class="noborder">                       </td>
                  <td class="noborder">                       </td>
                  <td class="noborder">                       </td>
                  <td class="noborder">                       </td>
                  <td class="noborder">                       </td>
                  <td>
                    <img alt="" hspace="0" src="Image_greentick.jpg" align="baseline" border="0" />
                  </td>
                  <td style="text-align: left; " class="bgcoloredsmall">
                    Passed
                  </td>
                  <td class="noborder">   </td>
                  <td class="noborder">   </td>
                  <td>
                    <img alt="" hspace="0" src="Image_orangetick.jpg" align="baseline" border="0" />
                  </td>
                  <td style="text-align: left; " class="bgcoloredsmall">
                    Passed with warnings
                  </td>
                  <td class="noborder">   </td>
                  <td class="noborder">   </td>
                  <td>
                    <img alt="" hspace="0" src="Image_cross.jpg" align="baseline" border="0" />
                  </td>
                  <td style="text-align: left; " class="bgcoloredsmall">
                    Failed with errors
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="noborder">
               <br></br>
              <table align="center" width="100%" class="noborder">
                <tr>
                  <td style="background-color:#FFFFCC" >
                    <span class="header" style="text-align: center; font-family:Segoe UI Light;font-size:16px; color:#990099;  ">
                      Do you want to automate your deployments to your Dev/Test environments? Review this <a href="https://aka.ms/esdevopsrm">wiki</a> and contact us with a <a href="https://aka.ms/newservicesrelease">ServicesRelease</a> request for a trial.
                    </span>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <xsl:if test="GDBuildOutput/GlobalInputArguments/IsQGMet=false()">
            <tr>
              <td class="noborder">
                <table align="center" width="100%" class="noborder">
                  <tr>
                    <td class="noborder">
                      <span class="header" style="text-align: center; font-family:Segoe UI Light;font-size:16px; color:#FF0000;">
                        Technical QGs for this build are not met and therefore please review and configure the target QGs as per https://aka.ms/esdevopsbuildconfig.
                      </span>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:if>
          <tr>
            <td class="noborder">
              <table align="center" width="100%" cellpadding="5" cellspacing="0" class="noborder">
                <tr>
                  <td class="noborder">
                    <span class="header">
                      <br/>ServicesBuild Status [Built using <a href="http://msdn.microsoft.com/en-us/library/ms171452.aspx">MSBuild</a>]
                    </span>
                  </td>
                </tr>
                <!--****************************************************************************Compile****************************************************-->
                <tr>
                  <td class="noborder">
                    <table align="center" width="100%" cellpadding="5" cellspacing="0">
                      <tr style="text-align: center; " class="bgcolored" >
                        <td style="width: 200px;">
                          Task
                        </td>
                        <td width="43.5%">
                          Remark
                        </td>
                        <td width="5%">
                          Status
                        </td>
                        <td width="17%">
                          Targets
                        </td>
                        <td width="17%">
                          Achieved
                        </td>
                      </tr>
                      <xsl:if test="(GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings)">
                        <tr>
                          <td style="width: 200px;text-align: center;" class="colored" valign="top">
                            Build Creation
                          </td>
                          <td>
                            <span>
                              Build Errors/Warnings  <a href="{GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@ReportURI}">         here              </a>
                            </span>
                          </td>
                          <td align="center" valign="middle">
                            <img alt="" hspace="0" align="baseline" border="0" >
                              <xsl:choose>
                                <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual>0">
                                  <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual >0">
                                  <xsl:attribute name="src">Image_Orangetick.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </img>
                          </td>
                          <td valign="middle">
                            0 Error(s)
                            <br />
                            <span>
                              0 Warning(s)
                            </span>
                          </td>
                          <td valign="middle">
                            <span >
                              <xsl:choose>
                                <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual>0">
                                  <xsl:attribute name="style">color:red</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="style">color:green</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual"/> Error(s)
                            </span>
                            <br />
                            <span>
                              <xsl:choose>
                                <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual >0 ">
                                  <xsl:attribute name="style">color:orange</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="style">color:green</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual"/> Warning(s)
                            </span>
                          </td>
                        </tr>
                      </xsl:if>
                      <tr>
                        <td style="width: 200px;text-align: center;" class="colored" valign="top">
                          Compilation
                        </td>
                        <td>
                          <span>
                            Compilation Warnings  <a href="{GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Warnings/@ReportURI}">         here              </a>
                          </span>
                        </td>
                        <td align="center" valign="middle">
                          <img alt="" hspace="0" align="baseline" border="0" >
                            <xsl:choose>
                              <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Errors/@Actual > GlobalInputArguments/GeneralTargets/CompilationErrorsTarget or DynamicConfigOutput/BuildRunSummary/TFSBuildStatus = 'Failed'">
                                <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
                              </xsl:when>
                              <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TFSBuildStatus = 'Succeeded' and GlobalInputArguments/GeneralTargets/CompilationWarningsTarget >= DynamicConfigOutput/BuildRunSummary/Warnings/@Actual">
                                <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="src">Image_Orangetick.jpg</xsl:attribute>
                              </xsl:otherwise>
                            </xsl:choose>
                          </img>
                        </td>
                        <td valign="middle">
                          <span>
                            <xsl:value-of select="GDBuildOutput/GlobalInputArguments/GeneralTargets/CompilationErrorsTarget"/>
                          </span> Error(s)
                          <br />
                          <span>
                            <xsl:value-of select="GDBuildOutput/GlobalInputArguments/GeneralTargets/CompilationWarningsTarget"/> Warning(s)
                          </span>
                        </td>
                        <td valign="middle">
                          <span >
                            <xsl:choose>
                              <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Errors/@Actual > GDBuildOutput/GlobalInputArguments/GeneralTargets/CompilationErrorsTarget or DynamicConfigOutput/BuildRunSummary/TFSBuildStatus = 'Failed'">
                                <xsl:attribute name="style">color:red</xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="style">color:green</xsl:attribute>
                              </xsl:otherwise>
                            </xsl:choose>

                            <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Errors/@Actual"/> Error(s)
                          </span>
                          <br />
                          <span>
                            <xsl:choose>
                              <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Warnings/@Actual > GDBuildOutput/GlobalInputArguments/GeneralTargets/CompilationWarningsTarget">
                                <xsl:attribute name="style">color:orange</xsl:attribute>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:attribute name="style">color:green</xsl:attribute>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Warnings/@Actual"/> Warning(s)
                          </span>
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr>
            <td class="noborder">
              <table align="center" width="100%" cellpadding="0" cellspacing="0" class="noborder" style="border:none;">
                <tr>
                  <td class="noborder">
                    <span class="header">
                      Artifacts
                    </span>
                  </td>
                </tr>
                <tr style="text-align: center; " class="bgcolored" >
                  <td>
                    Tool
                  </td>
                  <td>
                    Steps
                  </td>
                </tr>
                <tr class="noborder" cellpadding="0" cellspacing="0" style="border:none;">
                  <xsl:for-each  select="GetBuildDetails/records">
                    <xsl:choose>
                      <xsl:when test="starts-with(name, 'Publish to Artifact Services Drop')">
                        <td style="width: 200px;text-align: center;" class="colored" valign="top" cellpadding="0" cellspacing="0">
                          <a href="https://aka.ms/vstsdrop"> VSTSDrop</a>
                        </td>
                      </xsl:when>
                    </xsl:choose>
                  </xsl:for-each>
                  <td class="noborder" cellpadding="0" cellspacing="0" valign="top" >
                    <xsl:for-each  select="GetBuildDefinitionSpecs/build">
                      <xsl:choose>
                        <xsl:when test="starts-with(displayName, 'Publish to Artifact Services Drop')">
                          <xsl:if test="starts-with(enabled,'true')">
                            <div>
                              Download, extract and navigate to the folder of <a href="{inputs/dropServiceURI}/_apis/drop/client/exe">Drop.exe</a>
                            </div>
                            execute below command<br></br>
                            <b>
                              drop.exe get -u <xsl:value-of select="inputs/dropServiceURI"/>/_apis/drop/drops/</b>
                          </xsl:if>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                    <xsl:variable name="BuilddefinitionName"  select="translate(GetBuildDefinition/definition/name,'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz')"/>
                    <xsl:variable name="BuildNumber"  select="GetBuildDefinition/buildNumber"/>
                    <xsl:variable name="Buildid"  select="GetBuildDefinition/id"/>
                    <xsl:for-each  select="GetBuildDefinitionSpecs/build">
                      <xsl:choose>
                        <xsl:when test="starts-with(displayName, 'Publish to Artifact Services Drop')">
                          <xsl:if test="starts-with(enabled,'true')">
                            <b>
                              <xsl:value-of select ="$BuilddefinitionName"/>/<xsl:value-of select="$BuildNumber"/>/<xsl:value-of select="$Buildid"/> -d "Destination Path"
                            </b>
                            <br/>
                            <br/>
                            *Refer <a href="https://www.1eswiki.com/index.php?title=VSTS_Drop&amp;section=13#Authentication">this</a> for authentication
                          </xsl:if>
                        </xsl:when>
                      </xsl:choose>
                    </xsl:for-each>
                  </td>
                </tr>
                <tr>
                  <td style="width: 200px;text-align: center;" class="colored" valign="top">Other Artifacts</td>
                  <td valign="top">
                    Published VSTS build artifacts are <a href="{substring-before(GetArtifacts/value[last()]/resource/downloadUrl,'_apis/')}_build?buildId={GetBuildDefinition/id}&amp;_a=summary&amp;tab=artifacts">here</a>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <!--****************************************************************************Build errors and warnings ****************************************************-->
          <tr>
            <td class="noborder">
              <table align="center" width="100%" cellpadding="4" cellspacing="0" class="noborder">
                <tr>
                  <td class="noborder">
                    <span style="color:red">
                      <xsl:if test="((GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual>0))">
                        <br/> Errors(<a href="{GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@ReportURI}">
                          <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual"/>
                        </a>)/
                      </xsl:if>
                    </span>
                    <span style="color:#FF6600">
                      <xsl:if test="((GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual=0) and (GDBuildOutput/GlobalInputArguments/BuildWarnings/@ShowInReport='true') and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual>0))">
                        <br/>
                      </xsl:if>
                      <xsl:if test="((GDBuildOutput/GlobalInputArguments/BuildWarnings/@ShowInReport='true') and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual>0))">
                        Warnings(<a href="{GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@ReportURI}">
                          <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual"/>
                        </a>)
                      </xsl:if>
                    </span>
                  </td>
                </tr>
                <xsl:if test="((GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors) and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/@Actual > 0)) or ((GDBuildOutput/GlobalInputArguments/BuildWarnings/@ShowInReport='true') and (GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/@Actual > 0))">
                  <tr>
                    <td class="noborder">
                      <table width="100%" border="1" class="noborder subtext " cellpadding="5">
                        <tr width="100%;" class="bgcolored" >
                          <td>Type</td>
                          <td>Task</td>
                          <td>File Path</td>
                          <td>Line</td>
                          <td>Description</td>
                        </tr>
                        <xsl:for-each  select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualErrors/Errors[position() &lt;=3]">
                          <xsl:if test="@message!=''">
                            <tr style="color:#FF0000" >
                              <td>
                                <xsl:value-of select="@category"/>
                              </td>
                              <td>
                                <xsl:value-of select="@taskName"/>
                              </td>
                              <td>
                                <xsl:value-of select="@sourcepath"/>
                              </td>
                              <td>
                                <xsl:value-of select="@linenumber"/>
                              </td>
                              <td>
                                <xsl:value-of select="@message"/>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each  select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ActualWarnings/Warnings[position() &lt;=3]">
                          <xsl:if test="@message!=''">
                            <tr style="color:#FF6600;">
                              <td>
                                <xsl:value-of select="@category"/>
                              </td>
                              <td>
                                <xsl:value-of select="@taskName"/>
                              </td>
                              <td>
                                <xsl:value-of select="@sourcepath"/>
                              </td>
                              <td>
                                <xsl:value-of select="@linenumber"/>
                              </td>
                              <td>
                                <xsl:value-of select="@message"/>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
              </table>
            </td>
          </tr>         

          <!--***************************************************************UNIT TEST****************************************************************************-->
          <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Enabled = 'true'">
            <tr>
              <td class="noborder">
                <table align="center" width="100%" cellpadding="5" cellspacing="0">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/>Tests (VSTest/MSTest)
                      </span>
                    </td>
                  </tr>

                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Task
                          </td>
                          <td width="43.5%">
                            Remarks
                          </td>
                          <td width="5%">
                            Status
                          </td>
                          <td width="17%">
                            Target
                          </td>
                          <td width="17%">
                            Actual
                          </td>
                        </tr>
                        <tr>
                          <td style="width: 200px;text-align: center;" class="colored" valign="top">
                            Unit Tests
                          </td>
                          <td>
                            Total Tests: <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Total"/>,
                            Passed: <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Passed"/>,
                            Failed: <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Failed"/>,
                            Inconclusive: <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Inconclusive"/>
                            <br/>
                            <xsl:choose>
                              <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TestResultsLocation != '' and $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Enabled = 'true'">
                                Test Results Location <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TestResultsLocation}">here</a>
                              </xsl:when>
                              <xsl:otherwise>
                                <xsl:call-template name="ReportNotAvailable"/>
                              </xsl:otherwise>
                            </xsl:choose>
                            <xsl:call-template name="ParseError">
                              <xsl:with-param name="ErrorDesc" select="DynamicConfigOutput/BuildRunSummary/UnitTest/@ParseError" />
                            </xsl:call-template>
                          </td>
                          <td align="center" valign="middle">
                            <img alt="" hspace="0"  align="baseline" border="0" >
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Status = 'Succeeded'">
                                  <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="not ($GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest) or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Status = 'Failed'">
                                  <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="src">Image_Orangetick.jpg</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </img>
                          </td>
                          <td valign="middle">
                            <span >
                              <xsl:value-of select="$GDBuildOutput/GlobalInputArguments/GeneralTargets/UnitTestFailureTarget"/> Failed
                            </span>
                          </td>
                          <td valign="middle">
                            <xsl:choose>
                              <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Enabled = 'true'">
                                <span>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Status = 'Succeeded'">
                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Status = 'Failed'">
                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Failed"/> Failed <br/>
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Inconclusive"/> Inconclusive
                                </span>
                              </xsl:when>
                              <xsl:otherwise>
                                <div class="ui-widget">
                                  <div class="ui-state-error" style="padding: 0 .7em;">
                                    <p>
                                      <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                      <strong>Alert:</strong> Please Enable Unit Tests.
                                    </p>
                                  </div>
                                </div>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>

                        <!--***************************************************************QUNIT TEST ****************************************************************************-->
                        <xsl:if test="($GDBuildOutput/Tools/QUNIT/@Enabled = 'true')">
                          <tr>
                            <td style="width: 200px;text-align: right;" class="colored" valign="top">
                              QUnit Tests
                            </td>
                            <td>
                              Total Tests: <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/Tests/@Total"/>,
                              Passed: <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/Tests/@Passed"/>,
                              Failed: <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/Tests/@FaliedActual"/>,
                              <br/>
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/ToolRunDetails/@ReportURI != '' and $GDBuildOutput/Tools/QUNIT/@Enabled = 'true'">
                                  Test Results Location <a href="{$ReportsLocation}/Qunit/QunitOutput.xml">here</a>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:call-template name="ReportNotAvailable"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:call-template name="ParseError">
                                <xsl:with-param name="ErrorDesc" select="$GDBuildOutput/Tools/QUNIT/Output/ToolRunDetails/@ParseError" />
                              </xsl:call-template>
                            </td>
                            <td align="center" valign="middle">
                              <img alt="" hspace="0"  align="baseline" border="0" >
                                <xsl:choose>
                                  <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/ToolRunDetails/@Status = 'Succeeded'">
                                    <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                  </xsl:when>
                                  <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/ToolRunDetails/@Status = 'Failed'">
                                    <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="src">Image_Orangetick.jpg</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </img>
                            </td>
                            <td valign="middle">
                              <span >
                                <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/Tests/@FaliedTarget"/> Failed
                              </span>
                            </td>
                            <td valign="middle">
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/Tools/QUNIT/@Enabled = 'true'">
                                  <span>
                                    <xsl:choose>
                                      <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/ToolRunDetails/@Status = 'Succeeded'">
                                        <xsl:attribute name="style">color:green</xsl:attribute>
                                      </xsl:when>
                                      <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/ToolRunDetails/@Status = 'Failed'">
                                        <xsl:attribute name="style">color:red</xsl:attribute>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/Tests/@FaliedActual"/> Failed <br/>
                                  </span>
                                </xsl:when>
                                <xsl:otherwise>
                                  <div class="ui-widget">
                                    <div class="ui-state-error" style="padding: 0 .7em;">
                                      <p>
                                        <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                        <strong>Alert:</strong> Please Enable Unit Tests.
                                      </p>
                                    </div>
                                  </div>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                          </tr>
                        </xsl:if>

                        <!--***************************************************************Chutzpah Coverage ****************************************************************************-->
                        <xsl:if test="($GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@Enabled = 'true')">
                          <tr>
                            <td style="width: 200px;text-align: right;" class="colored" valign="top">
                              Chutzpah Coverage
                            </td>
                            <td>
                              <table align="left"  cellspacing="0">
                                <tr class="bgcolored" style="text-align: center;">
                                  <td width="20%" >
                                    No.of Source Files
                                  </td>
                                  <td width="20%">
                                    Source Lines
                                  </td>
                                  <td width="20%">
                                    Covered Lines
                                  </td>
                                </tr>
                                <tr style="text-align: center; ">
                                  <td>
                                    <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@SrcFileCount"/>
                                  </td>
                                  <td>
                                    <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@SrcTotalLineCount"/>
                                  </td>
                                  <td>
                                    <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@CoverageLineCount"/>
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    <span>
                                      Coverage Results <a href="{$ReportsLocation}/chutzpahcoverage.htm">here</a>
                                    </span>
                                  </td>
                                </tr>
                              </table>
                            </td>
                            <td align="center" valign="middle">
                              <img alt="" hspace="0"  align="baseline" border="0" >
                                <xsl:choose>
                                  <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@Status = 'Succeeded'">
                                    <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                  </xsl:when>
                                  <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@Status = 'Failed'">
                                    <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <xsl:attribute name="src">Image_Orangetick.jpg</xsl:attribute>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </img>
                            </td>
                            <td valign="middle">
                              <span >
                                Coverage >= <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@CoverageTargetPercentage"/>%
                              </span>
                            </td>
                            <td valign="middle">
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@Enabled = 'true'">
                                  <span>
                                    <xsl:choose>
                                      <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@Status = 'Succeeded'">
                                        <xsl:attribute name="style">color:green</xsl:attribute>
                                      </xsl:when>
                                      <xsl:when test="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@Status = 'Failed'">
                                        <xsl:attribute name="style">color:red</xsl:attribute>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:value-of select="$GDBuildOutput/Tools/QUNIT/Output/Metrics/ChutzpahCoverage/@CoverageActualPercentage"/> % <br/>
                                  </span>
                                </xsl:when>
                              </xsl:choose>
                            </td>
                          </tr>
                        </xsl:if>


                        <!--**************************************************************CODE COVERAGE****************************************************************************-->
                        <tr>
                          <td style="width: 200px;text-align: center;" class="colored" valign="top">
                            <a href="https://aka.ms/codecoverage">Code Coverage Analysis</a>
                          </td>
                          <td>
                            <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Enabled = 'true'">
                              <table border="0">
                                <tr class="bgcolored">
                                  <td>
                                    Assembly Name
                                  </td>
                                  <td>
                                    Blocks Covered
                                  </td>
                                  <td>
                                    Blocks Not Covered
                                  </td>
                                  <td>
                                    Lines Covered
                                  </td>
                                  <td>
                                    Lines Not Covered
                                  </td>
                                  <td>
                                    Percentage Covered (Blocks)
                                  </td>
                                  <td>
                                    Percentage Covered (Lines)
                                  </td>
                                </tr>
                                <xsl:for-each  select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/Assembly">
                                  <tr>
                                    <td align="left" style="overflow: hidden;word-wrap: break-word">
                                      <xsl:value-of select="text()"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@BlocksCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@BlocksNotCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@LinesCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@LinesNotCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@PercentageCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@PercentageOfLinesCovered"/>
                                    </td>
                                  </tr>
                                </xsl:for-each>
                                <tr bgcolor="#f0f0f0" style="color: #007ACC;">
                                  <td align="right" style="border-color:white">
                                    Summary of [<xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@AssemblyCount"/>] Assemblies
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@BlocksCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@BlocksNotCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@LinesCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@LinesNotCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@PercentageCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@PercentageOfLinesCovered"/>
                                  </td>
                                </tr>
                              </table>
                              <!--<br/>
                            <span>
                              Total No of Project Assemblies :
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ReportsLocation != ''">                                  
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@AssemblyCount"/>
                                </xsl:when>                                
                              </xsl:choose>
                            </span>-->
                              <br/>
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@ReportURI != ''">
                                  code coverage results <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@ReportURI}">here</a>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:call-template name="ReportNotAvailable"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <xsl:call-template name="ParseError">
                                <xsl:with-param name="ErrorDesc" select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@ParseError" />
                              </xsl:call-template>
                            </xsl:if>
                          </td>
                          <td align="center" valign="middle">
                            <img alt="" hspace="0" align="baseline" border="0" >
                              <xsl:choose>
                                <xsl:when test="not($GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Enabled) or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Enabled = 'false' or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'Failed'">
                                  <xsl:attribute name="src">Image_Cross.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'Succeeded'">
                                  <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="src">Image_orangeTick.jpg</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </img>
                          </td>
                          <td valign="middle">
                            <span>
                              Blocks Coverage &gt;=  <xsl:value-of select="$GDBuildOutput/GlobalInputArguments/GeneralTargets/UnitTestCodeCoverageTarget"/> %
                            </span>
                            <font  color="#348017">
                            </font>
                            <span>
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/GlobalInputArguments/GeneralTargets/UnitTestCodeCoverageLineTarget">
                                  Lines Coverage &gt;=  <xsl:value-of select="$GDBuildOutput/GlobalInputArguments/GeneralTargets/UnitTestCodeCoverageLineTarget"/> %
                                </xsl:when>
                                <xsl:otherwise>
                                  Lines Coverage &gt;=  0 %
                                </xsl:otherwise>
                              </xsl:choose>
                            </span>
                          </td>
                          <td valign="middle">
                            <xsl:choose>
                              <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'NA'">
                                <div class="ui-widget">
                                  <p>
                                    Code coverage is not available for Windows Store apps.
                                  </p>
                                </div>
                              </xsl:when>
                              <xsl:when test="( $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest and $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/@Status != 'Failed' )    and (  not($GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage) or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Enabled = 'false' ) ">
                                <div class="ui-widget">
                                  <div class="ui-state-error" style="padding: 0 .7em;">
                                    <p>
                                      <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                      <strong>Alert:</strong> Please Enable Code Coverage.
                                    </p>
                                  </div>
                                </div>
                              </xsl:when>
                              <xsl:otherwise>
                                <span>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'Succeeded'">
                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'Failed'">
                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@PercentageCovered">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@PercentageCovered"/> %
                                  </xsl:if>
                                </span>
                                <br />
                                <span>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'Succeeded'">
                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@Status = 'Failed'">
                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@PercentageOfLinesCovered">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@PercentageOfLinesCovered"/> %
                                  </xsl:if>
                                </span>
                              </xsl:otherwise>
                            </xsl:choose>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:if>

          <!--***************************************************************X UNIT TEST & Code Coverage****************************************************************************-->
          <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Enabled = 'true'">
            <tr>
              <td class="noborder">
                <table align="center" width="100%" cellpadding="5" cellspacing="0">

                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/>XUnit Test
                      </span>
                    </td>
                  </tr>

                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Task
                          </td>
                          <td width="43.5%">
                            Remarks
                          </td>
                          <td width="5%">
                            Status
                          </td>
                          <td width="17%">
                            Target
                          </td>
                          <td width="17%">
                            Actual
                          </td>
                        </tr>
                        <tr>
                          <td style="width: 200px;text-align: center;" class="colored" valign="top">
                            XUnit Tests
                          </td>
                          <td>
                            <table border="0">
                              <tr class="bgcolored">
                                <td align="center" width="15%">Passed</td>
                                <td align="center" width="15%">Failed</td>
                                <td align="center" width="15%">Skipped</td>
                                <td align="center" width="15%">Errors</td>
                                <td align="center" width="25%">TestProjects WithoutTests</td>
                                <td align="center" width="15%">Total Tests</td>
                              </tr>
                              <tr bgcolor="#f0f0f0" style="color: #007ACC;">
                                <td align="center" style="max-width:15%;">
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Passed"/>
                                </td>
                                <td align="center" style="max-width:15%;">
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Failed"/>
                                </td>
                                <td align="center" style="max-width:15%;">
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Skipped"/>
                                </td>
                                <td align="center" style="max-width:15%;">
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Errors"/>
                                </td>
                                <td align="center" style="max-width:25%;">
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@TestProjectsWithoutTests"/>
                                </td>
                                <td align="center" style="max-width:15%;">
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Total"/>
                                </td>
                              </tr>
                            </table>
                            <br/>
                            <!--XUnit Test Results Location <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TestResultsLocation}">here</a>-->
                            <xsl:choose>
                              <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@ReportURI != '' and $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Enabled = 'true'">
                                Detailed test result summary report <a href="{$ReportsLocation}/TestResultSummary.xml">here</a><br/>
                                TFS test results location <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@ReportURI}">here</a>
                              </xsl:when>
                            </xsl:choose>
                            <xsl:call-template name="ParseError">
                              <xsl:with-param name="ErrorDesc" select="DynamicConfigOutput/BuildRunSummary/XUnitTest/@ParseError" />
                            </xsl:call-template>
                          </td>
                          <td align="center" valign="middle">
                            <img alt="" hspace="0"  align="baseline" border="0" >
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Status = 'Succeeded'">
                                  <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="not ($GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest) or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Status = 'Failed'">
                                  <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="src">Image_Orangetick.jpg</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </img>
                          </td>
                          <td valign="middle">
                            <span >
                              <xsl:value-of select="$GDBuildOutput/GlobalInputArguments/GeneralTargets/XUnitTestFailureTarget"/> Failed
                            </span>
                          </td>
                          <td valign="middle">
                            <xsl:choose>
                              <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Enabled = 'true'">
                                <span>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Status = 'Succeeded'">
                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Status = 'Failed'">
                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Failed"/> Failed <br/>
                                  <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/@Passed"/> Passed <br/>

                                </span>
                              </xsl:when>

                            </xsl:choose>
                          </td>
                        </tr>
                        <!--**************************************************************X CODE COVERAGE****************************************************************************-->
                        <tr>
                          <td style="width: 200px;text-align: center;" class="colored" valign="top">
                            <a href="https://aka.ms/codecoverage">Code Coverage Analysis</a>
                          </td>
                          <td>
                            <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Enabled = 'true'">
                              <table border="0">
                                <tr class="bgcolored">
                                  <td width="11%">
                                    No of Assemblies
                                  </td>
                                  <td width="11%">
                                    Classes
                                  </td>
                                  <td width="11%">
                                    Files
                                  </td>
                                  <td width="11%">
                                    Covered Lines
                                  </td>
                                  <td width="11%">
                                    UnCovered Lines
                                  </td >
                                  <td width="11%">
                                    Coverable Lines
                                  </td>
                                  <td  width="11%">
                                    Total Lines
                                  </td>
                                  <td width="11%">
                                    Line Coverage
                                  </td>
                                  <td width="11%">
                                    Branch Coverage
                                  </td>
                                </tr>
                                <xsl:for-each  select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/CodeCoverage/Assembly">
                                  <tr>
                                    <td align="left" style="overflow: hidden;word-wrap: break-word">
                                      <xsl:value-of select="text()"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@BlocksCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@BlocksNotCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@LinesCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@LinesNotCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@PercentageCovered"/>
                                    </td>
                                    <td align="center" style="max-width:10%;">
                                      <xsl:value-of select="@PercentageOfLinesCovered"/>
                                    </td>
                                  </tr>
                                </xsl:for-each>
                                <tr bgcolor="#f0f0f0" style="color: #007ACC;">
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Assemblies"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Classes"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Files"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@LinesCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@LinesNotCovered"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@LinesCovererable"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@TotalLines"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@LineCoverage"/>
                                  </td>
                                  <td align="center" style="border-color:white">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@BranchCoverage"/>
                                  </td>
                                </tr>
                              </table>
                              <!--<br/>
                            <span>
                              Total No of Project Assemblies :
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ReportsLocation != ''">                                  
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/UnitTest/CodeCoverage/@AssemblyCount"/>
                                </xsl:when>                                
                              </xsl:choose>
                            </span>-->
                              <br/>
                              <!-- Code Coverage Results <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@ReportURI}">here</a>-->
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@ReportURI != ''">
                                  Detailed code coverage summary report <a href="{$ReportsLocation}/CodeCoverageSummary.xml">here</a><br/>
                                  TFS code coverage results <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@ReportURI}">here</a>
                                </xsl:when>

                              </xsl:choose>

                              <xsl:call-template name="ParseError">
                                <xsl:with-param name="ErrorDesc" select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@ParseError" />
                              </xsl:call-template>
                            </xsl:if>
                          </td>
                          <td align="center" valign="middle">
                            <img alt="" hspace="0" align="baseline" border="0" >
                              <xsl:choose>
                                <xsl:when test="not($GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Enabled) or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Enabled = 'false' or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'Failed'">
                                  <xsl:attribute name="src">Image_Cross.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'Succeeded'">
                                  <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:attribute name="src">Image_orangeTick.jpg</xsl:attribute>
                                </xsl:otherwise>
                              </xsl:choose>
                            </img>
                          </td>
                          <td valign="middle">
                            <span>
                              Line Coverage &gt;=  <xsl:value-of select="$GDBuildOutput/GlobalInputArguments/GeneralTargets/XUnitCodeCoverageLineTarget"/> %
                            </span>
                            <font  color="#348017">
                            </font>
                            <span>
                              <xsl:choose>
                                <xsl:when test="$GDBuildOutput/GlobalInputArguments/GeneralTargets/XUnitCodeCoverageBranchTarget">
                                  Branch Coverage &gt;=  <xsl:value-of select="$GDBuildOutput/GlobalInputArguments/GeneralTargets/XUnitCodeCoverageBranchTarget"/> %
                                </xsl:when>
                                <xsl:otherwise>
                                  Branch Coverage &gt;=  0 %
                                </xsl:otherwise>
                              </xsl:choose>
                            </span>
                          </td>
                          <td valign="middle">
                            <xsl:choose>
                              <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'NA'">
                                <div class="ui-widget">
                                  <p>
                                    Code coverage is not available for Windows Store apps.
                                  </p>
                                </div>
                              </xsl:when>
                              <xsl:when test="( $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage and $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status != 'Failed' )    and (  not($GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage) or $GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Enabled = 'false' ) ">
                                <div class="ui-widget">
                                  <div class="ui-state-error" style="padding: 0 .7em;">
                                    <p>
                                      <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                      <strong>Alert:</strong> Please Enable Code Coverage.
                                    </p>
                                  </div>
                                </div>
                              </xsl:when>
                              <xsl:otherwise>
                                <span>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'Succeeded'">
                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'Failed'">
                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@LineCoverage">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@LineCoverage"/>
                                  </xsl:if>
                                </span>
                                <br />
                                <span>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'Succeeded'">
                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                    </xsl:when>
                                    <xsl:when test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@Status = 'Failed'">
                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                  <xsl:if test="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@BranchCoverage">
                                    <xsl:value-of select="$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/XUnitTest/XCodeCoverage/@BranchCoverage"/>
                                  </xsl:if>
                                </span>
                              </xsl:otherwise>
                            </xsl:choose>

                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:if>

          <!--***************************************************************Technical Insights****************************************************************************-->
          <xsl:if test="GDBuildOutput/Tools/Sonar/@Enabled='true'">
            <tr>
              <td class="noborder">
                <table align="center" width="100%" cellpadding="5" cellspacing="0">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        Technical Insights
                      </span>
                    </td>
                  </tr>

                  <!--****************************************************************************Sonar****************************************************-->
                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Description
                          </td>
                          <td width="43.5%">
                            Remarks
                          </td>
                          <td width="5%">
                            Status
                          </td>
                          <td width="17%">
                            Target
                          </td>
                          <td width="17%">
                            Actual
                          </td>
                        </tr>
                        <xsl:if test="GDBuildOutput/Tools/Sonar/@Enabled='true'">
                          <tr>
                            <td style="width: 200px;text-align: center;" class="colored" valign="top">
                              <a href="http://aka.ms/servicessonar">
                                <xsl:value-of select="$GDBuildOutput/Tools/Sonar/@DisplayName"/>
                              </a>
                              <br/>
                              <span class="subtext">
                                [<a href="https://www.sonarqube.org/">SonarQube</a><xsl:value-of select="$GDBuildOutput/Tools/Sonar/Description"/>]
                              </span>
                            </td>
                            <td>
                              <table width="100%"  align="left"  cellspacing="0" class="subtext">
                                <tr class="bgcolored" style="text-align: center; " >
                                  <td width="50%" >
                                    Metric
                                  </td>
                                  <td width="50%">
                                    Result
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    Quality Gate Status
                                  </td>
                                  <td>
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="Sonar/component/measures[metric = 'alert_status']/value"/>
                                    </xsl:call-template>
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    Total Technical Debt
                                  </td>
                                  <td>
                                    <a href="{Sonar/@SonarURL}/component_measures/metric/sqale_index/list?id={$GDBuildOutput/Tools/Sonar/@Note}">
                                      <xsl:value-of select="Sonar/component/measures[metric = 'sqale_index']/value"/>
                                    </a>d
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    Technical Debt Ratio
                                  </td>
                                  <td>
                                    <a href="{Sonar/@SonarURL}/component_measures/metric/sqale_debt_ratio/list?id={$GDBuildOutput/Tools/Sonar/@Note}">
                                      <xsl:value-of select="Sonar/component/measures[metric = 'sqale_debt_ratio']/value"/>
                                    </a>%
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    SonarQube Quality Model Rating [Bugs]
                                  </td>
                                  <td>
                                    <a href="{Sonar/@SonarURL}/component_measures/metric/reliability_rating/list?id={$GDBuildOutput/Tools/Sonar/@Note}">
                                      <xsl:value-of select="Sonar/component/measures[metric = 'reliability_rating']/value"/>
                                    </a>
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    New Bugs [since last analysis]
                                  </td>
                                  <td>
                                    <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false|types=BUG|sinceLeakPeriod=true">
                                      <xsl:value-of select="Sonar/component/measures[metric = 'new_bugs']/periods[index = '1']/value"/>
                                    </a>
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    New Debt [since last analysis]
                                  </td>
                                  <td>
                                    <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false|facetMode=effort|types=CODE_SMELL|sinceLeakPeriod=true">
                                      <xsl:value-of select="Sonar/component/measures[metric = 'new_technical_debt']/periods[index = '1']/value"/>
                                    </a>d
                                  </td>
                                </tr>
                                <tr>
                                  <td>
                                    Total Issues
                                  </td>
                                  <td>
                                    <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false">
                                      <xsl:value-of select="Sonar/component/measures[metric = 'violations']/value"/>
                                    </a>
                                  </td>
                                </tr>
                              </table>
                              <span>
                                Results <a href="{$GDBuildOutput/Tools/Sonar/Output/ToolRunDetails/@ReportURI}">here</a>
                              </span>
                            </td>
                            <td align="center" valign="middle">
                              <xsl:call-template name="StatusImage">
                                <xsl:with-param name="Status" select="$GDBuildOutput/Tools/Sonar/Output/ToolRunDetails/@Status"/>
                              </xsl:call-template>
                            </td>
                            <td valign="middle">
                              <span>
                                <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/Bugs/@Target"/> Bug(s)
                                <br/>
                                <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/Vulnerabilities/@Target"/> Vulnerability
                                <br/>
                                <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/CriticalViolations/@Target"/> CriticalViolation(s)
                                <br/>
                                <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/BlockerViolations/@Target"/> BlockerViolation(s)
                              </span>
                            </td>
                            <td valign="middle" >
                              <span>
                                <xsl:call-template name="ColorAttribute">
                                  <xsl:with-param name="Status" select="$GDBuildOutput/Tools/Sonar/Output/ToolRunDetails/@Status"/>
                                </xsl:call-template>
                                <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false|types=BUG">
                                  <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/Bugs/@Actual"/>
                                </a> Bug(s)
                                <br/>
                                <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false|types=VULNERABILITY">
                                  <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/Vulnerabilities/@Actual"/>
                                </a> Vulnerability
                                <br/>
                                <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false|severities=CRITICAL">
                                  <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/CriticalViolations/@Actual"/>
                                </a> CriticalViolation(s)
                                <br/>
                                <a href="{Sonar/@SonarURL}/component_issues?id={$GDBuildOutput/Tools/Sonar/@Note}#resolved=false|severities=BLOCKER">
                                  <xsl:value-of select="$GDBuildOutput/Tools/Sonar/Output/Metrics/BlockerViolations/@Actual"/>
                                </a> BlockerViolation(s)
                              </span>
                            </td>
                          </tr>
                        </xsl:if>
                      </table>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:if>

          <!--****************************************************************************AutoToolSuggestion Feature ****************************************************-->
          <xsl:variable name="applicableTools" select="GDBuildOutput/Tools/*[@ToolApplicable='true']"/>
          <xsl:if test="count($applicableTools) &gt; 0">
            <tr>
              <td class="noborder">
                <table width="100%" style="text-align: center; font-family:Segoe UI Light; color:#FF9933;" class="noborder">
                  <tr>
                    <td class="noborder">
                      <table width="100%" class="noborder">
                        <tr>
                          <td class="noborder">
                            <span class="header">
                              <br/>ToolIntellisense – Tools that are disabled
                            </span>
                          </td>
                        </tr>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td align="left" valign="top">
                      <table style="text-align:center; font-family:Segoe UI Light; color:black;;border-color:green;" width="100%" cellpadding="2" cellspacing="0" >
                        <tr class="toolsuggest">
                          <td align="center" width="30%">Tool</td>
                          <td align="center" width="30%">Project/File Evidence </td>
                          <td align="center" width="40%">Reasons to disable (if any)</td>
                        </tr>
                        <xsl:for-each select ="GDBuildOutput/Tools/*">
                          <xsl:if test="(@ToolApplicable='true')">
                            <tr>
                              <td>
                                <a href="{@Hlink}">
                                  <xsl:value-of select="name(.)"/>
                                </a>
                              </td>
                              <td>
                                <span class="roundborderFile">
                                  <xsl:value-of select="@Evidence"/>
                                </span>
                              </td>
                              <td>
                                <xsl:value-of select="@ToolDisabledReason"/>
                              </td>
                            </tr>
                          </xsl:if>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                  <tr>
                    <td class="roundbackgroundProject" style="background-color:#F5D0A9">
                      Enable tool(s) in <a href="http://aka.ms/ESDevOpsCIConfig">CIConfig</a> and add appropriate tool(s) task in build definition. User remarks can be provided in the ToolDisabledReason field of corresponding tool section in CIConfig.
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
          </xsl:if>
          
          <tr>
            <td class="noborder">
              <table align="center" width="100%" cellpadding="5" cellspacing="0">
                <xsl:if test="($GDBuildOutput/Tools/FxCop_Project/@Enabled = 'true') or ($GDBuildOutput/Tools/CodeAnalysisSuppressions/@Enabled = 'true') or ($GDBuildOutput/Tools/Stylecop/@Enabled = 'true') or ($GDBuildOutput/Tools/JSLintNET/@Enabled = 'true') or ($GDBuildOutput/Tools/TSLint/@Enabled = 'true') or ($GDBuildOutput/Tools/RoslynCAAnalyzer/@Enabled = 'true') ">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/> Microsoft Visual Studio Static Analysis Team Tools
                      </span>
                    </td>
                  </tr>

                  <!--****************************************************************************Tools****************************************************-->

                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Tool Name
                          </td>
                          <td width="43.5%">
                            Remarks
                          </td>
                          <td width="5%">
                            Status
                          </td>
                          <td width="17%">
                            Target
                          </td>
                          <td width="17%">
                            Actual
                          </td>
                        </tr>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'FXCOP') and ($GDBuildOutput/Tools/FxCop_Project/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/FxCop_Project/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/FxcopReport_Project.htm">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/FxCop_Project/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/Output/Metrics/FxcopProjectErrors/@Target"/> Error(s)
                                    </span>
                                    <br/>
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/Output/Metrics/FxcopProjectWarnings/@Target"/>  Warning(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/FxCop_Project/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/Output/Metrics/FxcopProjectExceptions/@Actual"/> Tool Failure Exception(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/Output/Metrics/FxcopProjectErrors/@Actual"/> Error(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCop_Project/Output/Metrics/FxcopProjectWarnings/@Actual"/> Warning(s)
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/FxCop_Project/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>
                                    <xsl:choose>
                                      <xsl:when test="($GDBuildOutput/Tools/FxCop_Project/Output/ToolRunDetails/@ExitCode = 2)">
                                        <div class="ui-widget">
                                          <div class="ui-state-error" style="padding: 0 .7em;">
                                            <p>
                                              <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
                                              <a href="{$GDBuildOutput/DynamicConfigOutput/BuildRunSummary/ReportsLocation}/AdvancedBuildReport.xml" style="text-decoration: none;color: #ffffff">
                                                <strong>Alert: </strong>Please enable Code Analysis in atleast one VS project. <strong>
                                                </strong>
                                              </a>
                                            </p>
                                          </div>
                                        </div>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:call-template name="AlertExitCode">
                                          <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/FxCop_Project/Output/ToolRunDetails/@ExitCode"/>
                                        </xsl:call-template>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                        
                        <xsl:if test="$GDBuildOutput/Tools/RoslynCAAnalyzer/@Enabled = 'true'">
                          <tr>
                            <td style="width: 200px;text-align: center;" class="colored" valign="top">
                              <a href="{$GDBuildOutput/Tools/RoslynCAAnalyzer/@Hlink}">
                                <xsl:value-of select="$GDBuildOutput/Tools/RoslynCAAnalyzer/@DisplayName"/>
                              </a>
                              <br/>
                              <span class="subtext">
                                [<xsl:value-of select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Description"/>]
                              </span>
                            </td>
                            <td>
                              <span>
                                Roslyn CA Analyzer Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/ToolRunDetails/@ReportURI}">here</a>
                              </span>
                            </td>
                            <td align="center" valign="middle">
                              <xsl:call-template name="StatusImage">
                                <xsl:with-param name="Status" select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/ToolRunDetails/@Status"/>
                              </xsl:call-template>
                            </td>
                            <td valign="middle">
                              <span>
                                <xsl:value-of select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/Metrics/Metric/@Target"/> Violation(s)
                              </span>
                            </td>
                            <td valign="middle">
                              <span>
                                <xsl:call-template name="ColorAttribute">
                                  <xsl:with-param name="Status" select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/ToolRunDetails/@Status"/>
                                </xsl:call-template>
                                <xsl:value-of select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/Metrics/Metric/@Actual"/> Error(s)
                                <br />
                                <xsl:value-of select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/Metrics/Metric/@ActualWarnings"/> Warning(s)
                              </span>
                              <xsl:if test="($GDBuildOutput/Tools/RoslynCAAnalyzer/Output/ToolRunDetails/@ExitCode != 0)">
                                <xsl:call-template name="AlertExitCode">
                                  <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/RoslynCAAnalyzer/Output/ToolRunDetails/@ExitCode"/>
                                </xsl:call-template>
                              </xsl:if>
                            </td>
                          </tr>
                        </xsl:if>
                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'CODEANALYSISSUPPRESSIONS') and ($GDBuildOutput/Tools/CodeAnalysisSuppressions/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/CodeAnalysisSuppressions/@Hlink}">
                                      Global Code Analysis Suppressions
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <xsl:choose>
                                      <xsl:when test="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/ToolRunDetails/@ReportURI != ''">
                                        <xsl:value-of select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/@DisplayName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/ToolRunDetails/@ReportURI}">here</a>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:call-template name="ReportNotAvailable"/>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:call-template name="ParseError">
                                      <xsl:with-param name="ErrorDesc" select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/ToolRunDetails/@ParseError" />
                                    </xsl:call-template>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/Metrics/CodeAnalysisSuppressions/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/Metrics/CodeAnalysisSuppressions/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertExitCode">
                                      <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/CodeAnalysisSuppressions/Output/ToolRunDetails/@ExitCode"/>
                                    </xsl:call-template>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'STYLECOP') and ($GDBuildOutput/Tools/Stylecop/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/Stylecop/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/Stylecop/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/Stylecop/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/StyleCopViolations.htm">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/Stylecop/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/Stylecop/Output/Metrics/StylecopViolation/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/Stylecop/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/Stylecop/Output/Metrics/StylecopViolation/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/Stylecop/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/Stylecop/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'JSLINTNET') and ($GDBuildOutput/Tools/JSLintNET/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/JSLintNET/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/JSLintNET/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/JSLintNET/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/JSLint.Net.html">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/JSLintNET/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/JSLintNET/Output/Metrics/Warnings/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/JSLintNET/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/JSLintNET/Output/Metrics/Warnings/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/JSLintNET/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/JSLintNET/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'TSLINT') and ($GDBuildOutput/Tools/TSLint/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/TSLint/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/TSLint/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/TSLint/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/TSLintReport.htm">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/TSLint/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/TSLint/Output/Metrics/TSLintViolations/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/TSLint/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/TSLint/Output/Metrics/TSLintViolations/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/TSLint/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/TSLint/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
                <xsl:if test="($GDBuildOutput/Tools/CredScan/@Enabled = 'true') or ($GDBuildOutput/Tools/ModernCop/@Enabled = 'true') or ($GDBuildOutput/Tools/BinSkim/@Enabled = 'true') or ($GDBuildOutput/Tools/BINSCOPE/@Enabled = 'true') or ($GDBuildOutput/Tools/FxCopSDL/@Enabled = 'true') or ($GDBuildOutput/Tools/Fortify/@Enabled = 'true') or ($GDBuildOutput/Tools/RoslynAnalyzers/@Enabled = 'true')">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/> Secure Development Tools
                      </span>
                    </td>
                  </tr>
                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Tool Name
                          </td>
                          <td width="43.5%">
                            Remarks
                          </td>
                          <td width="5%">
                            Status
                          </td>
                          <td width="17%">
                            Target
                          </td>
                          <td width="17%">
                            Actual
                          </td>
                        </tr>
                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($GDBuildOutput/Tools/Fortify/@Enabled = 'true') and ($ToolName = 'FORTIFY')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/Fortify/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/Fortify/@DisplayName"/>*
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/Fortify/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      ServicesFortify Analysis Results <a href="https://servicesfortify/ssc/html/ssc/index.jsp#!/dashboard/Chart">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="result"/>
                                    </xsl:call-template>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'Run ')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(name,'Run '),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'CREDSCAN') and ($GDBuildOutput/Tools/CredScan/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/CredScan/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/CredScan/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/CredScan/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/CredScan/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                    <br>Guidance to remediate the violations</br> <a href="https://aka.ms/AzSecretsMgmt">here</a>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CredScan/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/CredScan/Output/Metrics/Metric/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CredScan/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/CredScan/Output/Metrics/Metric/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/CredScan/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/CredScan/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'Run ')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(name,'Run '),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'MODERNCOP') and ($GDBuildOutput/Tools/ModernCop/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/ModernCop/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/ModernCop/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/ModernCop/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/ModernCop/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/ModernCop/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ModernCop/Output/Metrics/Metric/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/ModernCop/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ModernCop/Output/Metrics/Metric/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/ModernCop/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/ModernCop/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'Run ')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(name,'Run '),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'BINSKIM ') and ($GDBuildOutput/Tools/BinSkim/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/BinSkim/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/BinSkim/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/BinSkim/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/BinSkim/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/BinSkim/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/BinSkim/Output/Metrics/Metric/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/BinSkim/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/BinSkim/Output/Metrics/Metric/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/BinSkim/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/BinSkim/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                        
                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'Run ')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(name,'Run '),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'ROSLYN ANALYZERS') and ($GDBuildOutput/Tools/RoslynAnalyzers/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/RoslynAnalyzers/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/RoslynAnalyzers/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/RoslynAnalyzers/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/RoslynAnalyzers/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/RoslynAnalyzers/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/RoslynAnalyzers/Output/Metrics/Metric/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/RoslynAnalyzers/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/RoslynAnalyzers/Output/Metrics/Metric/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/RoslynAnalyzers/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/RoslynAnalyzers/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'BINSCOPE') and ($GDBuildOutput/Tools/BINSCOPE/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/BINSCOPE/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/BINSCOPE/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/BINSCOPE/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/BINSCOPE/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/BINSCOPE/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/BINSCOPE/Output/Metrics/BinScopeViolation/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/BINSCOPE/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/BINSCOPE/Output/Metrics/BinScopeViolation/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/BINSCOPE/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>
                                    <xsl:if test="($GDBuildOutput/Tools/BINSCOPE/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/BINSCOPE/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'FXCOPFORSDL') and ($GDBuildOutput/Tools/FxCopSDL/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/FxCopSDL/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCopSDL/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/FxCopSDL/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/FxcopReport_SDL.htm">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/FxCopSDL/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCopSDL/Output/Metrics/FxcopSDLProjectErrors/@Target"/> Error(s)
                                    </span>
                                    <br/>
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCopSDL/Output/Metrics/FxcopSDLProjectWarnings/@Target"/>  Warning(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/FxCopSDL/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCopSDL/Output/Metrics/FxcopSDLProjectErrors/@Actual"/> Error(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/FxCopSDL/Output/Metrics/FxcopSDLProjectWarnings/@Actual"/> Warning(s)
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/FxCopSDL/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>

                                    <xsl:if test="($GDBuildOutput/Tools/FxCopSDL/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/FxCopSDL/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
                <xsl:if test="($GDBuildOutput/Tools/SQLStaticCodeAnalysis/@Enabled = 'true') or ($GDBuildOutput/Tools/POLICHECK/@Enabled = 'true') or ($GDBuildOutput/Tools/ISGCERTIFICATION/@Enabled = 'true') or ($GDBuildOutput/Tools/CODEMETRICS/@Enabled = 'true') or ($GDBuildOutput/Tools/SafeNuget/@Enabled = 'true') or ($GDBuildOutput/Tools/SecSharp/@Enabled = 'true') or ($GDBuildOutput/Tools/SHAREPOINTDISPOSE/@Enabled = 'true') or ($GDBuildOutput/Tools/MSOCAF/@Enabled = 'true') or ($GDBuildOutput/Tools/SdnPackageAnalyzer/@Enabled = 'true') ">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/> Quality Tools
                      </span>
                    </td>
                  </tr>
                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Tool Name
                          </td>
                          <td width="43.5%">
                            Remarks
                          </td>
                          <td width="5%">
                            Status
                          </td>
                          <td width="17%">
                            Target
                          </td>
                          <td width="17%">
                            Actual
                          </td>
                        </tr>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'SQLCOP') and ($GDBuildOutput/Tools/SQLStaticCodeAnalysis/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/SQLStaticCodeAnalysis/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/Metrics/SqlcopErrors/@Target"/> Error(s)
                                    </span>
                                    <br/>
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/Metrics/SqlcopWarnings/@Target"/>  Warning(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/Metrics/SqlcopErrors/@Actual"/> Error(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/Metrics/SqlcopWarnings/@Actual"/> Warning(s)
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>

                                    <xsl:if test="($GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/SQLStaticCodeAnalysis/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'Run ')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(name,'Run '),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'POLICHECK') and ($GDBuildOutput/Tools/POLICHECK/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/POLICHECK/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/POLICHECK/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/POLICHECK/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/POLICHECK/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/POLICHECK/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/POLICHECK/Output/Metrics/PoliCheckWarnings/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/POLICHECK/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/POLICHECK/Output/Metrics/PoliCheckWarnings/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/POLICHECK/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/POLICHECK/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'ISGCERTIFICATION') and ($GDBuildOutput/Tools/ISGCERTIFICATION/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/@DisplayName"/>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <table width="100%">
                                      <tr>
                                        <td align="left" valign="top">
                                          <table class="minutetext">
                                            <tr class="bgcolored" >
                                              <td align="center">Assembly Name</td>
                                              <td align="center">File </td>
                                              <td align="center">Assembly </td>
                                              <td align="center">Signing </td>
                                            </tr>
                                            <tr class="bgcolored" >
                                              <td align="center"></td>
                                              <td align="center">Version </td>
                                              <td align="center">Version </td>
                                              <td align="center">Status </td>
                                            </tr>
                                            <xsl:for-each select ="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/CMPTResults/Result">
                                              <tr>
                                                <td>
                                                  <xsl:value-of select="FileName"/>
                                                </td>
                                                <td>
                                                  <xsl:value-of select="FileVersionValue"/>
                                                </td>
                                                <td>
                                                  <xsl:value-of select="AssemblyVersionValue"/>
                                                </td>
                                                <td>
                                                  <xsl:choose>
                                                    <xsl:when test="SigningStatusValue= 'Fully signed'">
                                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                                    </xsl:otherwise>
                                                  </xsl:choose>
                                                  <xsl:value-of select="SigningStatusValue"/>
                                                </td>
                                              </tr>
                                            </xsl:for-each>
                                          </table>

                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                          Assembly Versioning &amp; Signing  &#160; Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/ISGCERTIFICATION/Output/ToolRunDetails/@ReportURI}">here</a>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationUnsignedAssemblies/@Target"/> Unsigned Assemblies
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationPartiallySignedAssemblies/@Target"/>  Partially Signed Assemblies
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationDuplicateFiles/@Target"/>  Duplicate File(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationFileVerMismatch/@Target"/>  File(s) Version Mismatch
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationUnsignedAssemblies/@Actual"/> Unsigned Assemblies
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationPartiallySignedAssemblies/@Actual"/>  Partially Signed Assemblies
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationDuplicateFiles/@Actual"/>  Duplicate File(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/Metrics/ISGCertificationFileVerMismatch/@Actual"/>  File(s) Version Mismatch
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>
                                    <xsl:if test="($GDBuildOutput/Tools/ISGCERTIFICATION/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/ISGCERTIFICATION/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'CODEMETRICS') and ($GDBuildOutput/Tools/CODEMETRICS/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/CODEMETRICS/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <table border="0" >
                                      <tr>
                                        <td align="left" valign="top">
                                          <table border="0"  class="subtext" >
                                            <tr class="bgcolored">
                                              <td align="Center">
                                                Module Name
                                              </td>
                                              <td>
                                                Maintainability Index
                                              </td>
                                              <td>
                                                Cyclomatic Complexity
                                              </td>
                                              <td>
                                                Class Coupling
                                              </td>
                                              <td>
                                                Depth Of Inheritance
                                              </td>
                                              <td>
                                                Lines Of Code
                                              </td>
                                              <td>
                                                Violations
                                              </td>
                                            </tr>
                                            <xsl:for-each  select="$GDBuildOutput/Tools/CODEMETRICS/Output/CMPTResults/Result">
                                              <tr>
                                                <td align="left" style="max-width:140px;overflow: hidden;word-wrap: break-word">
                                                  <xsl:value-of select="ModuleName"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="MaintainabilityIndexValue"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="CyclomaticComplexityValue"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="ClassCouplingValue"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="DepthOfInheritanceValue"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="LinesOfCodeValue"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="Violations"/>
                                                </td>
                                              </tr>
                                            </xsl:for-each>
                                            <tr bgcolor="#f0f0f0" style="color: #007ACC;">
                                              <td align="right" style="border-color:white">
                                                Actual Violations
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/MaintainabilityIndex/@Actual"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CyclomaticComplexity/@Actual"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/ClassCoupling/@Actual"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/DepthOfInheritance/@Actual"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/LinesOfCode/@Actual"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CodemetricsViloation/@Actual"/>
                                              </td>
                                            </tr>
                                            <tr bgcolor="#f0f0f0" style="color: #007ACC;">
                                              <td align="right" style="border-color:white">
                                                Violations Target
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/MaintainabilityIndex/@Target"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CyclomaticComplexity/@Target"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/ClassCoupling/@Target"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/DepthOfInheritance/@Target"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/LinesOfCode/@Target"/>
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CodemetricsViloation/@Target"/>
                                              </td>
                                            </tr>
                                            <tr bgcolor="#f0f0f0" style="color: #007ACC;">
                                              <td align="right" style="border-color:white">
                                                % of Methods/Classes in Range
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/MaintainabilityIndex/@Percentage"/>%
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CyclomaticComplexity/@Percentage"/>%
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/ClassCoupling/@Percentage"/>%
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/DepthOfInheritance/@Percentage"/>%
                                              </td>
                                              <td align="center" style="border-color:white">
                                                <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/LinesOfCode/@Percentage"/>%
                                              </td>
                                              <td></td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>

                                      <tr>
                                        <td style="color:#007ACC">
                                          <strong>
                                            <u>Criteria:</u>
                                          </strong>
                                          <br/>
                                          <font size="2px">
                                            Maintainability Index per method >  <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/ViloationCriteria/MaintainabilityIndex/@GreaterThan"/> <br/>
                                            Cyclomatic Complexity per method &lt;= <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/ViloationCriteria/CyclomaticComplexity/@LessThanOREqual"/><br/>
                                            Class Coupling per class or type &lt;= <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/ViloationCriteria/ClassCoupling/@LessThanOREqual"/><br/>
                                            Depth Of Inheritance per class or type &lt;= <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/ViloationCriteria/DepthOfInheritance/@LessThanOREqual"/><br/>
                                            Lines of code per method &lt;= <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/ViloationCriteria/LinesOfCode/@LessThanOREqual"/>
                                          </font>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                          <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/CodeMetricsReport.htm">here</a>
                                          <br/>
                                          <font size="1px">
                                            <u>Note:</u> If report is not rendered properly in IE, then go to Internet options -> Compatibility View Settings -> Add (default TFS url would be shown)
                                          </font>
                                        </td>
                                      </tr>
                                      <xsl:if test="$GDBuildOutput/Tools/CODEMETRICS/Output/FailureDiagnosticsHelp/Entry/@Severity = 'error'" >
                                        <tr>
                                          <td style="color:#F45A16">
                                            <br/>
                                            <span style="color:#D11141"> Self Diagnostics:</span>
                                            <table border="0"  class="subtext" width="100%" background="rgb(250, 104, 0)">
                                              <tr class="bgcoloredDiagnostics">
                                                <td align="Center">
                                                  Severity
                                                </td>
                                                <td align="Center">
                                                  File Name
                                                </td>
                                                <td align="Center">
                                                  Reason
                                                </td>
                                                <td align="Center">
                                                  Resolution Hint
                                                </td>
                                              </tr>
                                              <xsl:for-each  select="$GDBuildOutput/Tools/CODEMETRICS/Output/FailureDiagnosticsHelp/Entry">
                                                <tr>
                                                  <td align="center">
                                                    <xsl:choose>
                                                      <xsl:when test="@Severity = 'error'">
                                                        <xsl:attribute name="style">color:red</xsl:attribute>
                                                        Error
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                        <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                                        <xsl:value-of select="@Severity"/>
                                                      </xsl:otherwise>
                                                    </xsl:choose>
                                                  </td>
                                                  <td align="left">
                                                    <xsl:value-of select="@Name"/>
                                                  </td>
                                                  <td align="center">
                                                    <xsl:value-of select="@Reason"/>
                                                  </td>
                                                  <td align="center">
                                                    <xsl:value-of select="@Resolution"/>
                                                  </td>
                                                </tr>
                                              </xsl:for-each>
                                            </table>
                                          </td>
                                        </tr>
                                      </xsl:if>
                                    </table>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CODEMETRICS/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CodemetricsViloation/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle" >
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CODEMETRICS/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/CODEMETRICS/Output/Metrics/CodemetricsViloation/@Actual"/> Violation(s)
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/CODEMETRICS/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>
                                    <xsl:if test="($GDBuildOutput/Tools/CODEMETRICS/Output/ToolRunDetails/@ExitCode != 0)">
                                      <a href="{$GDBuildOutput/Tools/CODEMETRICS/@Hlink}">
                                        <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/CODEMETRICS/Output/ToolRunDetails/@ExitCode"/>
                                        </xsl:call-template>
                                      </a>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'SAFENUGET') and ($GDBuildOutput/Tools/SafeNuget/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <xsl:value-of select="$GDBuildOutput/Tools/SafeNuget/@DisplayName"/>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/SafeNuget/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <table border="0" >
                                      <xsl:if test="$GDBuildOutput/Tools/SafeNuget/Output/Metrics/SafeNugetViolations/@Actual != 0">
                                        <tr>
                                          <td align="left" valign="top">

                                            <table border="0"  class="subtext" >
                                              <tr class="bgcolored">
                                                <td align="Center">
                                                  Project Name
                                                </td>
                                                <td>
                                                  Vulnerability Count
                                                </td>
                                              </tr>

                                              <xsl:for-each  select="$GDBuildOutput/Tools/SafeNuget/Output/CMPTResults/Result">
                                                <tr>
                                                  <td align="left" style="max-width:140px;overflow: hidden;word-wrap: break-word">
                                                    <xsl:value-of select="ProjectName"/>
                                                  </td>
                                                  <td align="center">
                                                    <xsl:value-of select="VulnerabilityCount"/>
                                                  </td>
                                                </tr>
                                              </xsl:for-each>
                                            </table>
                                          </td>
                                        </tr>
                                      </xsl:if>
                                      <tr>
                                        <td>
                                          <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$ToolName}.xml">here</a>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SafeNuget/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SafeNuget/Output/Metrics/SafeNugetViolations/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle" >
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SafeNuget/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SafeNuget/Output/Metrics/SafeNugetViolations/@Actual"/> Violation(s)
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/SafeNuget/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/SafeNuget/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'SECSHARP') and ($GDBuildOutput/Tools/SecSharp/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <xsl:value-of select="$GDBuildOutput/Tools/SecSharp/@DisplayName"/>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/SecSharp/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <table border="0" width="100%"  >
                                      <xsl:if test="$GDBuildOutput/Tools/SecSharp/Output/Metrics/Metric[@Name='TotalViolations']/@Actual != 0">
                                        <tr>
                                          <td align="left" valign="top">

                                            <table border="0"  class="subtext" width="100%" >
                                              <tr class="bgcolored">
                                                <td align="Center" width="25%">
                                                  Rule Id
                                                </td>
                                                <td  align="Center" width="25%">
                                                  Category
                                                </td>
                                                <td align="Center" style="word-wrap: break-word">
                                                  Target Violations
                                                </td>
                                                <td align="Center" style="word-wrap: break-word">
                                                  Actual Violations
                                                </td>
                                              </tr>

                                              <xsl:for-each  select="$GDBuildOutput/Tools/SecSharp/Output/SecSharpResults/Result">
                                                <tr>
                                                  <td align="Center">
                                                    <xsl:value-of select="RuleId"/>
                                                  </td>
                                                  <td align="Center">
                                                    <xsl:value-of select="Category"/>
                                                  </td>
                                                  <td align="center">
                                                    <xsl:variable name="TargetViolations" select="Target"/>
                                                    <xsl:choose>
                                                      <xsl:when test="$TargetViolations!=''">
                                                        <xsl:value-of select="Target"/>
                                                      </xsl:when>
                                                      <xsl:otherwise>
                                                        0
                                                      </xsl:otherwise>
                                                    </xsl:choose>
                                                  </td>
                                                  <td align="center">
                                                    <xsl:value-of select="Violations"/>
                                                  </td>
                                                </tr>
                                              </xsl:for-each>
                                            </table>
                                          </td>
                                        </tr>
                                      </xsl:if>
                                      <tr>
                                        <td>
                                          <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$ToolName}.htm">here</a>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SecSharp/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SecSharp/Output/Metrics/Metric[@Name='TotalViolations']/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle" >
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SecSharp/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SecSharp/Output/Metrics/Metric[@Name='TotalViolations']/@Actual"/> Violation(s)
                                      <xsl:if test="($GDBuildOutput/Tools/SecSharp/Output/ToolRunDetails/@ExitCode != 0)">
                                        <xsl:call-template name="AlertExitCode">
                                          <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/SecSharp/Output/ToolRunDetails/@ExitCode"/>
                                        </xsl:call-template>
                                      </xsl:if>
                                    </span>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'SHAREPOINTDISPOSE') and ($GDBuildOutput/Tools/SHAREPOINTDISPOSE/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/SHAREPOINTDISPOSE/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/Metrics/SPDisposeCheckViolation/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/Metrics/SPDisposeCheckViolation/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:call-template name="AlertAssemblyLoadFailure">
                                      <xsl:with-param name="Count" select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/ToolRunDetails/@AssemblyLoadFailures"/>
                                    </xsl:call-template>
                                    <xsl:if test="($GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/SHAREPOINTDISPOSE/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'MSOCAF') and ($GDBuildOutput/Tools/MSOCAF/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/MSOCAF/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <table border="0" >
                                      <tr>
                                        <td align="left" valign="top">
                                          <table border="0"  class="subtext" >
                                            <tr class="bgcolored">
                                              <td  colspan="2" align="Center"> Package </td>
                                              <td colspan="5" align="Center">Rules</td>
                                              <td colspan="5" align="Center">Violations</td>
                                            </tr>
                                            <tr class="bgcolored">
                                              <td align="Center">
                                                Name
                                              </td>
                                              <td  align="Center">
                                                Extraction
                                              </td>
                                              <td>
                                                Run
                                              </td>
                                              <td>
                                                Passed
                                              </td>
                                              <td>
                                                Warned
                                              </td>
                                              <td>
                                                Failed
                                              </td>
                                              <td>
                                                Excep
                                              </td>
                                              <td>
                                                Err
                                              </td>
                                              <td>
                                                Warn
                                              </td>
                                              <td>
                                                Excep
                                              </td>
                                              <td>
                                                Result
                                              </td>
                                              <td>
                                                Pass%
                                              </td>
                                            </tr>
                                            <xsl:for-each  select="$GDBuildOutput/Tools/MSOCAF/Output/MSOCAFResults/Result">
                                              <tr>
                                                <td align="left" style="max-width:140px;overflow: hidden;word-wrap: break-word">
                                                  <xsl:value-of select="PackageName"/>
                                                </td>
                                                <td align="center" >
                                                  <xsl:choose>
                                                    <xsl:when test="PackageExtractionSummary = 'ExtractionSuccessful'">
                                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                                      <xsl:value-of select="PackageExtractionSummary"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>

                                                      <xsl:value-of select="PackageExtractionSummary"/>

                                                    </xsl:otherwise>
                                                  </xsl:choose>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="RulesRun"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="RulesPassed"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="RulesWarned"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="RulesFailed"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="RulesException"/>
                                                </td>

                                                <td align="center">
                                                  <xsl:value-of select="Errors"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="Warnings"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:value-of select="Exceptions"/>
                                                </td>
                                                <td align="center">
                                                  <xsl:choose>
                                                    <xsl:when test="Result = 'Fail'">
                                                      <xsl:attribute name="style">color:red</xsl:attribute>
                                                      <xsl:value-of select="Result"/>
                                                    </xsl:when>
                                                    <xsl:when test="Result = 'Pass'">
                                                      <xsl:attribute name="style">color:green</xsl:attribute>
                                                      <xsl:value-of select="Result"/>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                      <xsl:attribute name="style">color:#FF9933</xsl:attribute>
                                                      <xsl:value-of select="Result"/>
                                                    </xsl:otherwise>
                                                  </xsl:choose>
                                                </td>

                                                <td align="center">
                                                  <xsl:value-of select="PassPercentage"/>
                                                </td>
                                              </tr>
                                            </xsl:for-each>
                                          </table>
                                        </td>
                                      </tr>
                                      <tr>
                                        <td>
                                          <xsl:choose>
                                            <xsl:when test="$GDBuildOutput/Tools/MSOCAF/Output/ToolRunDetails/@ReportURI != ''">
                                              <Table style="width:100%">
                                                <tr>
                                                  <td>
                                                    <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/@DisplayName"/> Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/MSOCAF/Output/ToolRunDetails/@ReportURI}">here</a>
                                                  </td>
                                                  <td style="text-align:center">
                                                    <xsl:if test="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFExceptions/@Actual > 0">
                                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/@DisplayName"/> Exception Report <a href="{$ReportsLocation}\Caf Reports\CafReport.CAFException.xml">here</a>
                                                    </xsl:if>
                                                  </td>
                                                </tr>
                                              </Table>
                                            </xsl:when>
                                            <xsl:otherwise>
                                              <xsl:call-template name="ReportNotAvailable"/>
                                            </xsl:otherwise>
                                          </xsl:choose>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/MSOCAF/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFErrors/@Target"/> Error(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFWarnings/@Target"/> Warning(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFExceptions/@Target"/> Exceptions(s)
                                    </span>
                                  </td>
                                  <td valign="middle" >
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/MSOCAF/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFErrors/@Actual"/> Error(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFWarnings/@Actual"/> Warning(s)
                                      <br/>
                                      <xsl:value-of select="$GDBuildOutput/Tools/MSOCAF/Output/Metrics/MSOCAFExceptions/@Actual"/> Exception(s)
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/MSOCAF/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/MSOCAF/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>

                        <!-- SDNPACKAGEANALYZER Tool-->
                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'SDNPACKAGEANALYZER') and ($GDBuildOutput/Tools/SdnPackageAnalyzer/@Enabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SdnPackageAnalyzer/@DisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/SdnPackageAnalyzer/Description"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      <xsl:value-of select="$ToolName"/> Results <a href="{$ReportsLocation}/Nuget_Discrepancies.htm">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SdnPackageAnalyzer/Output/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SdnPackageAnalyzer/Output/Metrics/SdnPackageDiscrepancies/@Target"/> Violation(s)
                                    </span>
                                  </td>
                                  <td valign="middle">
                                    <span>
                                      <xsl:call-template name="ColorAttribute">
                                        <xsl:with-param name="Status" select="$GDBuildOutput/Tools/SdnPackageAnalyzer/Output/ToolRunDetails/@Status"/>
                                      </xsl:call-template>
                                      <xsl:value-of select="$GDBuildOutput/Tools/SdnPackageAnalyzer/Output/Metrics/SdnPackageDiscrepancies/@Actual"/> Violation(s)
                                      <br />
                                    </span>
                                    <xsl:if test="($GDBuildOutput/Tools/SdnPackageAnalyzer/Output/ToolRunDetails/@ExitCode != 0)">
                                      <xsl:call-template name="AlertExitCode">
                                        <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/SdnPackageAnalyzer/Output/ToolRunDetails/@ExitCode"/>
                                      </xsl:call-template>
                                    </xsl:if>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
                <xsl:if test="(GDBuildOutput/Tools/TelemetryScanner/@AIEnabled='true') or (GDBuildOutput/Tools/TelemetryScanner/@HockeyAppEnabled='true')">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/> Telemetry Practices
                      </span>
                    </td>
                  </tr>
                  <tr>
                    <td class="noborder">
                      <table align="center" width="100%" cellpadding="5" cellspacing="0">
                        <tr style="text-align: center; " class="bgcolored" >
                          <td style="width: 200px;">
                            Telemetry Scanner
                          </td>
                          <td width="43.5%">
                            Report
                          </td>
                          <td width="5%">
                            Result
                          </td>
                        </tr>
                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'AISCANNER') and ($GDBuildOutput/Tools/TelemetryScanner/@AIEnabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/TelemetryScanner/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/TelemetryScanner/@AIDisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/TelemetryScanner/AIDescription"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/TelemetryScanner/AIOutput/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:variable name="Status" select="$GDBuildOutput/Tools/TelemetryScanner/AIOutput/ToolRunDetails/@Status" />
                                    <xsl:choose>
                                      <xsl:when test="$Status='Failed' or $Status= 'failed' or $Status='NA'" >
                                        NA/Application Insights Not Enabled
                                      </xsl:when>
                                      <xsl:otherwise>
                                        Application Insights Enabled
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/TelemetryScanner/AIOutput/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each  select="GetBuildDetails/records">
                          <xsl:choose>
                            <xsl:when test="starts-with(name, 'T-')" >
                              <xsl:variable name="ToolName" select="translate(substring-after(substring-before(name,':'),'-'),'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
                              <xsl:if test="($ToolName = 'AISCANNER') and ($GDBuildOutput/Tools/TelemetryScanner/@HockeyAppEnabled = 'true')">
                                <tr>
                                  <td style="width: 200px;text-align: center;" class="colored" valign="top">
                                    <a href="{$GDBuildOutput/Tools/TelemetryScanner/@Hlink}">
                                      <xsl:value-of select="$GDBuildOutput/Tools/TelemetryScanner/@HADisplayName"/>
                                    </a>
                                    <br/>
                                    <span class="subtext">
                                      [<xsl:value-of select="$GDBuildOutput/Tools/TelemetryScanner/HADescription"/>]
                                    </span>
                                  </td>
                                  <td>
                                    <span>
                                      Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/TelemetryScanner/HAOutput/ToolRunDetails/@ReportURI}">here</a>
                                    </span>
                                  </td>
                                  <td align="center" valign="middle">
                                    <xsl:variable name="Status" select="$GDBuildOutput/Tools/TelemetryScanner/HAOutput/ToolRunDetails/@Status" />
                                    <xsl:choose>
                                      <xsl:when test="$Status='Failed' or $Status= 'failed' or $Status='NA'" >
                                        NA/HockeyApp Not Enabled
                                      </xsl:when>
                                      <xsl:otherwise>
                                        HockeyApp Enabled
                                      </xsl:otherwise>
                                    </xsl:choose>
                                    <xsl:call-template name="StatusImage">
                                      <xsl:with-param name="Status" select="$GDBuildOutput/Tools/TelemetryScanner/HAOutput/ToolRunDetails/@Status"/>
                                    </xsl:call-template>
                                  </td>
                                </tr>
                              </xsl:if>
                            </xsl:when>
                          </xsl:choose>
                        </xsl:for-each>
                      </table>
                    </td>
                  </tr>
                </xsl:if>

                <br/>
                <!--**************************************************************CRM Deployment****************************************************************************-->
                <xsl:if test="$GDBuildOutput/Tools/CRMDeployment/@Enabled='true'">
                  <span class="header">
                    <xsl:value-of select="$GDBuildOutput/Tools/CRMDeployment/@DisplayName"/>
                  </span>
                  <table align="center" width="100%" cellpadding="5" cellspacing="0">
                    
                    <tr class="bgcolored" style="text-align: center; " >
                      <td style="width: 200px;">
                        Description
                      </td>
                      <td width="43.5%">
                        Remarks
                      </td>
                      <td width="5%">
                        Status
                      </td>
                      <td width="17%">
                        Target
                      </td>
                      <td width="17%">
                        Achieved
                      </td>
                    </tr>
                    <tr>
                      <td style="width: 200px;text-align: right;" class="colored" valign="top">
                        <span class="subtext">
                          [<xsl:value-of select="$GDBuildOutput/Tools/CRMDeployment/Description"/>]
                        </span>
                      </td>

                      <td width="40%">
                        <xsl:if test="$GDBuildOutput/Tools/CRMDeployment/InputArguments/Add[@ShowInReport = 'true']">
                          <strong style="color:#007ACC">
                            <u>Input Arguments:</u>
                          </strong>
                          <table border="0"  class="subtext" >
                            <xsl:for-each  select="$GDBuildOutput/Tools/CRMDeployment/InputArguments/Add[@ShowInReport = 'true']">
                              <tr>
                                <td style="width:170px;text-align: right; " class="bgcolored">
                                  <xsl:value-of select ="@Key"></xsl:value-of>
                                </td>
                                <td>
                                  <xsl:value-of select ="@Value"/>
                                </td>
                              </tr>
                            </xsl:for-each>
                          </table>
                          <br/>
                        </xsl:if>
                        <xsl:choose>
                          <xsl:when test="$GDBuildOutput/Tools/CRMDeployment/Output/ToolRunDetails/@ReportURI != ''">
                            <xsl:value-of select="$GDBuildOutput/Tools/CRMDeployment/@DisplayName"/> Log <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/CRMDeployment/Output/ToolRunDetails/@ReportURI}">here</a>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:call-template name="ReportNotAvailable"/>
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:call-template name="ParseError">
                          <xsl:with-param name="ErrorDesc" select="$GDBuildOutput/Tools/CRMDeployment/Output/ToolRunDetails/@ParseError" />
                        </xsl:call-template>
                      </td>
                      <td align="center" valign="middle">
                        <xsl:call-template name="StatusImage">
                          <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CRMDeployment/Output/ToolRunDetails/@Status"/>
                        </xsl:call-template>
                      </td>
                      <td valign="middle">
                        <span>
                          Exit Code : 0
                          <br/>
                          <xsl:choose>
                            <xsl:when test="$GDBuildOutput/Tools/CRMDeployment/Output/WarningsCount/@Target != ''">
                              Warning(s): <xsl:value-of select="$GDBuildOutput/Tools/CRMDeployment/Output/WarningsCount/@Target"/>
                            </xsl:when>
                            <xsl:otherwise>
                              Warning(s): 0
                            </xsl:otherwise>
                          </xsl:choose>

                        </span>
                      </td>
                      <td valign="middle">
                        <span>
                          <xsl:call-template name="ColorAttribute">
                            <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CRMDeployment/Output/ToolRunDetails/@Status"/>
                          </xsl:call-template>
                          Exit Code : <xsl:value-of select="$GDBuildOutput/Tools/CRMDeployment/@Note"/>
                          <br/>
                          Warning(s): <xsl:value-of select="$GDBuildOutput/Tools/CRMDeployment/Output/WarningsCount/@Actual"/>
                        </span>
                      </td>
                    </tr>
                   
                  </table>
                </xsl:if>
                <br/>
                <xsl:if test="$GDBuildOutput/Tools/CustomAdvisor/@Enabled = 'true'">                 
                  <span class="header">
                    D365 CE Quality Analysis Tools
                  </span>
                  <table align="center" width="100%" cellpadding="5" cellspacing="0">
                    <tr class="bgcolored" style="text-align: center; " >
                      <td style="width: 200px;">
                        Description
                      </td>
                      <td width="43.5%">
                        Remarks
                      </td>
                      <td width="5%">
                        Status
                      </td>
                      <td width="17%">
                        Target
                      </td>
                      <td width="17%">
                        Achieved
                      </td>
                    </tr>
                    <tr>
                      <td style="width: 200px;text-align: center;" class="colored" valign="top">
                        <a href="{$GDBuildOutput/Tools/CustomAdvisor/@Hlink}">
                          <xsl:value-of select="$GDBuildOutput/Tools/CustomAdvisor/@DisplayName"/>
                        </a>
                        <br/>
                        <span class="subtext">
                          [<xsl:value-of select="$GDBuildOutput/Tools/CustomAdvisor/Description"/>]
                        </span>
                      </td>
                      <td>
                        <span>
                          Customization Advisor Results <a href="{$ReportsLocation}/{$GDBuildOutput/Tools/CustomAdvisor/Output/ToolRunDetails/@ReportURI}">here</a>
                        </span>
                      </td>
                      <td align="center" valign="middle">
                        <xsl:call-template name="StatusImage">
                          <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CustomAdvisor/Output/ToolRunDetails/@Status"/>
                        </xsl:call-template>
                      </td>
                      <td valign="middle">
                        <span>
                          <xsl:value-of select="$GDBuildOutput/Tools/CustomAdvisor/Output/Metrics/Metric/@Target"/> Violation(s)
                        </span>
                      </td>
                      <td valign="middle">
                        <span>
                          <xsl:call-template name="ColorAttribute">
                            <xsl:with-param name="Status" select="$GDBuildOutput/Tools/CustomAdvisor/Output/ToolRunDetails/@Status"/>
                          </xsl:call-template>
                           <xsl:value-of select="$GDBuildOutput/Tools/CustomAdvisor/Output/Metrics/Metric/@Actual"/> Error(s)
                          <br/>
                          <xsl:value-of select="$GDBuildOutput/Tools/CustomAdvisor/Output/Metrics/Metric/@ActualWarnings"/> Warning(s)
                          <br />
                        </span>
                        <xsl:if test="($GDBuildOutput/Tools/CustomAdvisor/Output/ToolRunDetails/@ExitCode != 0)">
                          <xsl:call-template name="AlertExitCode">
                            <xsl:with-param name="ExitCode" select="$GDBuildOutput/Tools/CustomAdvisor/Output/ToolRunDetails/@ExitCode"/>
                          </xsl:call-template>
                        </xsl:if>
                      </td>
                    </tr>
                  </table>
                </xsl:if>
                <br/>
                
                
                <br/>
                
                <xsl:if test="(GDBuildOutput/Tools/TFSBestPractices/@Enabled='true') or (GDBuildOutput/GlobalInputArguments/WorkItemField/@ShowInReport='true') or not(GDBuildOutput/GlobalInputArguments/WorkitemsReport) or (GDBuildOutput/GlobalInputArguments/WorkitemsReport/@ShowInReport='true') or (GDBuildOutput/RunCustomerTFSQueries/@Enabled='true')">
                  <tr>
                    <td class="noborder">
                      <span class="header">
                        <br/> TFS Best Practices
                      </span>
                      <span class="minutetext">
                       <xsl:if test="(GDBuildOutput/GlobalInputArguments/WorkitemsReport/@ShowInReport='true')">
                          <br/>
                          <xsl:if test="GDBuildOutput/GlobalInputArguments/WorkitemsReport/@IterationPath!=''">
                            IterationPath: <b>
                              <xsl:value-of select="GDBuildOutput/GlobalInputArguments/WorkitemsReport/@IterationPath"/>
                            </b>
                        </xsl:if>
                         <xsl:if test="GDBuildOutput/GlobalInputArguments/WorkitemsReport/@AreaPath!=''">
                            <br/>AreaPath: <b>
                              <xsl:value-of select="GDBuildOutput/GlobalInputArguments/WorkitemsReport/@AreaPath"/>
                           </b>
                         </xsl:if>
                      </xsl:if>
                      </span>
                    </td>
                  </tr>
                  <tr>
                    <td class="noborder">
                      <table align="left" width="100%">
                        <tr class="bgcolored" style="text-align: center" >
                          <td style="width:200px">Feature</td>
                          <td>Results</td>
                          <td>Status</td>
                        </tr>
                        <!--**************************************************************Actual Efforts Summary***********************************************************************-->
                        <xsl:choose>
                          <xsl:when test="GDBuildOutput/Tools/TFSBestPractices/@Enabled='true'">
                            <xsl:for-each select="GDBuildOutput/Tools/TFSBestPractices/InputArguments/WorkItemField">
                              <xsl:value-of select="Name"/>
                              <xsl:value-of select="Enabled"/>
                              <xsl:if test="(@Name='Completed Work') and (@Enabled='true')">
                                <tr>
                                  <td align="center">
                                    <a href="https://aka.ms/esdevopstfsworkitemssummary">Actual Efforts Summary</a>
                                  </td>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/WorkItems/@ReportURI='Exceeded'">
                                      <td style="color:red">
                                        Number of workitems created/modified past one week exceeded 5,000
                                      </td>
                                      <td>
                                        <xsl:call-template name="WorkitemsReportNotAvailable"/>
                                      </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <td>
                                        <table align="left"  cellspacing="0" class="minutetext">
                                          <tr class="bgcolored" style="text-align: center; " >
                                            <td width="50%" >
                                              Assigned To
                                            </td>
                                            <xsl:for-each  select="$GDBuildOutput/WorkItems/@*">
                                              <xsl:if test="name() != 'ReportURI'">
                                                <td>
                                                  <xsl:value-of select="."/>
                                                </td>
                                              </xsl:if>
                                            </xsl:for-each>
                                            <td>
                                              Total
                                            </td>
                                          </tr>
                                          <xsl:for-each  select="$GDBuildOutput/WorkItems/workitem[generate-id() = generate-id(key('AssinedTo',@AssinedTo)[1])]">
                                            <xsl:sort select="@AssinedTo" order="ascending"/>
                                            <xsl:variable name="CompletedWork" select="key('AssinedTo', @AssinedTo)"/>
                                            <tr>
                                              <td>
                                                <xsl:value-of select="@AssinedTo"/>
                                              </td>
                                              <xsl:call-template name="IsdateExists">
                                                <xsl:with-param name ="Hours" select ="$CompletedWork" />
                                              </xsl:call-template>
                                              <td align="right">
                                                <xsl:value-of select="sum($CompletedWork/@TotalCompletedWork)"/>
                                              </td>
                                            </tr>
                                          </xsl:for-each>
                                          <tr>
                                            <td align="left">
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <xsl:choose>
                                          <xsl:when test="$GDBuildOutput/WorkItems/@ReportURI != ''">
                                            <b>
                                              WorkItems Summary Results <a href="{$GDBuildOutput/WorkItems/@ReportURI}">here</a><br/>
                                            </b>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <xsl:call-template name="WorkitemsNotAvailable"/>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </tr>
                              </xsl:if>
                              <xsl:if test="(@Name='Remaining Work') and (@Enabled='true')">
                                <tr>
                                  <td align="center">
                                    <a href="https://aka.ms/esdevopstfsworkitemssummary">Remaining Work Summary</a>
                                  </td>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/WorkItems/@ReportURI='Exceeded'">
                                      <td style="color:red">
                                        Number of workitems created/modified past one week exceeded 5,000
                                      </td>
                                      <td>
                                        <xsl:call-template name="WorkitemsReportNotAvailable"/>
                                      </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <td>
                                        <table align="left"  cellspacing="0" class="minutetext">
                                          <tr class="bgcolored" style="text-align: center; " >
                                            <td width="50%" >
                                              Assigned To
                                            </td>
                                            <xsl:for-each  select="$GDBuildOutput/RemainingWorkItems/@*">
                                              <xsl:if test="name() != 'ReportURI'">
                                                <td>
                                                  <xsl:value-of select="."/>
                                                </td>
                                              </xsl:if>
                                            </xsl:for-each>
                                            <td>
                                              Total
                                            </td>
                                          </tr>
                                          <xsl:for-each  select="$GDBuildOutput/RemainingWorkItems/RemainingWorkItem[generate-id() = generate-id(key('RWAssginedTo',@RWAssginedTo)[1])]">
                                            <xsl:sort select="@RWAssginedTo" order="ascending"/>
                                            <xsl:variable name="RemainingWork" select="key('RWAssginedTo', @RWAssginedTo)"/>
                                            <tr>
                                              <td>
                                                <xsl:value-of select="@RWAssginedTo"/>
                                              </td>
                                              <xsl:call-template name="IsRemainingdateExists">
                                                <xsl:with-param name ="Hours" select ="$RemainingWork" />
                                              </xsl:call-template>
                                              <td align="right">
                                                <xsl:value-of select="sum($RemainingWork/@TotalRemainingWork)"/>
                                              </td>
                                            </tr>
                                          </xsl:for-each>
                                          <tr>
                                            <td align="left">
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <xsl:choose>
                                          <xsl:when test="$GDBuildOutput/RemainingWorkItems/@ReportURI != ''">
                                            <b>
                                              Remaining Work Summary Results <a href="{$GDBuildOutput/RemainingWorkItems/@ReportURI}">here</a><br/>
                                            </b>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <xsl:call-template name="WorkitemsNotAvailable"/>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </tr>
                              </xsl:if>
                              <xsl:if test="(@Name='Original Estimate') and (@Enabled='true')">
                                <tr>
                                  <td align="center">
                                    <a href="https://aka.ms/esdevopstfsworkitemssummary">Original Estimate Summary</a>
                                  </td>
                                  <xsl:choose>
                                    <xsl:when test="$GDBuildOutput/WorkItems/@ReportURI='Exceeded'">
                                      <td style="color:red">
                                        Number of workitems created/modified past one week exceeded 5,000
                                      </td>
                                      <td>
                                        <xsl:call-template name="WorkitemsReportNotAvailable"/>
                                      </td>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <td>
                                        <table align="left"  cellspacing="0" class="minutetext">
                                          <tr class="bgcolored" style="text-align: center; " >
                                            <td width="50%" >
                                              Assigned To
                                            </td>
                                            <xsl:for-each  select="$GDBuildOutput/OrgEstWorkItems/@*">
                                              <xsl:if test="name() != 'ReportURI'">
                                                <td>
                                                  <xsl:value-of select="."/>
                                                </td>
                                              </xsl:if>
                                            </xsl:for-each>
                                            <td>
                                              Total
                                            </td>
                                          </tr>
                                          <xsl:for-each  select="$GDBuildOutput/OrgEstWorkItems/OrgEstWorkItem[generate-id() = generate-id(key('OEAssinedTo',@OEAssinedTo)[1])]">
                                            <xsl:sort select="@OEAssinedTo" order="ascending"/>
                                            <xsl:variable name="OriginalWork" select="key('OEAssinedTo', @OEAssinedTo)"/>
                                            <tr>
                                              <td>
                                                <xsl:value-of select="@OEAssinedTo"/>
                                              </td>
                                              <xsl:call-template name="IsoriginalExists">
                                                <xsl:with-param name ="Hours" select ="$OriginalWork" />
                                              </xsl:call-template>
                                              <td align="right">
                                                <xsl:value-of select="sum($OriginalWork/@TotalOrgEst)"/>
                                              </td>
                                            </tr>
                                          </xsl:for-each>
                                          <tr>
                                            <td align="left">
                                            </td>
                                          </tr>
                                        </table>
                                      </td>
                                      <td>
                                        <xsl:choose>
                                          <xsl:when test="$GDBuildOutput/OrgEstWorkItems/@ReportURI != ''">
                                            <b>
                                              Original Estimate Results <a href="{$GDBuildOutput/OrgEstWorkItems/@ReportURI}">here</a><br/>
                                            </b>
                                          </xsl:when>
                                          <xsl:otherwise>
                                            <xsl:call-template name="WorkitemsNotAvailable"/>
                                          </xsl:otherwise>
                                        </xsl:choose>
                                      </td>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </tr>
                              </xsl:if>
                            </xsl:for-each>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:if test="GDBuildOutput/GlobalInputArguments/WorkItemField/@ShowInReport='true'">
                              <tr>
                                <td align="center">
                                  <a href="https://aka.ms/esdevopstfsworkitemssummary">Actual Efforts Summary</a>
                                </td>
                                <xsl:choose>
                                  <xsl:when test="$GDBuildOutput/WorkItems/@ReportURI='Exceeded'">
                                    <td style="color:red">
                                      Number of workitems created/modified past one week exceeded 5,000
                                    </td>
                                    <td>
                                      <xsl:call-template name="WorkitemsReportNotAvailable"/>
                                    </td>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <td>
                                      <table align="left"  cellspacing="0" class="minutetext">
                                        <tr class="bgcolored" style="text-align: center; " >
                                          <td width="50%" >
                                            Assigned To
                                          </td>
                                          <xsl:for-each  select="GDBuildOutput/WorkItems/@*">
                                            <xsl:if test="name() != 'ReportURI'">
                                              <td>
                                                <xsl:value-of select="."/>
                                              </td>
                                            </xsl:if>
                                          </xsl:for-each>
                                          <td>
                                            Total
                                          </td>
                                        </tr>
                                        <xsl:for-each  select="GDBuildOutput/WorkItems/workitem[generate-id() = generate-id(key('AssinedTo',@AssinedTo)[1])]">
                                          <xsl:sort select="@AssinedTo" order="ascending"/>
                                          <xsl:variable name="CompletedWork" select="key('AssinedTo', @AssinedTo)"/>
                                          <tr>
                                            <td>
                                              <xsl:value-of select="@AssinedTo"/>
                                            </td>
                                            <xsl:call-template name="IsdateExists">
                                              <xsl:with-param name ="Hours" select ="$CompletedWork" />
                                            </xsl:call-template>
                                            <td align="right">
                                              <xsl:value-of select="sum($CompletedWork/@TotalCompletedWork)"/>
                                            </td>
                                          </tr>
                                        </xsl:for-each>
                                        <tr>
                                          <td align="left">
                                          </td>
                                        </tr>
                                      </table>
                                    </td>
                                    <td>
                                      <xsl:choose>
                                        <xsl:when test="GDBuildOutput/WorkItems/@ReportURI != ''">
                                          <b>
                                            WorkItems Summary Results <a href="{GDBuildOutput/WorkItems/@ReportURI}">here</a><br/>
                                          </b>
                                        </xsl:when>
                                        <xsl:otherwise>
                                          <xsl:call-template name="WorkitemsNotAvailable"/>
                                        </xsl:otherwise>
                                      </xsl:choose>
                                    </td>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </tr>
                            </xsl:if>
                          </xsl:otherwise>
                        </xsl:choose>
                        <!--**************************************************************Requirements****************************************************************************-->
                        <xsl:if test="not(GDBuildOutput/GlobalInputArguments/WorkitemsReport) or GDBuildOutput/GlobalInputArguments/WorkitemsReport/@ShowInReport='true'">
                          <tr>
                            <td align="center" >
                              <a href="https://aka.ms/esdevopsworkitemtraceability">Workitem Traceability</a> 
                            </td>
                            <td >
                              <table>
                                <tr>
                                  <!--Requirement-->

                                  <td style="border:none;">
                                    <table>
                                      <tr >
                                        <td class="mainTile">
                                          <table >
                                            <tr  class="tileNumberStyle">
                                              <td class="subTile" >
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;" align="left">
                                                      <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Active"/>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTextStyle">
                                                    <td style="border:none;">
                                                      <xsl:choose>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Product Backlog Item'">
                                                          Approved / Committed
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type!='Product Backlog Item'">
                                                          Active
                                                        </xsl:when>
                                                      </xsl:choose>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                              <td class="altSubtile">
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@NoLinkToTestCase"/>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTextStyle">
                                                    <td style="border:none;">
                                                      No link to Testcases
                                                    </td>
                                                  </tr>
                                                </table>

                                              </td>
                                            </tr>
                                            <tr  class="tileNumberStyle">
                                              <td class="altSubtile" >

                                                <table >

                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <div style="display:inline-block; height: 1.5em; background-color: #ADD8E6;" >
                                                      </div>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTitle">
                                                    <td style="border:none;">
                                                      <xsl:choose>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Requirement'">
                                                          Requirements
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='User Story'">
                                                          User Stories
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Product Backlog Item'">
                                                          Product Backlog Item (PBI)
                                                        </xsl:when>
                                                      </xsl:choose>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>

                                              <td class="subTile">
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@NoLinkToTask"/>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTextStyle">
                                                    <td style="border:none;">
                                                      No link to Tasks
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>


                                  <!--Task-->
                                  <td style="border:none;">
                                    <table>
                                      <tr >
                                        <td class="mainTile">
                                          <table >
                                            <tr  class="tileNumberStyle">
                                              <td class="subTile" >
                                              </td>
                                              <td class="altSubtile">
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/TestCases/@NoLinkToRequirement"/>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTextStyle">
                                                    <td style="border:none;">
                                                      No link To
                                                      <xsl:choose>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Requirement'">
                                                          Requirement
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='User Story'">
                                                          User Story
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Product Backlog Item'">
                                                          PBI
                                                        </xsl:when>
                                                      </xsl:choose>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr  class="tileNumberStyle">
                                              <td class="altSubtile" >
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <div style="display:inline-block; height: 1.5em; background-color: #ADD8E6;" >
                                                      </div>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTitle">
                                                    <td style="border:none;">
                                                      Testcases
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                              <td style="border:none;">
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <!--Task-->
                                  <!--bug-->
                                  <td style="border:none;">
                                    <table>
                                      <tr >
                                        <td class="mainTile">
                                          <table >
                                            <tr  class="tileNumberStyle">
                                              <td class="subTile" >
                                              </td>
                                              <td class="altSubtile">
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Bugs/@NoLinks"/>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTextStyle">
                                                    <td style="border:none;">
                                                      No link To

                                                      <xsl:choose>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Requirement'">
                                                          Requirement
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='User Story'">
                                                          User Story
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Product Backlog Item'">
                                                          PBI
                                                        </xsl:when>
                                                      </xsl:choose>
                                                      /  testcase
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr  class="tileNumberStyle">
                                              <td class="altSubtile" >
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <div style="display:inline-block; height: 1.5em; background-color: #ADD8E6;" >
                                                      </div>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTitle">
                                                    <td style="border:none;">
                                                      Bugs
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                              <td style="border:none;">
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>

                                  <!--bug-->
                                  <!--task-->
                                  <td style="border:none;">
                                    <table>
                                      <tr >
                                        <td class="mainTile">
                                          <table >
                                            <tr class="tileNumberStyle">
                                              <td class="subTile" >
                                              </td>
                                              <td class="altSubtile">
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <xsl:value-of select="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Tasks/@NoLinkToRequirement"/>
                                                    </td>
                                                  </tr>
                                                  <tr align="left"  class="tileTextStyle">
                                                    <td style="border:none;">
                                                      No link To

                                                      <xsl:choose>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Requirement'">
                                                          Requirement
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='User Story'">
                                                          User Story
                                                        </xsl:when>
                                                        <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@Type='Product Backlog Item'">
                                                          PBI
                                                        </xsl:when>
                                                      </xsl:choose>
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                            </tr>
                                            <tr  class="tileNumberStyle">
                                              <td class="altSubtile" >
                                                <table >
                                                  <tr align="left" class="tileNumberStyle">
                                                    <td style="border:none;">
                                                      <div style="display:inline-block; height: 1.5em; background-color: #ADD8E6;" >
                                                      </div>
                                                    </td>
                                                  </tr>
                                                  <tr align="left" valign="bottom"  class="tileTitle" >
                                                    <td style="border:none;">
                                                      Task
                                                    </td>
                                                  </tr>
                                                </table>
                                              </td>
                                              <td style="border:none;">
                                              </td>
                                            </tr>
                                          </table>
                                        </td>
                                      </tr>
                                    </table>
                                  </td>
                                  <!--task-->
                                </tr>
                              </table>
                            </td>
                            <td>
                              <xsl:choose>
                                <xsl:when test="GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@ReportURI != ''">
                                  <b>
                                    WorkItems Details <a href="{GDBuildOutput/DynamicConfigOutput/BuildRunSummary/Requirements/@ReportURI}">here</a><br/>
                                  </b>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:call-template name="WorkitemsNotAvailable"/>
                                </xsl:otherwise>
                              </xsl:choose>
                            </td>
                          </tr>
                        </xsl:if>

                        <!--**************************************************************Customer Queriers****************************************************************************-->
                        <xsl:if test="GDBuildOutput/RunCustomerTFSQueries/@Enabled='true'">
                          <tr>
                            <td align="center" >
                              <a href="https://aka.ms/esdevopsteamqueries">Team Queries</a>
                            </td>
                            <td>
                              <table width="100%"  align="left"  cellspacing="0" class="minutetext">
                                <xsl:choose>
                                  <xsl:when test="GDBuildOutput/RunCustomerTFSQueries/Output/Query/@Name!=''">
                                    <tr class="bgcolored" style="text-align: center; " >
                                      <td width="50%" >
                                        Team Query
                                      </td>
                                      <td width="50%">
                                        WorkItems Count
                                      </td>

                                    </tr>
                                    <xsl:for-each  select="GDBuildOutput/RunCustomerTFSQueries/Output/Query">
                                      <tr >
                                        <td >
                                          <xsl:value-of select="@Name"/>
                                        </td>

                                        <td  style="text-align: center; ">
                                          <a href="{@ReportURI}" >
                                            <xsl:value-of select="@Result"/>
                                          </a>
                                        </td>
                                      </tr>
                                    </xsl:for-each>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <tr>
                                      <td>
                                        It seems that your custom queries aren't configured yet. You can configure reporting on your custom TFS queries @ https://aka.ms/esdevopsciconfig. If you have more questions, please reach us @ https://aka.ms/esdevopsrequest
                                      </td>
                                    </tr>
                                  </xsl:otherwise>
                                </xsl:choose>
                              </table>

                            </td>
                            <td align="center" >

                            </td>
                          </tr>
                        </xsl:if>
                      </table>
                    </td>
                  </tr>
                </xsl:if>
                <tr>
                  <td class="noborder">
                    <table>
                      <tr style="color:#007ACC">
                        <td class="noborder header">
                          <br/>Note
                        </td>
                      </tr>
                      <tr>
                        <td class="noborder">
                          - Please read <a href="https://aka.ms/cireport">here</a> to interpret this report.<br/>
                          - Please raise a request/incident <a href="https://aka.ms/esdevopsrequest">here</a> if you have need any changes or require more help with any discrepancies or issues. Make sure to review the <a href="https://aka.ms/esdevopsrequestwiki">wiki</a> and <a href="https://aka.ms/quickhelp">quick help</a> resources before raising a request.<br/>
                          - Provide your ideas and suggestions <a href="https://aka.ms/esdevopsfeedback">here</a>.<br/>
                          - If tool reports are not rendered properly in IE, then go to Internet options -> Compatibility View Settings -> Add (default TFS url would be shown).<br/>
                          - If you want to retain this build, select "Retain Indefinitely" option for this particular build run from Build Explorer.<br/>
                          - If you include Fortify scan in build, build completion time may increase over-time based on the complexity of the code. Enable/Disable the Fortify scan accordingly
                        </td>
                      </tr>
                      <tr style="color:#007ACC">
                        <td class="noborder header">Disclaimer</td>
                      </tr>
                      <tr>
                        <td class="noborder">
                          - The errors/warnings reported by this ServicesDevOps report might differ if the project teams are using different version of the tools than what is being used by ServicesDevOps. ServicesDevOps uses and supports only the latest and N-1 versions of the standard code analysis/linting tools.
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
                <tr>
                  <td class="noborder">
                    <table  width="100%">
                      <tr>
                        <td class="noborder">
                          <br />
                          Thanks,
                          <br />
                          Services DevOps Team
                        </td>
                        <td class="noborder subtext" style="color:gray;font-size:60%;text-align: right; vertical-align:bottom" width="50%">
                          <!-- Generated from machine :   <xsl:value-of select="DynamicConfigOutput/BuildRunSummary/OuputParserMachineName"/>-->
                        </td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

        </table>
      </body>
    </html>
  </xsl:template>

  <xsl:template name="IsdateExists" >
    <xsl:param name="Hours" />
    <xsl:variable name="dates" />
    <xsl:for-each  select="//GDBuildOutput//WorkItems/@*">
      <xsl:variable name="maindate" select="."/>
      <xsl:if test="name() != 'ReportURI'">
        <td align="right">

          <xsl:for-each select="$Hours">

            <xsl:if test="$maindate = @ChangedDate">
              <xsl:value-of  select="$Hours[@ChangedDate=$maindate]/@TotalCompletedWork"/>
            </xsl:if>
          </xsl:for-each>

        </td>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>
  <xsl:template name="IsRemainingdateExists" >
    <xsl:param name="Hours" />
    <xsl:variable name="dates" />
    <xsl:for-each  select="//GDBuildOutput//RemainingWorkItems/@*">
      <xsl:variable name="maindate" select="."/>
      <xsl:if test="name() != 'ReportURI'">
        <td align="right">

          <xsl:for-each select="$Hours">

            <xsl:if test="$maindate = @ModifiedDate">
              <xsl:value-of  select="$Hours[@ModifiedDate=$maindate]/@TotalRemainingWork"/>
            </xsl:if>
          </xsl:for-each>

        </td>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>


  <xsl:template name="IsoriginalExists" >
    <xsl:param name="Hours" />
    <xsl:variable name="dates" />
    <xsl:for-each  select="//GDBuildOutput//OrgEstWorkItems/@*">
      <xsl:variable name="maindate" select="."/>
      <xsl:if test="name() != 'ReportURI'">
        <td align="right">

          <xsl:for-each select="$Hours">

            <xsl:if test="$maindate = @OEChangedDate">
              <xsl:value-of  select="$Hours[@OEChangedDate=$maindate]/@TotalOrgEst"/>
            </xsl:if>
          </xsl:for-each>

        </td>
      </xsl:if>
    </xsl:for-each>

  </xsl:template>

  <xsl:template name="AlertAssemblyLoadFailure" >
    <xsl:param name="Count" />
    <xsl:if test="$Count > 0">
      <div class="ui-widget">
        <div class="ui-state-error" style="padding: 0 .7em;">
          <p>
            <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
            <a href="{DynamicConfigOutput/BuildRunSummary/ReportsLocation}/AdvancedBuildReport.xml" style="text-decoration: none;color: #ffffff">
              <strong>
                Alert: <xsl:value-of select="$Count"/>
              </strong>
              Assembly Load Failure(s).
            </a>
          </p>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="ApiAlertExitCode" >
    <xsl:param name="ExitCode" />
    <xsl:if test="$ExitCode != 0 and $ExitCode != 32 and $ExitCode != 16">
      <div class="ui-widget">
        <div class="ui-state-error" style="padding: 0 .7em;">
          <p>
            <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
            <a href="{DynamicConfigOutput/BuildRunSummary/ReportsLocation}/AdvancedBuildReport.xml" style="text-decoration: none;color: #ffffff">
              <strong>Alert: </strong>Tool exited with unexpected exit code : <strong>
                <xsl:value-of select="$ExitCode"/>
              </strong>
            </a>
          </p>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="AlertExitCode" >
    <xsl:param name="ExitCode" />
    <xsl:if test="$ExitCode != 0">
      <div class="ui-widget">
        <div class="ui-state-error" style="padding: 0 .7em;">
          <p>
            <span class="ui-icon ui-icon-alert" style="float: left; margin-right: .3em;"></span>
            <strong>Alert: </strong>Tool exited with unexpected exit code : <strong>
              <xsl:value-of select="$ExitCode"/>
            </strong>
          </p>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="Notice" >
    <xsl:param name="Message" />
    <xsl:if test="$Message != ''">
      <div class="ui-widget">
        <div class="ui-state-highlight" style="margin-top: 20px; padding: 0 .7em;">
          <p>
            <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
            <strong>Note! </strong>
            <xsl:value-of select="$Message"/>
          </p>
        </div>
      </div>
    </xsl:if>
  </xsl:template>
  <xsl:template name="StatusImage" >
    <xsl:param name="Status" />
    <img alt="" hspace="0"  align="baseline" border="0" >
      <xsl:choose>
        <xsl:when test="$Status='Failed' or $Status= 'failed' or $Status='NA'" >
          <xsl:attribute name="src">Image_cross.jpg</xsl:attribute>
        </xsl:when>
        <xsl:when test="$Status='Succeeded' or $Status= 'succeeded'" >
          <xsl:attribute name="src">Image_greentick.jpg</xsl:attribute>
        </xsl:when>
        <xsl:otherwise>
          <xsl:attribute name="src">Image_orangeTick.jpg</xsl:attribute>
        </xsl:otherwise>
      </xsl:choose>
    </img>
  </xsl:template>
  <xsl:template name="ColorAttribute" >
    <xsl:param name="Status" />
    <xsl:choose>
      <xsl:when test="$Status= 'Failed' or $Status= 'failed'">
        <xsl:attribute name="style">color:red</xsl:attribute>
      </xsl:when>
      <xsl:when test="$Status= 'Succeeded' or $Status= 'succeeded'">
        <xsl:attribute name="style">color:green</xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="style">color:#FF9933</xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="ReportNotAvailable" >
    <div class="ui-widget">
      <div class="ui-state-notavailable" style="margin-top: 20px; padding: 0 .7em;">
        <p>
          <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
          Report Not Available!
        </p>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="WorkitemsNotAvailable" >
    <div class="ui-widget">
      <p>
        <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
        Workitems Not Available!
      </p>
    </div>
  </xsl:template>
  <xsl:template name="WorkitemsReportNotAvailable" >
    <div class="ui-widget">
      <div class="ui-state-notavailable" style="padding: 0 .7em;">
        <p>
          <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
          Report Not Available!
        </p>
      </div>
    </div>
  </xsl:template>
  <xsl:template name="ParseError" >
    <xsl:param name="ErrorDesc" />
    <xsl:choose>
      <xsl:when test="$ErrorDesc != ''">
        <div class="ui-widget">
          <div  class="ui-state-parseError"  style="margin-top: 20px; padding: 0 .7em;">
            <p>
              <span class="ui-icon ui-icon-info" style="float: left; margin-right: .3em;"></span>
              Error occured during report parsing!   <xsl:value-of select="$ErrorDesc"/>
            </p>
          </div>
        </div>
      </xsl:when>
      <xsl:otherwise>

      </xsl:otherwise>
    </xsl:choose>
    <!--<xsl:if test="'$Error' != ''">
    
     </xsl:if>-->
  </xsl:template>
</xsl:stylesheet>
