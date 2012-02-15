<xf:model>
   <xf:instance>
      <instance  xmlns="">
        <slot lang="any">
          <width>
            <num>100</num>
            <unit>mm</unit>
          </width>
          <height>
            <num>500</num>
            <unit>mm</unit>
          </height>
          <length>
            <num>100</num>
            <unit>mm</unit>
          </length>
        </slot>
      </instance>
   </xf:instance>
   <xf:bind nodeset="slot/*/num" type="xs:int" />
</xf:model>
