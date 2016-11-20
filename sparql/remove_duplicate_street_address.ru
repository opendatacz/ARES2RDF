PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?postalAddress schema:streetAddress ?streetAddress1 .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?postalAddress a schema:PostalAddress ;
      schema:streetAddress ?streetAddress1, ?streetAddress2 ;
      ruian:cisloDomovni ?houseNumber .
    FILTER (!sameTerm(?streetAddress1, ?streetAddress2)
            &&
            strstarts(?streetAddress1, ?streetAddress2)
            &&
            contains(?streetAddress1, ?houseNumber)
            &&
            !contains(?streetAddress2, ?houseNumber))
  }
}
