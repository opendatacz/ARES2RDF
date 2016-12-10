PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

DELETE {
  GRAPH ?g {
    ?address schema:streetAddress ?_streetAddress .
  }
}
INSERT {
  GRAPH ?g {
    ?address schema:streetAddress ?streetAddress ;
      ruian:cisloDomovni ?houseNumber .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  } 
  GRAPH ?g {
    ?address schema:streetAddress ?_streetAddress .
    OPTIONAL {
      ?address schema:addressCountry ?country .
    }
    FILTER (!BOUND(?country) || ?country = "CZ")

    FILTER REGEX(?_streetAddress, "\\s+\\d+$")
    BIND (REPLACE(?_streetAddress, "(\\s+\\d+)$", "") AS ?streetAddress)
    BIND (REPLACE(?_streetAddress, "^.*\\s+(\\d+)$", "$1") AS ?houseNumber)
  }
}
