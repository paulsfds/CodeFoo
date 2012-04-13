$(function () {
    Response.create({
        prop: "width"  // "width" "device-width" "height" "device-height" or "device-pixel-ratio"
      , prefix: "min-width- r src"  // the prefix(es) for your data attributes (aliases are optional)
      , breakpoints: [1281,1025,961,641,481,320,0] // min breakpoints (defaults for width/device-width)
      , lazy: true // optional param - data attr contents lazyload rather than whole page at once
    });
});
