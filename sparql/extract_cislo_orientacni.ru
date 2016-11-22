PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

INSERT {
  GRAPH ?g {
    ?address ruian:cisloOrientacni ?co ;
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
    
    FILTER REGEX(?streetAddress, "^.*č\\.?or?\\.\\s*(\\d+).*$")
    BIND (REPLACE(?streetAddress, "^.*č\\.?or?\\.\\s*(\\d+).*$", "$1") AS ?co)
    BIND (REPLACE(?streetAddress, "^.*č\\.?or?\\.\\s*(\\d+)([a-zA-Z])?.*$", "$2") AS ?cop)
  }
}
