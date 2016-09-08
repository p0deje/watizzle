if (typeof Sizzle.selectors.pseudos.hidden == 'undefined') {
  Sizzle.selectors.pseudos.hidden =
    Sizzle.selectors.createPseudo(function() {
      return function(el) {
        return (el.offsetWidth <= 0 || el.offsetHeight <= 0)
      }
    });
}
