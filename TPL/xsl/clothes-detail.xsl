<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="2.0">
    
    <xsl:strip-space elements="*"/>
    <xsl:output indent="yes"></xsl:output>
    
    <!--<xsl:template match="/">
        <xsl:apply-templates select="//node[@id eq '4682-d1e275-340275']"/>
    </xsl:template>-->
    
    <xsl:template match="/">
     <div>
          <xsl:apply-templates />
      </div>
    </xsl:template>
    
    <!--<xsl:template match="@* | node()">
        <!-\- skip -\->
    </xsl:template>-->
    
    <xsl:template match="node">
        <!-- section -->
        <h2 class="section-title" data-slot="{property[@name eq 'name']/value/slot[1]/@id}">
            <xsl:value-of select="property[@name eq 'name']/value/slot[1]"/>
        </h2>
        
        <xsl:apply-templates select="child::node" mode="products"/>
        
    </xsl:template>
    
    <xsl:template match="node" mode="products">
        
        <!-- test -->
        <xsl:variable name="img-src" select="if(position() eq 1) then '2462_web.jpg' else '2322_web.jpg'"></xsl:variable>
        
        <!-- product -->
        <div class="product-detail">
            
            <!-- product image -->
            <div class="product-detail-left">
                <img class="product-img" title="{property[@name eq 'name']/value/slot[1]}" src="/demo-data/ascherl/img/{$img-src}" data-slot="{property[@name eq 'name']/value/slot[1]/@id}">
                </img>
            </div>
            
            <div class="product-detail-right">
             <!-- lang flag -->
             <!-- producer img -->
             <div class="product-icons" style="text-align:right;">
                <!-- flag producer-->
                 
             </div>
             <h3 class="product-title" data-slot="{property[@name eq 'name']/value/slot[1]/@id}">
                 <xsl:value-of select="property[@name eq 'name']/value/slot[1]"/>
             </h3>
                
             <img src="/demo-data/ascherl/img/2081_web.jpg" style="width:70px;"/>

             <!-- description -->
             <p class="product-desc" data-slot="{property[@name eq 'PB']/value/slot[1]/@id}">
                 <xsl:value-of select="property[@name eq 'PB']/value/slot[1]"/>
             </p>
             
             <!-- order table -->
             <table class="order-table">
                 <thead>
                     <th class="product-artno">Artikel</th>
                     <th>Größen</th>
                     <th>Ausführung</th>
                     <th>Farbe</th>
                     <th class="product-prize">Preis</th>
                 </thead>
                 <tbody>
                   <xsl:for-each select="child::node[not(@idref)]">
                       
                       <!-- test -->
                       <xsl:variable name="price" select="if(position() eq 1) then '79,90' else '69,90'"></xsl:variable>
                       <tr>
                           <td class="product-artno" data-slot="{property[@name eq 'Artikel']/value/slot[1]/@id}">
                               <xsl:value-of select="property[@name eq 'Artikel']/value/slot[1]"/>
                           </td>
                           <td class="product-size" data-slot="{property[@name eq 'Größen']/value/slot[1]/@id}">
                               <xsl:value-of select="property[@name eq 'Größen']/value/slot[1]"/>
                           </td>
                           <td class="product-type" data-slot="{property[@name eq 'Ausführung']/value/slot[1]/@id}">
                               <xsl:value-of select="property[@name eq 'Ausführung']/value/slot[1]"/>
                           </td>
                           <td class="product-color" data-slot="{property[@name eq 'Farbe']/value/slot[1]/@id}">
                               <xsl:value-of select="property[@name eq 'Farbe']/value/slot[1]"/>
                           </td>
                           <td class="product-prize">
                               <xsl:value-of select="$price"/>
                           </td>
                       </tr>
                   </xsl:for-each>  
                 </tbody>
                 
             </table>
            </div>
        </div>
    </xsl:template>
    
</xsl:stylesheet>