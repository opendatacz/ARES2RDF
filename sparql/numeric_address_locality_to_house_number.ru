PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?address schema:addressLocality ?addressLocality .
  }
}
INSERT {
  GRAPH ?g {
    ?address ruian:cisloDomovni ?addressLocality .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address schema:addressLocality ?addressLocality .
    FILTER REGEX(?addressLocality, "^\\d+$")
  }
}
