PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>
PREFIX schema: <http://schema.org/>

INSERT {
  GRAPH ?g {
    ?address schema:streetAddress ?streetAddress ;
      ruian:cisloDomovni ?cp ;
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
    ?address schema:streetAddress ?_streetAddress .
    FILTER NOT EXISTS {
      ?address schema:addressCountry [] .
    }
    # Switched order between číslo orientační and číslo popisné
    FILTER REGEX(?_streetAddress, "^.*\\s+\\d+[a-zA-Z]\\/\\d+$")
    BIND (REPLACE(?_streetAddress, "^(.*)\\s+\\d+[a-zA-Z]\\/\\d+$", "$1") AS ?streetAddress)
    BIND (REPLACE(?_streetAddress, "^.*\\s+(\\d+)[a-zA-Z]\\/\\d+$", "$1") AS ?co)
    BIND (REPLACE(?_streetAddress, "^.*\\s+\\d+([a-zA-Z])\\/\\d+$", "$1") AS ?cop)
    BIND (REPLACE(?_streetAddress, "^.*\\s+\\d+[a-zA-Z]\\/(\\d+)$", "$1") AS ?cp)
  }
}
