<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <html>
      <head>
        <style type="text/css">

          body {
          font-family:Segoe UI Light;
          font-size:80%;
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
          font-size:90%;
          }

          .header
          {
          font-family:Segoe UI Light;
          color:#007ACC;
          font-size:150%;
          }

          .colored
          {
          color:#007ACC;
          }

          .bgcolored
          {
          font-family:Segoe UI Light;
          background-color:#007ACC;
          color:white
          }


        </style>
      </head>
      <body>
        <xsl:if test="Root/BuildWarnings/Warning">
        <Div class="header" style="text-align: center; ">
          Compilation Warnings
        </Div>

        <table class="noborder "  style="  width:inherit; word-wrap: break-word;">
          <tr class="bgcolored" >
            <th>Warning Type</th>
            <th>Task Name</th>
            <th>Message</th>
            <th>FileName</th>
            <th>Line</th>
            <th>Project TFS Path</th>
            <th>File TFS Path</th>
          </tr>
          <xsl:for-each select="Root/BuildWarnings/Warning">
            <xsl:if test ="WarningType='Compilation' or WarningType='Code'">
              <tr class="subtext" style="width:5%">
                <td>
                  <xsl:value-of select="WarningType"/>
                </td>
                <td>
                  <xsl:value-of select="TaskName"/>
                </td>
                <td style="word-wrap: break-word;width:1000px">
                  <xsl:value-of select="Message"/>
                </td>
                <td style=";word-wrap: break-word;width:150px;">
                  <xsl:value-of select="FileName"/>
                </td>
                <td style=";word-wrap: break-word;">
                  <xsl:value-of select="Line"/>
                </td>
                <td style="width:200px;word-wrap: break-word;">
                  <xsl:value-of select="ProjectServerPath"/>
                </td>
                <td style="width:200px;word-wrap: break-word; ">
                  <xsl:value-of select="ServerFilePath"/>
                </td>
              </tr>
            </xsl:if>
          </xsl:for-each>
        </table>
        <xsl:if test="Root/BuildWarnings/Warning[WarningType != 'Compilation']">

          <Div class="header" style="text-align: center; ">
            Other Warnings
          </Div>
          <table class="noborder ">
            <tr class="bgcolored" >
              <th>Warning Type</th>
              <th>Task Name</th>
              <th>Message</th>
              <th>FileName</th>
              <th>Line</th>
              <th>Project Server Path</th>
              <th>Server File Path</th>
            </tr>
            <xsl:for-each select="Root/BuildWarnings/Warning">
              <xsl:if test ="WarningType!='Compilation' and WarningType!='Code' ">
                <tr class="subtext" style="width:5%">
                  <td>
                    <xsl:value-of select="WarningType"/>
                  </td>
                  <td>
                    <xsl:value-of select="TaskName"/>
                  </td>
                  <td style="word-wrap: break-word;width:1000px">
                    <xsl:value-of select="Message"/>
                  </td>
                  <td style=";word-wrap: break-word;width:150px;">
                    <xsl:value-of select="FileName"/>
                  </td>
                  <td style=";word-wrap: break-word;">
                    <xsl:value-of select="Line"/>
                  </td>
                  <td style="width:200px;word-wrap: break-word;">
                    <xsl:value-of select="ProjectServerPath"/>
                  </td>
                  <td style="width:200px;word-wrap: break-word; ">
                    <xsl:value-of select="ServerFilePath"/>
                  </td>
                </tr>
              </xsl:if>
            </xsl:for-each>
          </table>
        </xsl:if>
        </xsl:if>
        <xsl:if test="Build/Error">
          <Div class="header" style="text-align: center; ">
            Build Errors
          </Div>
            <table class="noborder "  style="  width:inherit; word-wrap: break-word;">
              <tr class="bgcolored" >
                <th>Error Type</th>
                <th>Task Name</th>
                <th>Message</th>
                <th>FileName</th>
                <th>Line</th>
                <th>Path</th>
              </tr>
              <xsl:for-each  select="Build/Error">
                  <tr class="subtext" style="width:5%">
                    <td>
                      <xsl:value-of select="@Category"/>
                    </td>
                    <td>
                      <xsl:value-of select="@TaskName"/>
                    </td>
                    <td style="word-wrap: break-word;width:1000px">
                      <xsl:value-of select="@Message"/>
                    </td>
                    <td style=";word-wrap: break-word;width:150px;">
                      <xsl:value-of select="@FileName"/>
                    </td>
                    <td style=";word-wrap: break-word;">
                      <xsl:value-of select="@Linenumber"/>
                    </td>
                    <td style="width:200px;word-wrap: break-word;">
                      <xsl:value-of select="@Sourcepath"/>
                    </td>
                  </tr>
              </xsl:for-each>
            </table>
        </xsl:if>
        <xsl:if test="Build/Warning">
          <Div class="header" style="text-align: center; ">
            Build Warnings
          </Div>
          <table class="noborder "  style="  width:inherit; word-wrap: break-word;">
            <tr class="bgcolored" >
              <th>Warning Type</th>
              <th>Task Name</th>
              <th>Message</th>
              <th>FileName</th>
              <th>Line</th>
              <th>Path</th>
            </tr>
            <xsl:for-each  select="Build/Warning">
              <tr class="subtext" style="width:5%">
                <td>
                  <xsl:value-of select="@Category"/>
                </td>
                <td>
                  <xsl:value-of select="@TaskName"/>
                </td>
                <td style="word-wrap: break-word;width:1000px">
                  <xsl:value-of select="@Message"/>
                </td>
                <td style=";word-wrap: break-word;width:150px;">
                  <xsl:value-of select="@FileName"/>
                </td>
                <td style=";word-wrap: break-word;">
                  <xsl:value-of select="@Linenumber"/>
                </td>
                <td style="width:200px;word-wrap: break-word;">
                  <xsl:value-of select="@Sourcepath"/>
                </td>
              </tr>
            </xsl:for-each>
          </table>
        </xsl:if>
      </body>
    
    </html>
  </xsl:template>
</xsl:stylesheet>
