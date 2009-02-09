module TagsTooTags
  include Radiant::Taggable

  desc %{ Allows access and optional matching to different parts of the current url path.

    With no arguments, this tag will return a string of the exploded url slugs, separated by whitespace.  This might
    be handy to construct a list of HTML classes corresponding to the current path.  A root page with a slug of
    "/" (the default) will explode to have an imaginary slug of "home".
    
    The following examples assume the site has a page hierarchy like the following (listed as "Page Name (page slug)")
    and the current page is "Web Design"
    
    - Home (/)
      - Services (services)
        - Web Design (web-design)
      
    This:
      
      <body class="<r:path/>">
        <r:url/>
      </body>
      
    Would give:
    
      <body class="home services web-design"
        /services/web-design
      </body>
      
    
    You may also pass an integer to the "at" attribute to access a specific segment of the path.  Based on the above
    setup, if the current page was "Web Design" (i.e. <r:url/> => /services/web-design)
    
    <r:path at="1"/>  => 'home'        # Root is 1-based...
    <r:path at="0"/>  => 'home'        # ... but '0' also grabs the root
    <r:path at="2"/>  => 'services'
    <r:path at="3"/>  => 'web-design'
    <r:path at="4"/>  => ''            # Nothing here...
    <r:path at="-1"/> => 'web-design'  # Negative values count back from the end, so -1 gets the last slug
    
    * Use Case:
    
    Say you have the following site tree:
    
    - Home (/)
      - Articles (/articles)
        - Awesome Article (/articles/awesome-article)
        - Super Article (/articles/super-article)
        
    And for styling purposes you want to always be able to know what 2nd level page tree you are within.  The
    following example shows one way to achieve this.
    
      <head>
        <style>
          .articles .list li {
            /* special list styling */
          }
        </style>
      </head>
      <body class="<r:path at='2'/>"
        <ul class="list">
          <r:children:each>
          <li><r:link/></li>
          </r:children:each>
        </ul>
      </body>
  }
  tag "path" do |tag|
    path_parts = tag.locals.page.url.split('/')
    if (root = Page.find_by_parent_id(nil)) && root.slug == '/'
      path_parts.unshift('home')
    end

    if at = tag.attr['at']
      # The root path is based at level 1, so if 0 is passed, assume 1.  If negative, count from the end, so -1 is
      # the last path element.  Otherwise, just grab the path element at the specified "at" minus 1
      at = at.to_i
      at = (at == 0) ? 0 : (at < 0) ? at : at - 1
      path_parts[at]
    else
      path_parts.join(' ')
    end
  end
end