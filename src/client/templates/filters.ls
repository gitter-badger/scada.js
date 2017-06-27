require! 'cheerio'


export pug-filters =
    # use "my-own-filter" in the pug page as follows:
    #
    #     :my-own-filter(addStart addEnd) Hello
    #
    # which will print the following output:
    #
    #     Start: Hello. The end.
    #
    'my-own-filter': (text, options) ->
        text = "Start: #{text}" if options.addStart
        text = "#{text}. The end." if options.addEnd
        text

    strip-svg: (contents, options) ->
        svg = contents.replace /<\?xml.*\?>/, ''
        if options.getPath
            $ = cheerio.load svg
            $ 'path[id=progress]' .attr 'd'
        else
            svg


test-str = '''
    <?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <svg
       xmlns:dc="http://purl.org/dc/elements/1.1/"
       xmlns:cc="http://creativecommons.org/ns#"
       xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
       xmlns:svg="http://www.w3.org/2000/svg"
       xmlns="http://www.w3.org/2000/svg"
       xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
       xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
       version="1.1"
       x="0px"
       y="0px"
       viewBox="0 0 100 100"
       id="svg6"
       sodipodi:docname="heart.svg"
       inkscape:version="0.92.1 r15371">
      <metadata
         id="metadata12">
        <rdf:RDF>
          <cc:Work
             rdf:about="">
            <dc:format>image/svg+xml</dc:format>
            <dc:type
               rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
          </cc:Work>
        </rdf:RDF>
      </metadata>
      <defs
         id="defs10" />
      <sodipodi:namedview
         pagecolor="#ffffff"
         bordercolor="#666666"
         borderopacity="1"
         objecttolerance="10"
         gridtolerance="10"
         guidetolerance="10"
         inkscape:pageopacity="0"
         inkscape:pageshadow="2"
         inkscape:window-width="776"
         inkscape:window-height="480"
         id="namedview8"
         showgrid="false"
         inkscape:zoom="2.36"
         inkscape:cx="50"
         inkscape:cy="50"
         inkscape:window-x="0"
         inkscape:window-y="21"
         inkscape:window-maximized="0"
         inkscape:current-layer="svg6" />
      <path
         d="M 81.495,13.923 C 70.127,8.662 55.261,13.612 50.006,24.955 44.74,13.612 29.879,8.657 18.511,13.923 6.402,19.539 0.613,33.883 10.175,50.804 16.967,62.844 29.001,71.915 50.006,88.183 70.999,71.915 83.039,62.839 89.825,50.804 99.387,33.883 93.598,19.539 81.495,13.923 Z"
         id="progress"
         inkscape:connector-curvature="0"
         style="display:inline;fill-opacity:0;stroke:#ed6a5a;stroke-width:3" />
    </svg>
    '''

#console.log pug-filters.strip-svg test-str, {+get-path}
