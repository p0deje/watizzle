if (typeof Sizzle.selectors.pseudos.regexp == 'undefined') {
  Sizzle.selectors.pseudos.regexp =
    Sizzle.selectors.createPseudo(function(selector) {
      var selectors = selector.match(/^([^,]+), (.+)$/);
      var attr = selectors[1];
      var flags = selectors[2].replace(/.*\/([gimy]*)$/, '$1');
      var pattern = selectors[2].replace(new RegExp('^/(.*?)/' + flags + '$'), '$1');
      var regexp = new RegExp(pattern, flags);
      return function(el) {
        switch (attr) {
          case "text":
            var value = el.textContent;
            break;
          case "href":
            var value = el.getAttribute('href');
            if (value) {
              value = value.replace(/^\s+|\s+$/g, ''); // strip spaces
            }
            break;
          default:
            var value = el.getAttribute(attr);
       }
       return regexp.test(value);
      }
    });
}
