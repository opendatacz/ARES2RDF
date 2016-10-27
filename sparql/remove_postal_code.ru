PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?address schema:streetAddress ?_streetAddress .
  }
}
INSERT {
  GRAPH ?g {
    ?address schema:streetAddress ?streetAddress ;
      schema:postalCode ?postalCode .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address schema:streetAddress ?_streetAddress .
    FILTER REGEX(?_streetAddress, "\\d{3}\\s\\d{2}")
    BIND (REPLACE(?_streetAddress, "\\s*\\d{3}\\s\\d{2}", "") AS ?streetAddress)
    OPTIONAL {
      ?address schema:postalCode ?_postalCode .
    }
    BIND (COALESCE(?_postalCode, REPLACE(?_streetAddress, "(\\d{3})\\s(\\d{2})", "$1$2")) AS ?postalCode)
  }
}
