PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?address schema:addressLocality ?_addressLocality .
  }
}
INSERT {
  GRAPH ?g {
    ?address schema:addressLocality ?addressLocality .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address schema:addressLocality ?_addressLocality .
    FILTER REGEX(?_addressLocality, "^Praha\\s*-")
    BIND (REPLACE(?_addressLocality, "^Praha\\s*-\\s*", "") AS ?addressLocality)
  }
}
