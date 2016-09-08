if (typeof Sizzle.selectors.pseudos.visible == 'undefined') {
  Sizzle.selectors.pseudos.visible =
    Sizzle.selectors.createPseudo(function() {
      return function(el) {
        return (el.offsetWidth > 0 || el.offsetHeight > 0)
      }
    });
}
