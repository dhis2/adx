<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:message="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/message" 
xmlns:common="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/common"
xmlns:generic="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/generic" 
xmlns:structure="http://www.SDMX.org/resources/SDMXML/schemas/v1_0/structure" 
exclude-result-prefixes="xsl message common structure generic"
version="1.0">

<xsl:output method="html" version="4.0" indent="yes"/>

<!-- Input Parameters -->
<!-- URI of Key Family xml instance, optional: will check GenericData/DataSet/@keyFamilyURI if not passed - used to find strcture of Key Family -->
<xsl:param name="KeyFamURI">notPassed</xsl:param>

<xsl:template match="/">
     <!-- Find the location of the Key Family xml instance if not passed as an input parameter-->
     <xsl:variable name="KFLoc">
          <xsl:choose>
               <xsl:when test="$KeyFamURI='notPassed'">
                    <xsl:value-of select="/message:GenericData/message:DataSet/@keyFamilyURI"/>
               </xsl:when>
               <xsl:otherwise>
                    <xsl:value-of select="$KeyFamURI"/>
               </xsl:otherwise>
          </xsl:choose>
     </xsl:variable>

     <!-- Get the Key Family ID from the Generic instance-->
     <xsl:variable name="KeyFamID">
          <xsl:value-of select="/message:GenericData/message:DataSet/generic:KeyFamilyRef"/>
     </xsl:variable>

     <!-- Open the Key Family xml instance -->
     <xsl:variable name="Structure" select="document($KFLoc, .)"/>
     <xsl:variable name="KeyFam" select="$Structure/message:Structure/message:KeyFamilies/structure:KeyFamily[@id=$KeyFamID]"/>
     
     <head>
          <title><xsl:value-of select="/message:GenericData/message:DataSet/generic:KeyFamilyRef"/> Data</title>
          <style type="text/css">
               body {margin-top: 25; margin-right: 25; margin-left: 25; margin-bottom: 0;}
               table {border-color: #003366}
               h1 {color: #003366; font-size: 14pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: center}
               .tableTitle {color: #003366; font-size: 12pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; cursor: pointer; text-decoration: underline; line-height: 110%}
               .hideText {color: #003366; font-size: 8pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; cursor: pointer; text-decoration: none}
               .thead {color: #003366; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; width: 100%;  background-color: gray; border-color: #003366}
               .field {color: #003366; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; vertical-align: top; width: 20%; background-color: gray; border-color: #003366}
               .serField {color: #003366; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: bold; text-align: left; vertical-align: top; background-color: gray; border-color: #003366}
               .data {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; vertical-align: top; width: 80%; background-color: white; border-color: #003366}  
               .dataT {padding: 0%}        
               .serData {color: black; font-size: 10pt; font-family: Arial; font-style: normal; font-weight: normal; text-align: left; vertical-align: top; background-color: white; border-color: #003366}
          </style>
          <script type="text/javascript">
               function getItem(id) {
                    var itm = false;
                    if(document.getElementById)
                         itm = document.getElementById(id);
                    else if(document.all)
                         itm = document.all[id];
                    else if(document.layers)
                         itm = document.layers[id];
                    
                    return itm;
               }
               
               function hideTable(id){
                    itm = getItem(id);                    
                    if(!itm)
                    return false;
                    if(itm.style.display == 'none')
                         itm.style.display = '';
                    else
                         itm.style.display = 'none';
                    return false;
               }
               
               function hideVals(id) {
                    var table = getItem(id);
                    if (!table)
                         return false;
                    var columnNumber = 2;
                    var isShowing = (table.tBodies[0].rows[0].cells[columnNumber].style.display == '');

                    var rows = table.tHead.rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                         rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var rows = table.tBodies[0].rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                          rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var columnNumber = 0;
                    var isShowing = (table.tBodies[0].rows[0].cells[columnNumber].style.display == '');

                    var rows = table.tHead.rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                         rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var rows = table.tBodies[0].rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                          rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var bText = getItem(id + 'BV');
                    bText.innerText= isShowing ? 'Show Values': 'Hide Values';
               } 
               
               function hideCodes(id) {
                    var table = getItem(id);
                    if (!table)
                         return false;
                    var columnNumber = 3;
                    var isShowing = (table.tBodies[0].rows[0].cells[columnNumber].style.display == '');

                    var rows = table.tHead.rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                         rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var rows = table.tBodies[0].rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                          rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var columnNumber = 1;
                    var isShowing = (table.tBodies[0].rows[0].cells[columnNumber].style.display == '');

                    var rows = table.tHead.rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                         rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var rows = table.tBodies[0].rows;
                    for (var rowLoop=0; rowLoop&lt;rows.length; rowLoop++) {
                          rows[rowLoop].cells[columnNumber].style.display = isShowing ? 'none' : '';
                    }
                    var bText = getItem(id + 'BC');
                    bText.innerText= isShowing ? 'Show Codes': 'Hide Codes';
               } 
          </script>
     </head>
     <body>
          <xsl:variable name="KeyFamName">
               <xsl:choose>
                    <xsl:when test="$KeyFam/structure:Name">
                         <xsl:value-of select="$KeyFam/structure:Name"/>
                    </xsl:when>
                    <xsl:otherwise>
                         <xsl:value-of select="$KeyFamID"/>
                    </xsl:otherwise>
               </xsl:choose>
          </xsl:variable>
          <h1><xsl:value-of select="$KeyFamName"/> Data</h1>
          <h2 class="tableTitle" onclick="hideTable('headerData')" onmouseover="window.status='Expand or collapse header table.';" onmouseout="window.status=''">Header Information</h2>
          <xsl:variable name="Header" select="/message:GenericData/message:Header"/>
          <table width="100%" cellpadding="3" cellspacing="1" border="1">
               <tbody id="headerData">
                    <tr>
                         <td class="field">Message ID</td>
                         <td class="data"><xsl:value-of select="$Header/message:ID"/></td>
                    </tr>
                    <tr>
                         <td class="field">Test Message</td>
                         <td class="data"><xsl:value-of select="$Header/message:Test"/></td>
                    </tr>
                    <xsl:for-each select="$Header/message:Truncated">
                         <tr>
                              <td class="field">Message Truncated</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Name">
                         <tr>
                              <td class="field">Message Name</td>
                              <td class="data" lang="{@xml:lang}"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Prepared">
                         <tr>
                              <td class="field">Date Prepared</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Receiver | $Header/message:Sender">
                         <tr>
                              <td class="field"><xsl:value-of select="local-name()"/> ID</td>
                              <td class="data"><xsl:value-of select="@id"/></td>
                         </tr>
                         <xsl:for-each select="message:Name">
                              <tr>
                                   <td class="field"><xsl:value-of select="local-name(..)"/> Name</td>
                                   <td class="data" lang="{@xml:lang}"><xsl:value-of select="."/></td>
                              </tr>
                         </xsl:for-each>
                         <xsl:for-each select="message:Contact">
                              <tr>
                                   <td class="field"><xsl:value-of select="local-name(..)"/> Contact</td>
                                   <td  class="dataT">
                                        <table width="100%" cellpadding="3" cellspacing="1" border="1">
                                             <tbody>
                                                  <xsl:for-each select="*">
                                                       <tr>
                                                            <td class="field"><xsl:value-of select="local-name()"/></td>
                                                            <td lang="{@xml:lang}" class="data"><xsl:value-of select="."/></td>
                                                       </tr>
                                                  </xsl:for-each>
                                             </tbody>
                                        </table>
                                   </td>
                              </tr>
                         </xsl:for-each>                    
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:KeyFamilyRef">
                         <tr>
                              <td class="field">Key Family</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:KeyFamilyAgency">
                         <tr>
                              <td class="field">Key Family Agency</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:DataSetAgency">
                         <tr>
                              <td class="field">Data Set Agency</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:DataSetID">
                         <tr>
                              <td class="field">Data Set ID</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:DataSetAction">
                         <tr>
                              <td class="field">Data Set Action</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:Extracted">
                         <tr>
                              <td class="field">Extracted</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:ReportingBegin">
                         <tr>
                              <td class="field">Reporting Begin Date</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                    <xsl:for-each select="$Header/message:ReportingEnd">
                         <tr>
                              <td class="field">Reporting End Date</td>
                              <td class="data"><xsl:value-of select="."/></td>
                         </tr>
                    </xsl:for-each>
                         <xsl:for-each select="message:Source">
                              <tr>
                                   <td class="field">Source</td>
                                   <td class="data" lang="{@xml:lang}"><xsl:value-of select="."/></td>
                              </tr>
                         </xsl:for-each>
               </tbody>
          </table>
          <xsl:for-each select="//generic:Series">
               <xsl:variable name="TableTitle">series<xsl:value-of select="position()"/></xsl:variable>
               <h2 class="tableTitle" onclick="hideTable('{$TableTitle}')" onmouseover="window.status='Expand or collapse series data table.';" onmouseout="window.status=''">Series Key:
						<xsl:choose>
							<xsl:when test="$KeyFam">
								<xsl:for-each select="generic:SeriesKey/generic:Value">
	                       <xsl:variable name="Dim" select="@concept"/>
	                       <xsl:variable name="DimName" select="$Structure/message:Structure/message:Concepts/structure:Concept[@id=$Dim]/structure:Name"/>
	                       <xsl:variable name="CodeList" select="$KeyFam/structure:Components/structure:Dimension[@concept=$Dim]/@codelist"/>
	                       <xsl:variable name="CodeValue" select="@value"/>
	                       <xsl:variable name="CodeDesc" select="$Structure/message:Structure/message:CodeLists/structure:CodeList[@id=$CodeList]/structure:Code[@value=$CodeValue]/structure:Description"/>
									<br/><xsl:value-of select="concat(' ', $DimName, '=', $CodeDesc)"/>
								</xsl:for-each>
							</xsl:when>
							<xsl:otherwise>
								<xsl:for-each select="generic:SeriesKey/generic:Value">
									<br/><xsl:value-of select="concat(' ', @concept, '=', @value)"/>
								</xsl:for-each>
							</xsl:otherwise>
						</xsl:choose>
					</h2>
               <table id="{$TableTitle}" width="100%" cellpadding="10">
                    <tbody>
                         <tr>
                              <td>
                                   <xsl:variable name="SubTableTitle">seriesDim<xsl:value-of select="position()"/></xsl:variable>
                                   <h2 class="tableTitle" onclick="hideTable('{$SubTableTitle}')" onmouseover="window.status='Expand or collapse series dimension data table.';" onmouseout="window.status=''">Dimensions</h2>
                                   <xsl:variable name="SubTableVals">seriesDim<xsl:value-of select="position()"/>Vals</xsl:variable>
                                   <table id="{$SubTableTitle}" width="100%">
                                        <tbody>
                                             <tr>
                                                  <td>
                                                       <table>
                                                            <tbody>
                                                                 <tr>
                                                                      <xsl:if test="$KeyFam">
                                                                           <td><a class="hideText" id="{$SubTableVals}BV" onclick="hideVals('{$SubTableVals}')">Hide Values</a></td>
                                                                           <td><a class="hideText" id="{$SubTableVals}BC" onclick="hideCodes('{$SubTableVals}')">Hide Codes</a></td>
                                                                      </xsl:if>
                                                                 </tr>
                                                            </tbody>
                                                       </table>
                                                  </td>
                                             </tr>
                                             <tr>
                                                  <td>
                                                       <table id="{$SubTableVals}" width="100%" cellpadding="3" cellspacing="1" border="1">
                                                            <xsl:if test="$KeyFam">
                                                                 <thead>
                                                                      <tr>
                                                                           <th class="serField" width="30%">Name</th>
                                                                           <th class="serField" width="15%">ID</th>
                                                                           <th class="serField" width="30%">Value</th>
                                                                           <th class="serField" width="15%">Code</th>
                                                                      </tr>
                                                                 </thead>
                                                                 <tbody>
                                                                      <xsl:for-each select="generic:SeriesKey/generic:Value">
                                                                           <tr>
                                                                                <xsl:variable name="Dim" select="@concept"/>
                                                                                <xsl:variable name="DimName" select="$Structure/message:Structure/message:Concepts/structure:Concept[@id=               $Dim]/structure:Name"/>
                                                                                <xsl:variable name="CodeList" select="$KeyFam/structure:Components/structure:Dimension[@concept=$Dim]/@codelist"/>
                                                                                <xsl:variable name="CodeValue" select="@value"/>
                                                                                <xsl:variable name="CodeDesc" select="$Structure/message:Structure/message:CodeLists/structure:CodeList[@id=                         $CodeList]/structure:Code[@value=$CodeValue]/structure:Description"/>
                                                                                <td class="serData"><xsl:value-of select="$DimName"/></td>
                                                                                <td class="serData"><xsl:value-of select="$Dim"/></td>
                                                                                <td class="serData"><xsl:value-of select="$CodeDesc"/></td>
                                                                                <td class="serData"><xsl:value-of select="$CodeValue"/></td>
                                                                           </tr>
                                                                      </xsl:for-each>
                                                                 </tbody>
                                                           </xsl:if>
                                                           <xsl:if test="not($KeyFam)">
                                                                 <thead>
                                                                      <tr>
                                                                           <th class="serField" width="50%">ID</th>
                                                                           <th class="serField" width="50%">Code</th>
                                                                      </tr>
                                                                 </thead>
                                                                 <tbody>
                                                                      <xsl:for-each select="generic:SeriesKey/generic:Value">
                                                                           <tr>
                                                                                <xsl:variable name="Dim" select="@concept"/>
                                                                                <xsl:variable name="CodeValue" select="@value"/>
                                                                                <td class="serData"><xsl:value-of select="$Dim"/></td>
                                                                                <td class="serData"><xsl:value-of select="$CodeValue"/></td>
                                                                           </tr>
                                                                      </xsl:for-each>
                                                                 </tbody>
                                                           </xsl:if>
                                                       </table>
                                                  </td>
                                             </tr>
                                        </tbody>
                                   </table>
                                   <xsl:variable name="SubTable2Title">seriesAtt<xsl:value-of select="position()"/></xsl:variable>
                                   <h2 class="tableTitle" onclick="hideTable('{$SubTable2Title}')" onmouseover="window.status='Expand or collapse series attribute data table.';" onmouseout="window.status=''">Attributes</h2>
                                   <xsl:variable name="SubTable2Vals">seriesAtt<xsl:value-of select="position()"/>Vals</xsl:variable>
                                   <table id="{$SubTable2Title}" width="100%">
                                        <tbody>
                                             <tr>
                                                  <td>
                                                       <table>
                                                            <tbody>
                                                                 <tr>
                                                                      <xsl:if test="$KeyFam">
                                                                           <td><a class="hideText" id="{$SubTable2Vals}BV" onclick="hideVals('{$SubTable2Vals}')">Hide Values</a></td>
                                                                           <td><a class="hideText" id="{$SubTable2Vals}BC" onclick="hideCodes('{$SubTable2Vals}')">Hide Codes</a></td>
                                                                      </xsl:if>
                                                                 </tr>
                                                            </tbody>
                                                       </table>
                                                  </td>
                                             </tr>
                                             <tr>
                                                  <td>
                                                       <table id="{$SubTable2Vals}" width="100%" cellpadding="3" cellspacing="1" border="1">
                                                            <xsl:if test="$KeyFam">
                                                                 <thead>
                                                                      <tr>
                                                                           <th class="serField" width="30%">Name</th>
                                                                           <th class="serField" width="15%">ID</th>
                                                                           <th class="serField" width="30%">Value</th>
                                                                           <th class="serField" width="15%">Code</th>
                                                                      </tr>
                                                                 </thead>
                                                                 <tbody>
                                                                      <xsl:for-each select="ancestor-or-self::*/generic:Attributes/generic:Value">
                                                                           <tr>
                                                                                <xsl:variable name="Att" select="@concept"/>
                                                                                <xsl:variable name="AttName" select="$Structure/message:Structure/message:Concepts/structure:Concept[@id=               $Att]/structure:Name"/>
                                                                                <xsl:variable name="CodeList" select="$KeyFam/structure:Components/structure:Attribute[@concept=$Att]/@codelist"/>
                                                                                <xsl:variable name="CodeValue" select="@value"/>
                                                                                <xsl:variable name="CodeDesc" select="$Structure/message:Structure/message:CodeLists/structure:CodeList[@id=                         $CodeList]/structure:Code[@value=$CodeValue]/structure:Description"/>
                                                                                <td class="serData"><xsl:value-of select="$AttName"/></td>
                                                                                <td class="serData"><xsl:value-of select="$Att"/></td>
                                                                                <td class="serData"><xsl:value-of select="$CodeDesc"/></td>
                                                                                <td class="serData"><xsl:value-of select="$CodeValue"/></td>
                                                                           </tr>
                                                                      </xsl:for-each>
                                                                 </tbody>
                                                            </xsl:if>
                                                            <xsl:if test="not($KeyFam)">
                                                                 <thead>
                                                                      <tr>
                                                                           <th class="serField" width="50%">ID</th>
                                                                           <th class="serField" width="50%">Code</th>
                                                                      </tr>
                                                                 </thead>
                                                                 <tbody>
                                                                      <xsl:for-each select="ancestor-or-self::*/generic:Attributes/generic:Value">
                                                                           <tr>
                                                                                <xsl:variable name="Att" select="@concept"/>
                                                                                <xsl:variable name="CodeValue" select="@value"/>
                                                                                <td class="serData"><xsl:value-of select="$Att"/></td>
                                                                                <td class="serData"><xsl:value-of select="$CodeValue"/></td>
                                                                           </tr>
                                                                      </xsl:for-each>
                                                                 </tbody>
                                                            </xsl:if>
                                                       </table>
                                                  </td>
                                             </tr>
                                        </tbody>
                                   </table>
                                   <xsl:variable name="SubTable3Title">seriesObs<xsl:value-of select="position()"/></xsl:variable>
                                   <h2 class="tableTitle" onclick="hideTable('{$SubTable3Title}')" onmouseover="window.status='Expand or collapse series dimension data table.';" onmouseout="window.status=''">Observations</h2>
                                   <table id="{$SubTable3Title}" width="100%" cellpadding="3" cellspacing="1" border="1">
                                        <xsl:if test="$KeyFam">
                                             <tbody>
                                                  <tr>
                                                       <th class="serField">Time</th>
                                                       <th class="serField">Value</th>
                                                       <xsl:for-each select="generic:Obs/generic:Attributes/generic:Value/@concept[not(../../../preceding-sibling::*/generic:Attributes/generic:Value/@concept = .)]">
                                                            <xsl:variable name="Att" select="."/>
                                                            <th class="serField"><xsl:value-of select="$Structure/message:Structure/message:Concepts/structure:Concept[@id=               $Att]/structure:Name"/></th>
                                                       </xsl:for-each>
                                                  </tr>
                                                  <xsl:for-each select="generic:Obs">
                                                       <xsl:variable name="Obs" select="."/>
                                                       <tr>
                                                            <td class="serData"><xsl:value-of select="generic:Time"/></td>
                                                            <td class="serData"><xsl:value-of select="generic:ObsValue/@value"/></td>
                                                            <xsl:for-each select="$Obs/..//generic:Obs/generic:Attributes/generic:Value/@concept[not(../../../preceding-sibling::*/generic:Attributes/generic:Value/@concept = .)]">
                                                                 <xsl:variable name="Att" select="."/>
                                                                 <xsl:if test="not($Obs/generic:Attributes/generic:Value[@concept=$Att]/@value)">
                                                                      <td class="serData">-</td>
                                                                 </xsl:if>
                                                                 <xsl:if test="$Obs/generic:Attributes/generic:Value[@concept=$Att]/@value">
                                                                      <td class="serData"><xsl:value-of select="$Obs/generic:Attributes/generic:Value[@concept=$Att]/@value"/></td>
                                                                 </xsl:if>
                                                            </xsl:for-each>
                                                       </tr>
                                                  </xsl:for-each>
                                             </tbody>
                                        </xsl:if>
                                        <xsl:if test="not($KeyFam)">
                                             <tbody>
                                                  <tr>
                                                       <th class="serField">Time</th>
                                                       <th class="serField">Value</th>
                                                       <xsl:for-each select="generic:Obs/generic:Attributes/generic:Value/@concept[not(../../../preceding-sibling::*/generic:Attributes/generic:Value/@concept = .)]">
                                                            <th class="serField"><xsl:value-of select="."/></th>
                                                       </xsl:for-each>
                                                  </tr>
                                                  <xsl:for-each select="generic:Obs">
                                                       <xsl:variable name="Obs" select="."/>
                                                       <tr>
                                                            <td class="serData"><xsl:value-of select="generic:Time"/></td>
                                                            <td class="serData"><xsl:value-of select="generic:ObsValue/@value"/></td>
                                                            <xsl:for-each select="$Obs/..//generic:Obs/generic:Attributes/generic:Value/@concept[not(../../../preceding-sibling::*/generic:Attributes/generic:Value/@concept = .)]">
                                                                 <xsl:variable name="Att" select="."/>
                                                                 <xsl:if test="not($Obs/generic:Attributes/generic:Value[@concept=$Att]/@value)">
                                                                      <td class="serData">-</td>
                                                                 </xsl:if>
                                                                 <xsl:if test="$Obs/generic:Attributes/generic:Value[@concept=$Att]/@value">
                                                                      <td class="serData"><xsl:value-of select="$Obs/generic:Attributes/generic:Value[@concept=$Att]/@value"/></td>
                                                                 </xsl:if>
                                                            </xsl:for-each>
                                                       </tr>
                                                  </xsl:for-each>
                                             </tbody>
                                        </xsl:if>
                                   </table>
                              </td>
                         </tr>
                    </tbody>
               </table>
          </xsl:for-each>
     </body>
     
</xsl:template>

</xsl:stylesheet>
