<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"></xsl:output>
    <xsl:strip-space elements="*"/>
    
    <!-- Bild, Logo, Gruppenbild, Gruppeneinschub -->
    
    <xsl:template match="@* | node()">
       <!-- <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>-->
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:variable name="root" select="."/>
        <workspace type="ascherlbilder">
        
        <node id="Alle" name="Alle">
            <xsl:for-each select="('Bild', 'Logo', 'Gruppenbild', 'Gruppeneinschub')">
                <xsl:variable name="code" select="."/>
                
                <node id="{.}" name="{.}">
                    <property name="title">
                        <value>
                            <slot lang="any"><xsl:value-of select="."/></slot>
                        </value>
                    </property>
                    <xsl:for-each-group select="$root//property[@type eq 'imageref'][@code eq $code][not(@inherited_from_nodeid)]" group-by="value/name">
                    <xsl:apply-templates select="current-group()[1]"/>
                    </xsl:for-each-group>
                </node>
                
            </xsl:for-each>
        </node>
        </workspace>       
    </xsl:template>
    
    <xsl:template match="property[@type eq 'imageref']">
        
        <!-- width, height, ext -->
        <xsl:variable name="web-file" select="value/files/file[@type eq 'web']"/>
        
      <!--  <node id="{generate-id()}" name="{value/name}">-->
         <node id="{concat(translate(value/name, ' ', '_'), @code)}" name="{value/name}">
            <property name="title">
                <value>
                    <slot lang="any"><xsl:value-of select="value/name"/></slot>
                </value>
            </property>
    
            <property name="file-name">
                <value>
                    <slot lang="any" id="{generate-id($web-file)}_name"><xsl:value-of select="$web-file/@realname"/></slot>
                </value>
            </property>
            <property name="file">
                <value>
                    <slot lang="any" id="{generate-id($web-file)}_file"><xsl:value-of select="$web-file"/></slot>
                </value>
            </property>
        </node>
    </xsl:template>
    
</xsl:stylesheet>