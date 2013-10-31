<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:are="http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_answer_basic/v_1.0.3"
    xmlns:D="http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_datatypes/v_1.0.3"
    xmlns:U="http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/uvis_datatypes/v_1.0.3"
    xmlns:f="http://opendata.cz/xslt/functions#"
    exclude-result-prefixes="xs are D U f"
    
    xmlns:adms="http://www.w3.org/ns/adms#"
    xmlns:dcterms="http://purl.org/dc/terms/"
    xmlns:gr="http://purl.org/goodrelations/v1#"
    xmlns:lex="http://purl.org/lex#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rov="http://www.w3.org/ns/regorg#"
    xmlns:schema="http://schema.org/"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:void="http://rdfs.org/ns/void#"
    version="2.0">
    
    <!--
        Seznam zkratek: http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/documentation/zkr_103.txt
        XML schéma: http://wwwinfo.mfcr.cz/ares/xml_doc/schemas/ares/ares_datatypes/v_1.0.3/ares_datatypes_v_1.0.3.xsd
    -->
    
    <xsl:param name="namespace">http://linked.opendata.cz/resource/</xsl:param>
    <xsl:variable name="baseURI" select="concat($namespace, 'wwwinfo.mfcr.cz/ares/')"/>
    <xsl:variable name="icoScheme" select="concat($namespace, 'concept-scheme/CZ-ICO')"/>
    <xsl:strip-space elements="*"/>

    <xsl:output encoding="UTF-8" indent="yes" method="xml" normalization-form="NFC"/>
    
    <xsl:function name="f:classURI" as="xs:anyURI">
        <xsl:param name="classLabel" as="xs:string"/>
        <xsl:param name="id" as="xs:string"/>
        <xsl:value-of select="f:pathIdURI(encode-for-uri(replace(lower-case($classLabel), '\s', '-')), $id)"/>
    </xsl:function>
    
    <xsl:function name="f:icoBasedURI" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="fragment" as="xs:string"/>
        <xsl:value-of select="concat(f:classURI('Business entity', $ico), '/', $fragment)"/>
    </xsl:function>
    
    <xsl:function name="f:icoBasedAddressURI" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="context" as="node()"/>
        <xsl:value-of select="f:icoBasedURI($ico, concat('postal-address/', generate-id($context)))"/>
    </xsl:function>
    
    <xsl:function name="f:pathIdURIWithICOFallback" as="xs:anyURI">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:param name="path" as="xs:string"/>
        <xsl:param name="id" as="node()*"/>
        <xsl:param name="context" as="node()"/>
        <xsl:choose>
            <xsl:when test="$id">
                <xsl:value-of select="f:pathIdURI($path, $id)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="f:icoBasedURI($ico, concat($path, '/', generate-id($context)))"/>
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
        <xsl:value-of select="concat(f:pathURI($path), '/', encode-for-uri($id))"/>
    </xsl:function>
    
    <xsl:function name="f:prefixICO" as="xs:string">
        <xsl:param name="ico" as="xs:string"/>
        <xsl:value-of select="concat('CZ', $ico)"/>
    </xsl:function>
    
    <xsl:template match="are:Ares_odpovedi">
        <rdf:RDF>
            <xsl:apply-templates/>
        </rdf:RDF>
    </xsl:template>
    
    <xsl:template match="are:Odpoved">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="D:VBAS">
        <xsl:variable name="ico" select="f:prefixICO(D:ICO/text())"/>
        <gr:BusinessEntity rdf:about="{f:classURI('Business Entity', $ico)}">
            <rdf:type rdf:resource="http://www.w3.org/ns/regorg#RegisteredOrganization"/>
            <rov:registration rdf:resource="{f:classURI('Identifier', $ico)}"/>
            <gr:legalName><xsl:value-of select="D:OF"/></gr:legalName>
            <xsl:apply-templates>
                <xsl:with-param name="ico" tunnel="yes" select="$ico"/>
            </xsl:apply-templates>
        </gr:BusinessEntity>    
        <xsl:apply-templates mode="linked">
            <xsl:with-param name="ico" tunnel="yes" select="$ico"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- gr:BusinessEntity's properties -->
    
    <xsl:template match="D:AA">
        <!-- Adresa ARES -->
        <xsl:param name="ico" tunnel="yes"/>
        <schema:address rdf:resource="{f:pathIdURIWithICOFallback($ico, 'postal-address', D:IDA, .)}"/>
    </xsl:template>
    
    <xsl:template match="D:AD">
        <!-- Adresa doručovací -->
        <xsl:param name="ico" tunnel="yes"/>
        <schema:address rdf:resource="{f:icoBasedAddressURI($ico, .)}"/>
    </xsl:template>
    
    <xsl:template match="D:Nace">
        <!-- NACE kódy -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="D:NACE">
        <!-- NACE kód -->
        <xsl:param name="ico" tunnel="yes"/>
        <rov:orgActivity rdf:resource="{f:pathIdURIWithICOFallback($ico, 'concept-scheme/nace', text(), .)}"/>
    </xsl:template>
    
    <xsl:template match="D:Obory_cinnosti">
        <!-- Obory činnosti -->
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="D:Obor_cinnosti">
        <!-- Obor činnosti -->
        <xsl:param name="ico" tunnel="yes"/>
        <rov:orgActivity rdf:resource="{f:pathIdURIWithICOFallback($ico, 'concept-scheme/organization-activities', D:K, .)}"/>
    </xsl:template>
    
    <xsl:template match="D:PF">
        <!-- Právní forma -->
        <rov:orgType rdf:resource="{f:pathIdURI('concept-scheme/organization-types', D:KPF/text())}"/>    
    </xsl:template>
    
    <xsl:template match="D:PPI/D:PP/D:T">
        <!-- Předměty podnikání -->
        <rov:orgActivity>
            <skos:Concept>
                <skos:prefLabel xml:lang="cs"><xsl:value-of select="."/></skos:prefLabel>
            </skos:Concept>
        </rov:orgActivity>
    </xsl:template>
    
    <xsl:template match="D:PSU">
        <!-- Interní příznaky subjektu -->
        <!-- Není blíže určeno ve XML schématu, hodnoty jako "NAAANNNNNNNNNNNNNNNNNNNNANNNNN" -->
    </xsl:template>
    
    <xsl:template match="D:ROR/D:SOR/D:SSU">
        <!-- Stav subjektu -->
        <rov:orgStatus>
            <skos:Concept>
                <skos:inScheme rdf:resource="{f:pathURI('concept-scheme/organization-statuses')}"/>
                <skos:prefLabel xml:lang="cs"><xsl:value-of select="."/></skos:prefLabel>
            </skos:Concept>
        </rov:orgStatus>
    </xsl:template>
    
    <!-- lex:Court's properties -->
    
    <xsl:template mode="court" match="D:K">
        <adms:identifier>
            <adms:Identifier>
                <skos:inScheme rdf:resource="{$icoScheme}"/>
                <skos:notation><xsl:value-of select="."/></skos:notation>
            </adms:Identifier>
        </adms:identifier>
    </xsl:template>
    
    <xsl:template mode="court" match="D:T">
        <dcterms:title xml:lang="cs"><xsl:value-of select="."/></dcterms:title>
    </xsl:template>
    
    <!-- Templates for linked resources -->
    
    <xsl:template mode="linked" match="D:ICO">
        <adms:Identifier rdf:about="{f:classURI('Identifier', f:prefixICO(text()))}">
            <skos:notation><xsl:value-of select="text()"/></skos:notation>
            <skos:inScheme rdf:resource="{$icoScheme}"/>
            <adms:schemeAgency xml:lang="cs">Český statistický úřad</adms:schemeAgency>
            <xsl:apply-templates mode="identifier" select="../D:DV|../D:ROR/D:SZ/D:SD"/>
        </adms:Identifier>
    </xsl:template>
    
    <xsl:template mode="identifier" match="D:DV">
        <!-- Datum vydání -->
        <dcterms:issued rdf:datatype="http://www.w3.org/2001/XMLSchema#date"><xsl:value-of select="."/></dcterms:issued>
    </xsl:template>
    
    <xsl:template mode="identifier" match="D:ROR/D:SZ/D:SD">
        <!-- Registrace subjektu u soudu -->
        <!-- TODO: Nalinkovat na http://linked.opendata.cz/resource/dataset/court/cz? -->
        <dcterms:creator>
            <lex:Court>
                <xsl:apply-templates mode="court"/>
            </lex:Court>
        </dcterms:creator>
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:AA">
        <!-- Adresa ARES -->
        <xsl:param name="ico" tunnel="yes"/>
        <schema:PostalAddress rdf:about="{f:pathIdURIWithICOFallback($ico, 'postal-address', D:IDA, .)}">
            <xsl:apply-templates mode="linked"/>
        </schema:PostalAddress>    
    </xsl:template>
    
    <xsl:template mode="linked" match="D:AD">
        <!-- Adresa doručovací -->
        <xsl:param name="ico" tunnel="yes"/>
        <schema:PostalAddress rdf:about="{f:icoBasedAddressURI($ico, .)}">
            <xsl:apply-templates mode="linked"/>
        </schema:PostalAddress>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:AT[parent::D:AA]">
        <!-- Adresa textem -->
        <schema:description><xsl:value-of select="."/></schema:description>    
    </xsl:template>
    
    <xsl:template mode="linked" match="D:CD[parent::D:AA]|D:CA[parent::D:AA]">
        <!-- Číslo domu -->
        <xsl:variable name="cislo_orientacni" select="../D:CO"/>
        <xsl:variable name="nazev_obce" select="../D:N"/>
        <xsl:variable name="ulice" select="../D:NU"/>
        <xsl:variable name="cislo">
            <xsl:choose>
                <xsl:when test="$cislo_orientacni"><xsl:value-of select="concat(., '/', $cislo_orientacni)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <schema:streetAddress>
            <xsl:choose>
                <xsl:when test="not($ulice) and $nazev_obce"><xsl:value-of select="concat($nazev_obce, ' ', $cislo)"/></xsl:when>
                <xsl:otherwise><xsl:value-of select="concat($ulice, ' ', $cislo)"/></xsl:otherwise>
            </xsl:choose>
        </schema:streetAddress>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:N[parent::D:AA]">
        <!-- Název obce -->
        <xsl:variable name="nazev_casti_obce" select="../D:NCO"/>
        <xsl:variable name="nazev_mestske_casti" select="../D:NMC"/>
        <xsl:variable name="nazev">
            <xsl:choose>
                <xsl:when test="$nazev_casti_obce and $nazev_mestske_casti">
                    <xsl:value-of select="concat(., ', ', $nazev_mestske_casti, ' - ', $nazev_casti_obce)"/>
                </xsl:when>
                <xsl:when test="$nazev_casti_obce and not($nazev_mestske_casti)">
                    <xsl:value-of select="concat(., ', ', $nazev_casti_obce)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <schema:addressLocality><xsl:value-of select="$nazev"/></schema:addressLocality>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:NOK[parent::D:AA]">
        <!-- Název okresu -->
        <schema:addressRegion><xsl:value-of select="."/></schema:addressRegion>    
    </xsl:template>
    
    <xsl:template mode="linked" match="D:NS[parent::D:AA]">
        <!-- Název státu -->
        <schema:addressCountry><xsl:value-of select="."/></schema:addressCountry>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:Nace">
        <!-- NACE kódy -->
        <xsl:apply-templates mode="linked"/>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:NACE">
        <!-- NACE kód -->
        <xsl:param name="ico" tunnel="yes"/>
        <skos:Concept rdf:about="{f:pathIdURIWithICOFallback($ico, 'concept-scheme/nace', text(), .)}">
            <skos:inScheme rdf:resource="http://ec.europa.eu/eurostat/ramon/rdfdata/nace_r2"/>
            <xsl:apply-templates mode="linked"/>
        </skos:Concept>  
    </xsl:template>
    
    <xsl:template mode="linked" match="text()[parent::D:NACE]">
        <skos:notation><xsl:value-of select="."/></skos:notation>    
    </xsl:template>
    
    <xsl:template mode="linked" match="D:Obory_cinnosti">
        <!-- Obory činnosti -->
        <xsl:apply-templates mode="linked"/>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:Obor_cinnosti">
        <!-- Obor činnosti -->
        <xsl:param name="ico" tunnel="yes"/>
        <xsl:variable name="schemePath">concept-scheme/organization-activities</xsl:variable>
        <skos:Concept rdf:about="{f:pathIdURIWithICOFallback($ico, $schemePath, D:K, .)}">
            <skos:inScheme rdf:resource="{f:pathURI($schemePath)}"/>
            <xsl:apply-templates mode="linked"/>
        </skos:Concept>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:K[parent::D:Obor_cinnosti]">
        <!-- Kód oboru činnosti -->
        <skos:notation><xsl:value-of select="."/></skos:notation>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:T[parent::D:Obor_cinnosti]">
        <!-- Název oboru činnosti -->
        <skos:altLabel xml:lang="cs"><xsl:value-of select="."/></skos:altLabel>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:PSC[parent::D:AA]|D:Zahr_PSC[parent::D:AA]">
        <!-- Poštovní směrovací číslo, zahraniční PSČ -->
        <schema:postalCode><xsl:value-of select="."/></schema:postalCode>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:PB[parent::D:AD]">
        <!-- PSČ a obec -->
        <xsl:analyze-string select="." regex="(\d{{5}})\s+(\w{{1,54}})">
            <xsl:matching-substring>
                <schema:postalCode><xsl:value-of select="regex-group(1)"/></schema:postalCode>
                <schema:addressLocality><xsl:value-of select="regex-group(2)"/></schema:addressLocality>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <schema:description><xsl:value-of select="."/></schema:description>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:UC[parent::D:AD]">
        <!-- Ulice a číslo -->
        <schema:streetAddress><xsl:value-of select="."/></schema:streetAddress>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:PF">
        <!-- Právní forma -->
        <xsl:variable name="schemePath">concept-scheme/organization-types</xsl:variable>
        <skos:Concept rdf:about="{f:pathIdURI($schemePath, D:KPF/text())}">
            <skos:inScheme rdf:resource="{f:pathURI($schemePath)}"/>
            <xsl:apply-templates mode="linked"/>
        </skos:Concept>    
    </xsl:template>
    
    <xsl:template mode="linked" match="D:KPF[parent::D:PF]">
        <!-- Kód právní formy -->
        <skos:notation><xsl:value-of select="."/></skos:notation>
    </xsl:template>
    
    <xsl:template mode="linked" match="D:NPF[parent::D:PF]">
        <!-- Název právní formy -->
        <skos:prefLabel xml:lang="cs"><xsl:value-of select="."/></skos:prefLabel> 
    </xsl:template>
    
    <!-- Catch-all empty template -->
    <xsl:template mode="#all" match="*|text()|@*"/>
    
</xsl:stylesheet>