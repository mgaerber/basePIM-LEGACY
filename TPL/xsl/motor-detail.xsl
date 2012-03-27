<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
    
    <xsl:param name="config"></xsl:param>
    <xsl:param name="lang"></xsl:param>
    <xsl:param name="brand"></xsl:param>
    
    <xsl:template match="/">
    <div>
        <xsl:apply-templates></xsl:apply-templates>
    </div>
    </xsl:template>
    
    <xsl:template match="node[@type = 'motor']">
        <h2>
            <xsl:value-of select="property[@name = 'bezeichnung']/value/slot[1]"/>
        </h2>
        
        <div>
            <p>image ?</p>
        </div>
        
        <h3>Gewicht:</h3>
        <p>
            <xsl:value-of select="property[@name = 'gewicht']/value/slot[1]/num"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="property[@name = 'gewicht']/value/slot[1]/unit"/>
        </p>
        
        <h3>Dimensionen:</h3>
        <p>
            <xsl:variable name="dimensions" select="property[@name = 'dimensions']/value/slot[1]"/>
            <xsl:value-of select="concat($dimensions/width/num, ' ', $dimensions/width/unit)"/>
            
        </p>
        
     
        
        <h3>Features:</h3>
        <p>
            <ul>
                <xsl:for-each select="property[@name = 'key-features']/value">
   
                    <li>
                        <xsl:value-of select="slot[1]"/>
                    </li>
                </xsl:for-each>
            </ul>
        </p>
    </xsl:template>

    
</xsl:stylesheet>