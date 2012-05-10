<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:output method="xml" indent="yes"></xsl:output>
    
    <xsl:strip-space elements="*"/>
    
    <xsl:key name="property-by-inherited-id" match="property" use="@inherited_from_nodeid"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="/">
        <!--<workspaces>-->
            <xsl:apply-templates/>
        <!--</workspaces>-->
    </xsl:template>
    
    <xsl:template match="publication">
        <workspace>
           <!-- <xsl:apply-templates/>-->
            
            <!-- bootsmotoren -->
          <!--  <xsl:attribute name="type" select="'bootsmotoren'"/>
            <xsl:apply-templates select="//level[@nodeid eq '1714']"/>
       -->
            <!-- Bekleidung -->
            <xsl:attribute name="type" select="'bekleidung'"/>
            <xsl:apply-templates select="//level[@nodeid eq '4681']"/>
            
       
        </workspace>
    </xsl:template>
    
    <xsl:template match="autotexts | formatgroups | publication-specifications | units | prop-classes">
        <!-- omit -->
    </xsl:template>
    
    <xsl:template match="properties">
        <!-- skip -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="level">
        
        <node id="{concat(@nodeid, '-', generate-id(), '-', @levelid)}"
            name="{string(name)}" type="foo">
            <property name="name">
                <value>
                    <slot lang="de" id="{generate-id(name)}">
                        <xsl:value-of select="name"/>
                    </slot>
                </value>
            </property>
            
            <xsl:apply-templates/>
        </node>
    </xsl:template>
    
    <xsl:template match="property[@inherited_from_nodeid]" priority="100">
        <!-- omit double entries -->
    </xsl:template>
    
    <xsl:template match="property[@type eq 'imageref']">
        
        <node id="{generate-id()}" idref="{concat(translate(value/name, ' ', '_'), @code)}" name="{value/name}">
            
            
        </node>
        
    </xsl:template>
    
    <xsl:template match="property">
        <xsl:variable name="level" select="parent::properties/parent::level"/>
        <xsl:variable name="nodeid" select="$level/@nodeid"/>
        
        <property name="{@code}" type="{@type}">
           
            <xsl:if test="exists(key('property-by-inherited-id', $nodeid, $level))">
                <xsl:attribute name="inheritable">
                    <xsl:text>yes</xsl:text>
                </xsl:attribute>
            </xsl:if>
            
            <xsl:apply-templates/>
        </property>
    </xsl:template>
    
    <xsl:template match="level/name | property/name | value/name">
        <!-- omit -->
    </xsl:template>
    
    <xsl:template match="property/value">
        <value>
            <slot lang="de" id="{generate-id()}">
                <xsl:apply-templates/>
            </slot>
        </value>
    </xsl:template>
    
    <xsl:template match="property/value/files" priority="100">
        
    </xsl:template>
    
    <xsl:template match="property/value/p" priority="100">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    <xsl:template match="property/value/node()" priority="1">
        <xsl:copy-of select="."/>
    </xsl:template>
    
    
</xsl:stylesheet>