PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?address schema:streetAddress ?houseNumber .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address schema:streetAddress ?houseNumber ;
      ruian:cisloDomovni ?houseNumber .
  }
}
