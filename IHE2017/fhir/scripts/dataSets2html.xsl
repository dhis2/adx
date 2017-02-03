<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:d="http://dhis2.org/schema/dxf/2.0"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="utf-8"/> 
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" />
            </head>
            <body>
                <div class="container">
                    <h1>Rwanda reporting forms</h1>
                    <table class="table">
                        <xsl:apply-templates select="//d:dataSet"/>
                    </table>
                </div>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="d:dataSet">
        <tr>
            <td><xsl:value-of select="d:displayName/text()"/></td>
            <td><a href="../fhir/q_{@id}.xml">fhir</a></td>
            <td><a href="./dxf_{@id}.xml">dxf</a></td>
        </tr>
    </xsl:template>

</xsl:stylesheet>