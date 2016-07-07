/* -*- Mode: Javascript; indent-tabs-mode:nil; js-indent-level: 2 -*- */
/* vim: set ts=2 et sw=2 tw=80: */

/*************************************************************
 *
 *  /MathJax/unpacked/config/TeX-AMS-MML_SVG.js
 *
 *  Copyright (c) 2010-2013 The MathJax Consortium
 *
 *  Part of the MathJax library.
 *  See http://www.mathjax.org for details.
 *
 *  Licensed under the Apache License, Version 2.0;
 *  you may not use this file except in compliance with the License.
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 */

MathJax.Hub.Config({
  showMathMenu: false,
  showMathMenuMSIE: false,
  showProcessingMessages: false,
  messageStyle: "none",
  skipStartupTypeset: false,
  extensions: ["tex2jax.js", "TeX/AMSmath.js", "TeX/AMSsymbols.js"],
  jax: ["input/TeX", "output/SVG"],
  tex2jax: {
    inlineMath: [
      ['$','$']
    ],
    displayMath: [
      ['$$','$$']
    ],
    balanceBraces: true,
    skipTags: ["script","noscript","style","textarea","pre","code","annotation","annotation-xml"],
    ignoreClass: "tex2jax_ignore",
    processClass: "tex2jax_process",
    processEscapes: false,
    processEnvironments: true,
    processRefs: true,
    preview: "TeX"
  }
});

MathJax.Ajax.loadComplete("[MathJax]/config/custom.js");
