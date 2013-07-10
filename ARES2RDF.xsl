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
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:skos="http://www.w3.org/2004/02/skos/core#"
    xmlns:void="http://rdfs.org/ns/void#"
    version="2.0">
    
    <xsl:param name="namespace">http://linked.opendata.cz/resource/</xsl:param>
    <xsl:variable name="baseURI" select="concat($namespace, 'wwwinfo.mfcr.cz/ares/')"/>
    
    <xsl:output encoding="UTF-8" indent="yes" method="xml"/>
    
    <xsl:function name="f:getURI" as="xs:anyURI">
        <xsl:param name="classLabel" as="xs:string"/>
        <xsl:param name="id" as="xs:token"/>
        <xsl:value-of select="concat($baseURI, encode-for-uri(replace(lower-case($classLabel), '\s', '-')), '/', encode-for-uri($id))"/>
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
        <xsl:variable name="ico" select="D:ICO/text()"/>
        <gr:BusinessEntity rdf:about="{f:getURI('Business Entity', $ico)}">
            <adms:identifier>
                <adms:Identifier rdf:about="{f:getURI('Identifier', $ico)}">
                    <skos:notation><xsl:value-of select="$ico"/></skos:notation>
                </adms:Identifier>
            </adms:identifier>
            <gr:legalName><xsl:value-of select="D:OF"/></gr:legalName>
        </gr:BusinessEntity>    
    </xsl:template>
    
    <!-- Catch all empty template -->
    <xsl:template match="text()|@*"/>
    
</xsl:stylesheet>