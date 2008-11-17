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
      
    Might give:
    
      <body class="home services web-design"
        /services/web-design
      </body>
      
    
    *Usage:*
    
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
  
  desc %{
    Helps add SEO-friendly page titles to your <title> tag.  <r:seo_title/> will be replaced by the Radiant
    "Keywords" field unless it is blank.  If it is blank, the default Page Title will be inserted.
  
    I chose the "Keywords" field to control my page title since the actual meta keywords are of questionable SEO
    value, but rich page titles are definitely of high SEO value.
  }
  tag "seo_title" do |tag|
    page = tag.locals.page
    page.keywords.blank? ? page.title : page.keywords
  end
end