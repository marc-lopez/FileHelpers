<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
								version="2.0"
								xmlns:ddue="http://ddue.schemas.microsoft.com/authoring/2003/5"
								xmlns:xlink="http://www.w3.org/1999/xlink"
								xmlns:msxsl="urn:schemas-microsoft-com:xslt"
 >
	<!-- ======================================================================================== -->

	<xsl:import href="globalTemplates.xsl"/>

	<!-- ============================================================================================
	Global Variables
	============================================================================================= -->

	<xsl:variable name="showNonXamlAssemblyBoilerplate"
								select="'false'" />

	<!-- ============================================================================================
	XAML Syntax
	============================================================================================= -->

	<xsl:template name="XamlSyntaxBlock">
		<!-- Branch based on pagetype -->
		<xsl:choose>
			<!-- Display boilerplate for pagetypes that cannot be used in XAML,
           unless there's an authored XAML text section, which is used in place of the boilerplate. -->
			<xsl:when test="$g_apiTopicSubGroup='method' or 
                      $g_apiTopicSubGroup='constructor' or
                      $g_apiTopicSubGroup='interface' or
                      $g_apiTopicSubGroup='delegate' or
                      $g_apiTopicSubGroup='field'">
				<xsl:call-template name="nonXamlMembersXamlSyntax"/>
			</xsl:when>

			<!-- class and struct -->
			<xsl:when test="$g_apiTopicSubGroup='class' or 
                      $g_apiTopicSubGroup='structure'">
				<xsl:call-template name="classOrStructXamlSyntax"/>
			</xsl:when>

			<!-- enumeration -->
			<xsl:when test="$g_apiTopicSubGroup='enumeration'">
				<xsl:call-template name="enumerationXamlSyntax"/>
			</xsl:when>

			<!-- property -->
			<xsl:when test="$g_apiTopicSubGroup='property' or $g_apiTopicSubSubGroup='attachedProperty'">
				<xsl:call-template name="propertyXamlSyntax"/>
			</xsl:when>

			<!-- event -->
			<xsl:when test="$g_apiTopicSubGroup='event' or $g_apiTopicSubSubGroup='attachedEvent'">
				<xsl:call-template name="eventXamlSyntax"/>
			</xsl:when>

		</xsl:choose>
	</xsl:template>

	<!-- XAML syntax for CLASS and STRUCT topics. This is the logic:
        if authored OESyntax, 
          display it 
        else if autogen OESyntax (AND no authored XAML section), 
          display it.
        if authored AttrUsage, 
          display it
        if authored XAML section, 
          display it
        if no (authored OESyntax OR authored AttrUsage OR authored XAML section), 
          display autogen boilerplate
        display XAML Values section, if any
   -->
	<xsl:template name="classOrStructXamlSyntax">
		<!-- Object Element Usage 
        //ddue:section[starts-with(@address,'xamlValues')]
        //ddue:section[starts-with(@address,'xamlTextUsage')]
        //ddue:section[starts-with(@address,'xamlAttributeUsage')]
        //ddue:section[starts-with(@address,'xamlPropertyElementUsage')]
        //ddue:section[starts-with(@address,'xamlImplicitCollectionUsage')]
       //ddue:section[starts-with(@address,'xamlObjectElementUsage')]
    //ddue:section[starts-with(@address,'dependencyPropertyInfo')]
    //ddue:section[starts-with(@address,'routedEventInfo')]
    -->
		<xsl:choose>
			<!-- Show the authored Object Element Usage, if any. -->
			<xsl:when test="//ddue:section[starts-with(@address,'xamlObjectElementUsage')]">
				<xsl:for-each select="//ddue:section[starts-with(@address,'xamlObjectElementUsage')][1]">
					<xsl:call-template name="ShowAuthoredXamlSyntax"/>
				</xsl:for-each>
			</xsl:when>
			<!-- Else if no authored xamlTextUsage section, show the autogenerated Object Element Usage, if any. -->
			<xsl:when test="not(//ddue:section[starts-with(@address,'xamlTextUsage')])">
				<xsl:call-template name="ShowAutogeneratedXamlSyntax">
					<xsl:with-param name="autogenContent">
						<xsl:copy-of select="div[@class='xamlObjectElementUsageHeading']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<!-- Implicit Collection Usage - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlImplicitCollectionUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- Attribute Usage - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlAttributeUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- XAML Text section - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlTextUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- Autogen - show autogen boilerplate, if no authored xaml sections to override it. -->
		<xsl:if test="not(//ddue:section[starts-with(@address,'xamlObjectElementUsage')] or //ddue:section[starts-with(@address,'xamlImplicitCollectionUsage')] or //ddue:section[starts-with(@address,'xamlAttributeUsage')] or //ddue:section[starts-with(@address,'xamlTextUsage')])">
			<xsl:call-template name="ShowXamlSyntaxBoilerplate">
				<xsl:with-param name="param0">
					<xsl:copy-of select="."/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- XAML syntax for ENUMERATION topics. This is the logic:
        if authored AttrUsage, 
          display it 
        if authored XAML section, 
          display it
        if no (authored AttrUsage OR authored XAML section), 
          display autogen AttrUsage or boilerplate.
        display XAML Values section, if any
   -->
	<xsl:template name="enumerationXamlSyntax">
		<!-- Attribute Usage - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlAttributeUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- XAML Text section - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlTextUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- Autogen - show enum syntax boilerplate, if no authored xaml sections to override it. -->
		<xsl:choose>
			<xsl:when test="$showNonXamlAssemblyBoilerplate='false' and div[@class='nonXamlAssemblyBoilerplate']"/>
			<xsl:when test="not(//ddue:section[starts-with(@address,'xamlAttributeUsage')] or //ddue:section[starts-with(@address,'xamlTextUsage')])">
				<span codeLanguage="XAML">
					<table>
						<tr>
							<th>
								<include item="xamlAttributeUsageHeading" />
							</th>
						</tr>
						<tr>
							<td>
								<pre xml:space="preserve"><xsl:text/><include item="enumerationOverviewXamlSyntax"/></pre>
							</td>
						</tr>
					</table>
				</span>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<!-- XAML syntax for PROPERTY topics. This is the logic:
        if authored OESyntax, 
          display it
        if authored PEUsage, 
          display it
        else if autogen PEUsage (AND no authored XAML section), 
          display it
        if authored AttrUsage, 
          display it
        else if autogen AttrUsage (AND no authored XAML section), 
          display it
        if authored XAML section, 
          display it
        if no (authored OESyntax OR authored PEUsage OR authored AttrUsage OR authored XAML section), 
          display autogen boilerplate
   -->
	<xsl:template name="propertyXamlSyntax">
		<!-- Object Element Usage - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlObjectElementUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- Property Element Usage -->
		<xsl:choose>
			<!-- Show the authored Property Element Usage, if any. -->
			<xsl:when test="//ddue:section[starts-with(@address,'xamlPropertyElementUsage')]">
				<xsl:for-each select="//ddue:section[starts-with(@address,'xamlPropertyElementUsage')][1]">
					<xsl:call-template name="ShowAuthoredXamlSyntax"/>
				</xsl:for-each>
			</xsl:when>
			<!-- Else if no authored xamlTextUsage section, show the autogenerated Property Element Usage, if any. -->
			<xsl:when test="not(//ddue:section[starts-with(@address,'xamlTextUsage')])">
				<xsl:call-template name="ShowAutogeneratedXamlSyntax">
					<xsl:with-param name="autogenContent">
						<xsl:copy-of select="div[@class='xamlPropertyElementUsageHeading' or @class='xamlContentElementUsageHeading']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<!-- Attribute Usage -->
		<xsl:choose>
			<!-- Show the authored Attribute Usage, if any. -->
			<xsl:when test="//ddue:section[starts-with(@address,'xamlAttributeUsage')]">
				<xsl:for-each select="//ddue:section[starts-with(@address,'xamlAttributeUsage')][1]">
					<xsl:call-template name="ShowAuthoredXamlSyntax"/>
				</xsl:for-each>
			</xsl:when>
			<!-- Else if no authored xamlTextUsage section, show the autogenerated Attribute Usage, if any. -->
			<xsl:when test="not(//ddue:section[starts-with(@address,'xamlTextUsage')])">
				<xsl:call-template name="ShowAutogeneratedXamlSyntax">
					<xsl:with-param name="autogenContent">
						<xsl:copy-of select="div[@class='xamlAttributeUsageHeading']"/>
					</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
		<!-- XAML Text section - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlTextUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- Autogen - show autogen boilerplate, if no authored xaml sections to override it. -->
		<xsl:if test="not(//ddue:section[starts-with(@address,'xamlObjectElementUsage')] or //ddue:section[starts-with(@address,'xamlPropertyElementUsage')] or //ddue:section[starts-with(@address,'xamlAttributeUsage')] or //ddue:section[starts-with(@address,'xamlTextUsage')])">
			<xsl:call-template name="ShowXamlSyntaxBoilerplate">
				<xsl:with-param name="param0">
					<xsl:copy-of select="div/*"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- XAML syntax for EVENT topics. This is the logic:
        if authored AttrUsage, 
          display it 
        if authored XAML section, 
          display it
        if no (authored AttrUsage OR authored XAML section), 
          display autogen AttrUsage or boilerplate.
        display XAML Values section, if any
   -->
	<xsl:template name="eventXamlSyntax">
		<!-- Attribute Usage - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlAttributeUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- XAML Text section - show authored section, if any. -->
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlTextUsage')][1]">
			<xsl:call-template name="ShowAuthoredXamlSyntax"/>
		</xsl:for-each>
		<!-- Autogen - show autogen syntax or boilerplate, if no authored xaml sections to override it. -->
		<xsl:if test="not(//ddue:section[starts-with(@address,'xamlAttributeUsage')] or //ddue:section[starts-with(@address,'xamlTextUsage')])">
			<!-- If XamlSyntax component generated an Attribute Usage block, this template will show it. -->
			<xsl:call-template name="ShowAutogeneratedXamlSyntax">
				<xsl:with-param name="autogenContent">
					<xsl:copy-of select="div[@class='xamlAttributeUsageHeading']"/>
				</xsl:with-param>
			</xsl:call-template>
			<!-- If XamlSyntax component generated a boilerplate block, this template will show it. -->
			<xsl:call-template name="ShowXamlSyntaxBoilerplate">
				<xsl:with-param name="param0">
					<xsl:copy-of select="div/*"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<!-- XAML syntax for members that cannot be used in XAML: interface, delegate, method, field, constructor.
       If there's an authored XAML section, show it. Otherwise, use the standard boilerplate.  -->
	<xsl:template name="nonXamlMembersXamlSyntax">
		<xsl:choose>
			<!-- XAML Text section - show authored section, if any. -->
			<xsl:when test="//ddue:section[starts-with(@address,'xamlTextUsage')]">
				<xsl:for-each select="//ddue:section[starts-with(@address,'xamlTextUsage')][1]">
					<xsl:call-template name="ShowAuthoredXamlSyntax"/>
				</xsl:for-each>
			</xsl:when>
			<!-- Autogen - show autogen boilerplate, if no authored xaml sections to override it. -->
			<xsl:otherwise>
				<xsl:call-template name="ShowXamlSyntaxBoilerplate"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- Displays one of the standard XAML boilerplate strings. -->
	<xsl:template name="ShowXamlSyntaxBoilerplate">
		<xsl:param name="param0"/>
		<!-- TFS bug 303004: DO NOT SHOW ANY xaml syntax boilerplate strings. -->
		<xsl:variable name="boilerplateId"/>

		<!-- If future requirements call for showing one or more boilerplate strings for xaml, 
         use the commented out code to specify the ids of the shared content items to include.
         NOTE: the markup like div/@class[.='interfaceOverviewXamlSyntax' is added by XamlUsageSyntax.cs in BuildAssembler. -->
		<!--
    <xsl:variable name="boilerplateId">
      <xsl:value-of select="div/@class[.='interfaceOverviewXamlSyntax' or
                    .='propertyXamlSyntax_abstractType' or                    
                    .='classXamlSyntax_abstract']"/>
    </xsl:variable>
    -->

		<xsl:if test="$boilerplateId!=''">
			<span codeLanguage="XAML">
				<table>
					<tr>
						<th>
							<include item="xamlSyntaxBoilerplateHeading" />
						</th>
					</tr>
					<tr>
						<td>
							<pre xml:space="preserve"><span class="message"><xsl:text/><include item="{$boilerplateId}">
                  <xsl:choose>
                    <xsl:when test="$param0!='' or (count(msxsl:node-set($param0)/*) &gt; 0)">
                      <parameter><xsl:copy-of select="msxsl:node-set($param0)"/></parameter>
                    </xsl:when>
                    <!-- make sure we at least pass in an empty param because some boilerplates expect them -->
                    <xsl:otherwise>
                      <parameter/>
                    </xsl:otherwise>
                  </xsl:choose>
                </include></span></pre>
						</td>
					</tr>
				</table>
			</span>
		</xsl:if>
	</xsl:template>

	<!-- Displays an authored XAML syntax section -->
	<xsl:template name="ShowAuthoredXamlSyntax">
		<xsl:if test="ddue:content[normalize-space(.)!='']">
			<xsl:variable name="headingID">
				<xsl:choose>
					<xsl:when test="starts-with(@address,'xamlObjectElementUsage')">xamlObjectElementUsageHeading</xsl:when>
					<xsl:when test="starts-with(@address,'xamlImplicitCollectionUsage')">xamlImplicitCollectionUsageHeading</xsl:when>
					<xsl:when test="starts-with(@address,'xamlPropertyElementUsage')">
						<xsl:choose>
							<xsl:when test="//div[@class='xamlContentElementUsageHeading']">xamlContentElementUsageHeading</xsl:when>
							<xsl:otherwise>xamlPropertyElementUsageHeading</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="starts-with(@address,'xamlAttributeUsage')">xamlAttributeUsageHeading</xsl:when>
					<xsl:when test="starts-with(@address,'xamlTextUsage')">xamlSyntaxBoilerplateHeading</xsl:when>
				</xsl:choose>
			</xsl:variable>
			<span codeLanguage="XAML">
				<table>
					<tr>
						<th>
							<include item="{$headingID}" />
						</th>
					</tr>
					<xsl:choose>
						<xsl:when test="$headingID='xamlSyntaxBoilerplateHeading'">
							<tr>
								<td>
									<xsl:apply-templates select="ddue:content"/>
								</td>
							</tr>
						</xsl:when>
						<xsl:otherwise>
							<tr>
								<td>
									<pre xml:space="preserve"><xsl:choose>
                      <xsl:when test="ddue:content/ddue:code"><xsl:apply-templates select="ddue:content/ddue:code[1]/node()" /></xsl:when>
                      <xsl:when test="ddue:content/ddue:para"><xsl:apply-templates select="ddue:content/ddue:para"/></xsl:when>
                    </xsl:choose></pre>
								</td>
							</tr>
						</xsl:otherwise>
					</xsl:choose>
				</table>
			</span>
		</xsl:if>
	</xsl:template>

	<!-- Displays the autogenerated XAML syntax for pagetypes other than enumerations -->
	<xsl:template name="ShowAutogeneratedXamlSyntax">
		<xsl:param name="autogenContent"/>
		<xsl:if test="count(msxsl:node-set($autogenContent))>0">
			<xsl:for-each select="msxsl:node-set($autogenContent)/div">
				<xsl:variable name="headingID">
					<xsl:value-of select="@class"/>
				</xsl:variable>
				<span codeLanguage="XAML">
					<table>
						<tr>
							<th>
								<include item="{$headingID}" />
							</th>
						</tr>
						<tr>
							<td>
								<pre xml:space="preserve"><xsl:text/><xsl:copy-of select="node()"/></pre>
							</td>
						</tr>
					</table>
				</span>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>

	<!-- Display the XAML Values section. -->
	<xsl:template name="showXamlValuesSection">
		<xsl:for-each select="//ddue:section[starts-with(@address,'xamlValues')]">
			<div id="xamlValues">
				<p></p>
				<xsl:call-template name="t_putSubSection">
					<xsl:with-param name="p_title">
						<include item="xamlValuesSectionHeading" />
					</xsl:with-param>
					<xsl:with-param name="p_content">
						<xsl:apply-templates select="ddue:content"/>
					</xsl:with-param>
				</xsl:call-template>
			</div>
		</xsl:for-each>
	</xsl:template>

	<!-- these xaml sections are captured in the xaml syntax processing, so this template prevents them from showing up twice -->
	<xsl:template match="//ddue:section[starts-with(@address,'xamlValues') or 
                                      starts-with(@address,'xamlTextUsage') or 
                                      starts-with(@address,'xamlAttributeUsage') or 
                                      starts-with(@address,'xamlPropertyElementUsage') or 
                                      starts-with(@address,'xamlImplicitCollectionUsage') or 
                                      starts-with(@address,'xamlObjectElementUsage') or 
                                      starts-with(@address,'dependencyPropertyInfo') or 
                                      starts-with(@address,'routedEventInfo')]"/>

	<!-- the authored dependency Property Information section -->
	<xsl:template match="ddue:section[starts-with(@address,'dependencyPropertyInfo')]"
								mode="section">
		<xsl:call-template name="t_putSectionInclude">
			<xsl:with-param name="p_titleInclude"
											select="'dependencyPropertyInfoHeading'" />
			<xsl:with-param name="p_content">
				<xsl:apply-templates select="ddue:content" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- the authored routed event Information section -->
	<xsl:template match="ddue:section[starts-with(@address,'routedEventInfo')]"
								mode="section">
		<xsl:call-template name="t_putSectionInclude">
			<xsl:with-param name="p_titleInclude"
											select="'routedEventInfoHeading'" />
			<xsl:with-param name="p_content">
				<xsl:apply-templates select="ddue:content" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<!-- Show XAML xmlns for apis that support XAML -->
	<xsl:template name="xamlXmlnsInfo">
		<xsl:variable name="hasAuthoredXamlSyntax"
									select="boolean(//ddue:sections/ddue:section[
                                      starts-with(@address,'xamlTextUsage') or 
                                      starts-with(@address,'xamlAttributeUsage') or 
                                      starts-with(@address,'xamlPropertyElementUsage') or 
                                      starts-with(@address,'xamlImplicitCollectionUsage') or 
                                      starts-with(@address,'xamlObjectElementUsage')])" />
		<xsl:variable name="hasAutogeneratedXamlSyntax"
									select="boolean(/document/syntax/div[@codeLanguage='XAML']/div[
                                      @class='xamlAttributeUsageHeading' or
                                      @class='xamlObjectElementUsageHeading' or
                                      @class='xamlContentElementUsageHeading' or
                                      @class='xamlPropertyElementUsageHeading'])" />
		<!-- All topics that have authored or autogen'd xaml syntax get an "XMLNS for XAML" line in the Requirements section. 
         Topics with boilerplate xaml syntax, e.g. "Not applicable", do NOT get this line. -->
		<xsl:if test="$hasAuthoredXamlSyntax or $hasAutogeneratedXamlSyntax">
			<br/>
			<include item="boilerplate_xamlXmlnsRequirements">
				<parameter>
					<xsl:choose>
						<xsl:when test="/document/syntax/div[@codeLanguage='XAML']/div[@class='xamlXmlnsUri']">
							<xsl:for-each select="/document/syntax/div[@codeLanguage='XAML']/div[@class='xamlXmlnsUri']">
								<xsl:if test="position()!=1">
									<xsl:text>, </xsl:text>
								</xsl:if>
								<xsl:value-of select="."/>
							</xsl:for-each>
						</xsl:when>
						<xsl:otherwise>
							<include item="boilerplate_unmappedXamlXmlns"/>
						</xsl:otherwise>
					</xsl:choose>
				</parameter>
			</include>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
