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
    ?address ruian:cisloDomovni ?cp ;
      ruian:cisloOrientacni ?co ;
      ruian:cisloOrientacniPismeno ?cop .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address schema:streetAddress ?streetAddress .
    OPTIONAL {
      ?address schema:addressCountry ?country .
    }
    FILTER (!BOUND(?country) || ?country = "CZ")
    
    FILTER REGEX(?streetAddress, "^\\d+\\/?\\d*[a-zA-Z]?$")
    BIND (REPLACE(?streetAddress, "^(\\d+)\\/?\\d*[a-zA-Z]?$", "$1") AS ?cp)
    BIND (REPLACE(?streetAddress, "^\\d+\\/?(\\d+)[a-zA-Z]?$", "$1") AS ?co)
    BIND (REPLACE(?streetAddress, "^\\d+\\/?\\d*([a-zA-Z])?$", "$1") AS ?cop)
  }
}
