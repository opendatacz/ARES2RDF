PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?address schema:streetAddress ?_streetAddress .
  }
}
INSERT {
  GRAPH ?g {
    ?address schema:streetAddress ?streetAddress .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address schema:streetAddress ?_streetAddress .
    FILTER REGEX(?_streetAddress, "\\d\\.[a-z]")
    BIND (REPLACE(?_streetAddress, "(\\d\\.)([a-z])", "$1 $2") AS ?streetAddress)
  }
}
