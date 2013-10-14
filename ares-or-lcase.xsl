<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:are="http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_answer_or/v_1.0.3"
    xmlns:d="http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_datatypes/v_1.0.3"
    xmlns:u="http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/uvis_datatypes/v_1.0.3"
    xmlns:f="http://opendata.cz/xslt/functions#"
    exclude-result-prefixes="xs are d u f"
    
    xmlns:adms="http://www.w3.org/ns/adms#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:gr="http://purl.org/goodrelations/v1#"
    xmlns:lex="http://purl.org/lex#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rov="http://www.w3.org/ns/regorg#"
    xmlns:schema="http://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:lodares="http://linked.opendata.cz/ontology/ares#"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    version="2.0">
    
    <!--
        Seznam zkratek: http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/documentation/zkr_103.txt
        XML schéma: http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_datatypes/v_1.0.3/ares_datatypes_v_1.0.3.xsd
    -->
    
    <xsl:param name="namespace">http://linked.opendata.cz/resource/</xsl:param>
	<xsl:variable name="beURIprefix">http://linked.opendata.cz/resource/business-entity/</xsl:variable>
    <xsl:variable name="baseURI" select="concat($namespace, 'domain/ares/')"/>
    <xsl:variable name="icoScheme" select="concat($namespace, 'concept-scheme/CZ-ICO')"/>
    <xsl:variable name="druhAkcieScheme">concept-scheme/druh-akcie</xsl:variable>
    <xsl:variable name="podobaAkcieScheme">concept-scheme/podoba-akcie</xsl:variable>
    <xsl:variable name="funkceVPredstavenstvuScheme">concept-scheme/funkce-v-predstavenstvu</xsl:variable>
    <xsl:variable name="funkceVDozorciRadeScheme">concept-scheme/funkce-v-dozorci-rade</xsl:variable>
    <xsl:variable name="kodAngmScheme">concept-scheme/kod-angm</xsl:variable>
    <xsl:strip-space elements="*"/>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml" normalization-form="NFC"/>
    
	<xsl:function name="f:getClenURI" as="xs:anyURI">
		<xsl:param name="context" as="node()"/>
		<xsl:value-of select="f:pathIdURI(concat('person/',normalize-space($context/d:c/d:fo/d:dn/text())), encode-for-uri(lower-case(concat(if($context/d:c/d:fo/d:tp) then concat(normalize-space($context/d:c/d:fo/d:tp/text()), '-') else '', normalize-space($context/d:c/d:fo/d:p/text()), '-', normalize-space($context/d:c/d:fo/d:j/text())))))"/>
	</xsl:function>
    
	<xsl:function name="f:getClenstviVPredstavenstvuURI" as="xs:anyURI">
		<xsl:param name="ico" as="xs:string"/>
		<xsl:param name="context" as="node()"/>
		<xsl:value-of select="f:icoBasedDomainURI(concat($ico,'/clenstvi-v-predstavenstvu',normalize-space($context/d:c/d:fo/d:dn/text())), encode-for-uri(lower-case(concat(if($context/d:c/d:fo/d:tp) then concat(normalize-space($context/d:c/d:fo/d:tp/text()), '-') else '', normalize-space($context/d:c/d:fo/d:p/text()), '-', normalize-space($context/d:c/d:fo/d:j/text())))))"/>
	</xsl:function>

	<xsl:function name="f:getClenstviVDozorciRadeURI" as="xs:anyURI">
		<xsl:param name="ico" as="xs:string"/>
		<xsl:param name="context" as="node()"/>
		<xsl:value-of select="f:icoBasedDomainURI(concat($ico,'/clenstvi-v-dozorci-rade',normalize-space($context/d:c/d:fo/d:dn/text())),  encode-for-uri(lower-case(concat(if($context/d:c/d:fo/d:tp) then concat(normalize-space($context/d:c/d:fo/d:tp/text()), '-') else '', normalize-space($context/d:c/d:fo/d:p/text()), '-', normalize-space($context/d:c/d:fo/d:j/text())))))"/>
	</xsl:function>

	<xsl:function name="f:getZastavaniFunkceVPredstavenstvuURI" as="xs:anyURI">
		<xsl:param name="ico" as="xs:string"/>
		<xsl:param name="context" as="node()"/>
		<xsl:value-of select="f:icoBasedDomainURI(concat($ico,'/zastavani-funkce-v-predstavenstvu/', normalize-space($context/d:c/d:fo/d:dn/text())),  encode-for-uri(lower-case(concat(if($context/d:c/d:fo/d:tp) then concat(normalize-space($context/d:c/d:fo/d:tp/text()), '-') else '', normalize-space($context/d:c/d:fo/d:p/text()), '-', normalize-space($context/d:c/d:fo/d:j/text()), '/',if ($context/d:c/d:vf/d:dza) then concat('/', normalize-space($context/d:c/d:vf/d:dza/text())) else ''))))"/>
	</xsl:function>

	<xsl:function name="f:getZastavaniFunkceVDozorciRadeURI" as="xs:anyURI">
		<xsl:param name="ico" as="xs:string"/>
		<xsl:param name="context" as="node()"/>
		<xsl:value-of select="f:icoBasedDomainURI(concat($ico,'/zastavani-funkce-v-dozorci-rade/',normalize-space($context/d:c/d:fo/d:dn/text())),  encode-for-uri(lower-case(concat(if($context/d:c/d:fo/d:tp) then concat(normalize-space($context/d:c/d:fo/d:tp/text()), '-') else '', normalize-space($context/d:c/d:fo/d:p/text()), '-', normalize-space($context/d:c/d:fo/d:j/text()), if ($context/d:c/d:vf/d:dza) then concat('/', normalize-space($context/d:c/d:vf/d:dza/text())) else ''))))"/>
	</xsl:function>

    <xsl:function name="f:classURI" as="xs:anyURI">
        <xsl:param name="classLabel" as="xs:string"/>
        <xsl:param name="id" as="xs:string"/>
        <xsl:value-of select="f:pathIdURI(encode-for-uri(replace(lower-case(normalize-space($classLabel)), '\s', '-')), normalize-space($id))"/>
    </xsl:function>
    
    <xsl:function name="f:icoBasedURI" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="fragment" as="xs:string"/>
        <xsl:value-of select="concat($beURIprefix, 'CZ', normalize-space($ico), '/', normalize-space($fragment))"/>
    </xsl:function>
    
    <xsl:function name="f:icoBasedDomainURI" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="fragment" as="xs:string"/>
        <xsl:value-of select="concat($baseURI,'business-entity/CZ', normalize-space($ico), '/', normalize-space($fragment))"/>
    </xsl:function>

    <xsl:function name="f:icoBasedAddressURI" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:value-of select="f:icoBasedURI(normalize-space($ico), concat('postal-address/', $context/local-name()))"/>
    </xsl:function>
    
    <xsl:function name="f:pathIdURIWithICOFallback" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="id" as="node()*"/>
        <xsl:param name="context" as="node()"/>
        <xsl:choose>
            <xsl:when test="$id">
                <xsl:value-of select="f:pathIdURI($path, normalize-space($id))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="f:icoBasedURI($ico, concat($path, '/', $context/local-name()))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="f:pathURI" as="xs:anyURI">
        <xsl:param name="path" as="xs:string"/>
        <xsl:value-of select="concat($baseURI, $path)"/>
    </xsl:function>
    
    <xsl:function name="f:pathIdURI" as="xs:anyURI">
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="id" as="xs:string"/>
        <xsl:value-of select="concat(f:pathURI($path), '/', encode-for-uri(normalize-space($id)))"/>
    </xsl:function>
    
    <xsl:template match="are:ares_odpovedi">
        <rdf:RDF>
            <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="are:odpoved">
        <xsl:apply-templates/>
    </xsl:template>
    
	<xsl:template match="d:vypis_or">
		<xsl:apply-templates select="d:zau">
			<xsl:with-param name="ico" select="normalize-space(d:zau/d:ico/text())"/>		
		</xsl:apply-templates>
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="normalize-space(d:zau/d:ico/text())"/>		
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:zau">
		<!-- Základní údaje -->
        <xsl:param name="ico"/>
        <gr:BusinessEntity rdf:about="{concat($beURIprefix, 'CZ', normalize-space($ico))}">
            <dcterms:valid rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:pod)"/></dcterms:valid>
            <rdf:type rdf:resource="http://www.w3.org/ns/regorg#RegisteredOrganization"/>
            <rov:registration rdf:resource="{f:icoBasedURI($ico,concat('identifier/',$ico))}"/>
            <gr:legalName><xsl:value-of select="normalize-space(d:of)"/></gr:legalName>
            <dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:dzor)"/></dcterms:issued>
            <schema:address rdf:resource="{f:icoBasedURI($ico,'hq-address')}"/>
			<xsl:apply-templates select="following-sibling::*">
				<xsl:with-param name="ico" select="$ico"/>
			</xsl:apply-templates>
        </gr:BusinessEntity>
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

    <xsl:template mode="linked" match="d:ico">
		<xsl:param name="ico"/>
        <adms:Identifier rdf:about="{f:icoBasedURI($ico,concat('identifier/',$ico))}">
            <skos:notation><xsl:value-of select="normalize-space(text())"/></skos:notation>
            <skos:inScheme rdf:resource="{$icoScheme}"/>
            <adms:schemeAgency xml:lang="cs">Český statistický úřad</adms:schemeAgency>
            <xsl:apply-templates mode="identifier" select="../d:dv|../d:ror/d:sz/d:sd"/>
        </adms:Identifier>
    </xsl:template>

	<xsl:template match="d:reg">
		<!-- Registrace -->
		<xsl:param name="ico"/>
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:cin" mode="linked">
		<!-- Činnosti -->
		<xsl:param name="ico"/>
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:cin">
		<!-- Činnosti -->
		<xsl:param name="ico"/>
		<xsl:apply-templates>
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:osk">
		<!-- Činnosti -->
		<xsl:param name="ico"/>
		<xsl:apply-templates>
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:kap">
		<!-- Kapitál -->
		<xsl:param name="ico"/>
        <lodares:zakladni-kapital rdf:resource="{f:icoBasedDomainURI($ico, 'zakladni-kapital')}"/>
        <xsl:if test="d:za/d:spl/d:kc">
			<lodares:zakladni-kapital-splaceno rdf:resource="{f:icoBasedDomainURI($ico, 'zakladni-kapital-splaceno')}"/>
        </xsl:if>
        <xsl:if test="d:za/d:spl/d:prc">
			<lodares:zakladni-kapital-splaceno-procent rdf:datatype="http://www.w3.org/2001/XMLSchema#nonNegativeInteger"><xsl:value-of select="normalize-space(d:za/d:spl/d:prc/text())"/></lodares:zakladni-kapital-splaceno-procent>
        </xsl:if>
        <xsl:if test="d:akcie">
			<xsl:for-each select="d:akcie/d:em">
				<lodares:emise rdf:resource="{f:icoBasedDomainURI($ico, concat('emise/',./position()))}"/>
			</xsl:for-each>
        </xsl:if>
	</xsl:template>

	<xsl:template match="d:kap" mode="linked">
		<!-- Kapitál -->
		<xsl:param name="ico"/>
		<gr:PriceSpecification rdf:about="{f:icoBasedDomainURI($ico, 'zakladni-kapital')}">
			<gr:hasCurrency>CZK</gr:hasCurrency>
			<gr:hasCurrencyValue rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal"><xsl:value-of select="normalize-space(d:za/d:vk/d:kc/text())"/></gr:hasCurrencyValue>
		</gr:PriceSpecification>
        <xsl:if test="d:za/d:spl/d:kc">
			<gr:PriceSpecification rdf:about="{f:icoBasedDomainURI($ico, 'zakladni-kapital-splaceno')}">
				<gr:hasCurrency>CZK</gr:hasCurrency>
				<gr:hasCurrencyValue rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal"><xsl:value-of select="normalize-space(d:za/d:spl/d:kc/text())"/></gr:hasCurrencyValue>
			</gr:PriceSpecification>
        </xsl:if>
        <xsl:if test="d:akcie">
			<xsl:for-each select="d:akcie/d:em">
				<lodares:Emise rdf:about="{f:icoBasedDomainURI($ico, concat('emise/',./position()))}">
					<lodares:druh-akcie rdf:resource="{f:pathIdURI($druhAkcieScheme, normalize-space(d:da/text()))}"/>
					<lodares:podoba-akcie rdf:resource="{f:pathIdURI($podobaAkcieScheme, normalize-space(d:pd/text()))}"/>
					<lodares:hodnota-akcie rdf:resource="{f:icoBasedDomainURI($ico, concat('emise/',./position(),'/hodnota'))}"/>
					<lodares:pocet-akcii rdf:datatype="http://www.w3.org/2001/XMLSchema#integer"><xsl:value-of select="normalize-space(d:pocet/text())"/></lodares:pocet-akcii>
				</lodares:Emise>
			</xsl:for-each>
        </xsl:if>
        <xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" tunnel="yes"/>
        </xsl:apply-templates>
	</xsl:template>
	
    <xsl:template mode="linked" match="d:akcie">
		<xsl:param name="ico"/>
		<xsl:for-each select="d:em">
			<gr:PriceSpecification rdf:about="{f:icoBasedDomainURI($ico, concat('emise/',./position(),'/hodnota'))}">
				<gr:hasCurrency>CZK</gr:hasCurrency>
				<gr:hasCurrencyValue rdf:datatype="http://www.w3.org/2001/XMLSchema#decimal"><xsl:value-of select="normalize-space(d:h/text())"/></gr:hasCurrencyValue>
			</gr:PriceSpecification>
		</xsl:for-each>
		<xsl:apply-templates select="d:em/*" mode="linked">
			<xsl:with-param name="ico" tunnel="yes"/>
		</xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="linked" match="d:pd">
        <!-- Právní forma -->
        <skos:Concept rdf:about="{f:pathIdURI($podobaAkcieScheme, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($podobaAkcieScheme)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>    
    </xsl:template>

    <xsl:template mode="linked" match="d:da">
        <!-- Právní forma -->
        <skos:Concept rdf:about="{f:pathIdURI($druhAkcieScheme, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($druhAkcieScheme)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>    
    </xsl:template>

	<xsl:template match="d:sop">
		<xsl:param name="ico"/>
		<!-- Statutární orgán - představenstvo -->
		<lodares:predstavenstvo rdf:resource="{f:icoBasedDomainURI($ico, 'predstavenstvo')}"/>
	</xsl:template>

	<xsl:template match="d:sop" mode="linked">
		<xsl:param name="ico"/>
		<!-- Statutární orgán - představenstvo -->
		<lodares:Predstavenstvo rdf:about="{f:icoBasedDomainURI($ico, 'predstavenstvo')}">
			<xsl:for-each select="d:csp">
				<lodares:clen-predstavenstva rdf:resource="{f:getClenstviVPredstavenstvuURI($ico,.)}"/>
			</xsl:for-each>
			<dcterms:description xml:lang="cs"><xsl:value-of select="normalize-space(d:t/text())"/></dcterms:description>
		</lodares:Predstavenstvo>

		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:dr">
		<xsl:param name="ico"/>
		<!-- Dozorčí rada -->
		<lodares:dozorci-rada rdf:resource="{f:icoBasedDomainURI($ico, 'dozorci-rada')}"/>
	</xsl:template>

	<xsl:template match="d:dr" mode="linked">
		<xsl:param name="ico"/>
		<!-- Dozorčí rada -->
		<lodares:DozorciRada rdf:about="{f:icoBasedDomainURI($ico, 'dozorci-rada')}">
			<xsl:for-each select="d:cdr">
				<lodares:clen-predstavenstva rdf:resource="{f:getClenstviVDozorciRadeURI($ico,.)}"/>
			</xsl:for-each>
			<dcterms:description xml:lang="cs"><xsl:value-of select="normalize-space(d:t/text())"/></dcterms:description>
		</lodares:DozorciRada>

		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:csp" mode="linked">
		<xsl:param name="ico"/>
		<!-- Statutární orgán - představenstvo -->
		<lodares:ClenstviVPredstavenstvu rdf:about="{f:getClenstviVPredstavenstvuURI($ico, .)}">
			<lodares:clen-predstavenstva rdf:resource="{f:getClenURI(.)}"/>
			<dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:c/d:cle/d:dza/text())"/></dcterms:issued>
			<lodares:zastavani-funkce-v-predstavenstvu rdf:resource="{f:getZastavaniFunkceVPredstavenstvuURI($ico, .)}"/>
			<lodares:kod-angm rdf:resource="{f:pathIdURI($kodAngmScheme, normalize-space(d:c/d:kan/text()))}"/>
		</lodares:ClenstviVPredstavenstvu>

		<lodares:ZastavaniFunkceVPredstavenstvu rdf:about="{f:getZastavaniFunkceVPredstavenstvuURI($ico, .)}">
			<dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:c/d:vf/d:dza/text())"/></dcterms:issued>
			<lodares:funkce-v-predstavenstvu rdf:resource="{f:pathIdURI($funkceVPredstavenstvuScheme, normalize-space(d:c/d:f/text()))}"/>
		</lodares:ZastavaniFunkceVPredstavenstvu>

		<xsl:apply-templates mode="linked" select="d:c/d:fo">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:cdr" mode="linked">
		<xsl:param name="ico"/>
		<!-- Dozorčí rada -->
		<lodares:ClenstviVDozorciRade rdf:about="{f:getClenstviVDozorciRadeURI($ico, .)}">
			<lodares:clen-predstavenstva rdf:resource="{f:getClenURI(.)}"/>
			<dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:c/d:cle/d:dza/text())"/></dcterms:issued>
			<lodares:zastavani-funkce-v-predstavenstvu rdf:resource="{f:getZastavaniFunkceVDozorciRadeURI($ico, .)}"/>
			<lodares:kod-angm rdf:resource="{f:pathIdURI($kodAngmScheme, normalize-space(d:c/d:kan/text()))}"/>
		</lodares:ClenstviVDozorciRade>

		<lodares:ZastavaniFunkceVDozorciRade rdf:about="{f:getZastavaniFunkceVDozorciRadeURI($ico, .)}">
			<dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:c/d:vf/d:dza/text())"/></dcterms:issued>
			<lodares:funkce-v-predstavenstvu rdf:resource="{f:pathIdURI($funkceVDozorciRadeScheme, normalize-space(d:c/d:f/text()))}"/>
		</lodares:ZastavaniFunkceVDozorciRade>

		<xsl:apply-templates mode="linked" select="d:c/d:fo">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

    <xsl:template mode="linked" match="d:fo">
        <!-- Člen představenstva nebo dozorčí rady -->
		<xsl:param name="ico"/>
        <foaf:Person rdf:about="{f:getClenURI(../..)}">
			<foaf:familyName><xsl:value-of select="normalize-space(d:p/text())"/></foaf:familyName>
			<foaf:givenName><xsl:value-of select="normalize-space(d:j/text())"/></foaf:givenName>
			<foaf:dateOfBirth rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="normalize-space(d:dn/text())"/></foaf:dateOfBirth>
			<xsl:if test="d:tp">
				<foaf:title><xsl:value-of select="normalize-space(d:tp/text())"/></foaf:title>
			</xsl:if>
			<xsl:if test="d:tz">
				<foaf:title><xsl:value-of select="normalize-space(d:tz/text())"/></foaf:title>
			</xsl:if>
			<schema:address rdf:resource="{concat(f:getClenURI(../..),'/address')}"/>
        </foaf:Person>    
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
    </xsl:template>

    <xsl:template mode="linked" match="d:b">
		<xsl:param name="ico"/>
		<schema:PostalAddress rdf:about="{concat(f:getClenURI(../../..),'/address')}">
			<schema:streetAddress><xsl:value-of select="concat(normalize-space(d:nu/text()),' ', normalize-space(d:cd/text()))"/></schema:streetAddress>
			<schema:addressLocality><xsl:value-of select="normalize-space(d:n/text())"/></schema:addressLocality>
			<xsl:if test="d:zahr_psc">
				<schema:postalCode><xsl:value-of select="normalize-space(d:zahr_psc/text())"/></schema:postalCode>
			</xsl:if>
			<xsl:if test="d:psc">
				<schema:postalCode><xsl:value-of select="normalize-space(d:psc/text())"/></schema:postalCode>
			</xsl:if>
			<xsl:if test="d:ns">
				<schema:addressCountry><xsl:value-of select="normalize-space(d:ns/text())"/></schema:addressCountry>
			</xsl:if>
		</schema:PostalAddress>
    </xsl:template>


    <xsl:template mode="linked" match="d:f[ancestor::d:csp]">
        <!-- Funkce v představenstvu -->
        <skos:Concept rdf:about="{f:pathIdURI($funkceVPredstavenstvuScheme, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($funkceVPredstavenstvuScheme)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>    
    </xsl:template>

    <xsl:template mode="linked" match="d:kan[ancestor::d:csp]">
        <!-- Kod angm ??? v představenstvu -->
        <skos:Concept rdf:about="{f:pathIdURI($kodAngmScheme, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($kodAngmScheme)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>    
    </xsl:template>

    <xsl:template mode="linked" match="d:f[ancestor::d:cdr]">
        <!-- Funkce v dozorčí radě -->
        <skos:Concept rdf:about="{f:pathIdURI($funkceVDozorciRadeScheme, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($funkceVDozorciRadeScheme)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>    
    </xsl:template>

    <xsl:template mode="linked" match="d:kan[ancestor::d:cdr]">
        <!-- Kod angm ??? v dozorčí radě -->
        <skos:Concept rdf:about="{f:pathIdURI($kodAngmScheme, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($kodAngmScheme)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>    
    </xsl:template>

	<xsl:template match="d:pro">
		<!-- Prokura -->
		<xsl:param name="ico"/>
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="d:aki">
		<!-- Akcionáři -->
		<xsl:param name="ico"/>
		<xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" select="$ico"/>
		</xsl:apply-templates>
	</xsl:template>

    <!-- gr:BusinessEntity's properties -->
    
    <xsl:template match="d:pp">
        <!-- Obor činnosti -->
        <xsl:param name="ico" tunnel="yes"/>
        <xsl:apply-templates>
			<xsl:with-param name="ico" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="d:pp" mode="linked">
        <!-- Obor činnosti -->
        <xsl:param name="ico" tunnel="yes"/>
        <xsl:apply-templates mode="linked">
			<xsl:with-param name="ico" tunnel="yes"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template match="d:t[parent::d:pp]">
        <!-- Obor činnosti -->
        <xsl:param name="ico" tunnel="yes"/>
        <xsl:variable name="schemePath">concept-scheme/organization-activities</xsl:variable>
        <rov:orgActivity rdf:resource="{f:pathIdURI($schemePath, normalize-space(./text()))}"/>
    </xsl:template>
    
    <xsl:template match="d:t[parent::d:osk]">
        <!-- Obor činnosti -->
		<lodares:ostatni xml:lang="cs"><xsl:value-of select="normalize-space(./text())"/></lodares:ostatni>
    </xsl:template>

    <xsl:template match="d:pfo">
        <!-- Právní forma -->
        <rov:orgType rdf:resource="{f:pathIdURI('concept-scheme/organization-types', normalize-space(d:kpf/text()))}"/>    
    </xsl:template>
    
    <xsl:template match="d:psu">
        <!-- Interní příznaky subjektu -->
        <!-- Není blíže určeno ve XML schématu, hodnoty jako "NAAANNNNNNNNNNNNNNNNNNNNANNNNN" -->
    </xsl:template>
    
    <xsl:template match="d:ror/d:sor/d:ssu">
        <!-- Stav subjektu -->
        <rov:orgStatus>
            <skos:Concept>
                <skos:inScheme rdf:resource="{f:pathURI('concept-scheme/organization-statuses')}"/>
                <skos:prefLabel xml:lang="cs"><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
            </skos:Concept>
        </rov:orgStatus>
    </xsl:template>
    
    <!-- Templates for linked resources -->
    
    <xsl:template mode="linked" match="d:t[parent::d:pp]">
        <!-- Obor činnosti -->
        <xsl:param name="ico" tunnel="yes"/>
        <xsl:variable name="schemePath">concept-scheme/organization-activities</xsl:variable>
        <skos:Concept rdf:about="{f:pathIdURI($schemePath, normalize-space(./text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($schemePath)}"/>
            <skos:prefLabel><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel>
        </skos:Concept>
    </xsl:template>

    <xsl:template mode="linked" match="d:si">
		<xsl:param name="ico"/>
		<schema:PostalAddress rdf:about="{f:icoBasedURI($ico,'hq-address')}">
			<schema:streetAddress><xsl:value-of select="concat(normalize-space(d:nu/text()),' ', normalize-space(d:ca/text()))"/></schema:streetAddress>
			<schema:addressLocality><xsl:value-of select="normalize-space(d:n/text())"/></schema:addressLocality>
			<schema:postalCode><xsl:value-of select="normalize-space(d:psc/text())"/></schema:postalCode>
		</schema:PostalAddress>
    </xsl:template>
    
    <xsl:template mode="linked" match="d:pfo[not(d:pfo)]">
        <!-- Právní forma -->
        <xsl:variable name="schemePath">concept-scheme/organization-types</xsl:variable>
        <skos:Concept rdf:about="{f:pathIdURI($schemePath, normalize-space(d:kpf/text()))}">
            <skos:inScheme rdf:resource="{f:pathURI($schemePath)}"/>
            <xsl:apply-templates mode="linked"/>
        </skos:Concept>    
    </xsl:template>
    
    <xsl:template mode="linked" match="d:kpf[parent::d:pfo]">
        <!-- Kód právní formy -->
        <skos:notation><xsl:value-of select="normalize-space(./text())"/></skos:notation>
    </xsl:template>
    
    <xsl:template mode="linked" match="d:npf[parent::d:pfo]">
        <!-- Název právní formy -->
        <skos:prefLabel xml:lang="cs"><xsl:value-of select="normalize-space(./text())"/></skos:prefLabel> 
    </xsl:template>
    
    <!-- Catch-all empty template -->
    <xsl:template mode="#all" match="*|text()|@*"/>
    
</xsl:stylesheet>