PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

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
    
    FILTER REGEX(?streetAddress, "^.*č\\.?p\\.\\s*(\\d+).*$")
    BIND (REPLACE(?streetAddress, "^.*č\\.?p\\.\\s*(\\d+).*$", "$1") AS ?cp)
    BIND (REPLACE(?streetAddress, "^.*č\\.?p\\.\\s*\\d+\\/?(\\d+)?.*$", "$1") AS ?co)
    BIND (REPLACE(?streetAddress, "^.*č\\.?p\\.\\s*\\d+\\/?\\d*([a-zA-Z])?.*$", "$1") AS ?cop)
  }
}
