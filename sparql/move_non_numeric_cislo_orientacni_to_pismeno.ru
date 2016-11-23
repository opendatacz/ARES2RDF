PREFIX ares:   <http://linked.opendata.cz/resource/dataset/ares/>
PREFIX ruian:  <http://ruian.linked.opendata.cz/ontology/>

DELETE {
  GRAPH ?g {
    ?address ruian:cisloOrientacni ?orientationalNumber .
  }
}
INSERT {
  GRAPH ?g {
    ?address ruian:cisloOrientacniPismeno ?orientationalNumber .
  }
}
WHERE {
  VALUES ?g {
    ares:or
    ares:rzp
  }
  GRAPH ?g {
    ?address ruian:cisloOrientacni ?orientationalNumber .
    FILTER (!REGEX(?orientationalNumber, "^\\d+$"))
  }
}
