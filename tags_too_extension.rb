class TagsTooExtension < Radiant::Extension
  version "0.1"
  description "Helpful Radius tags not (yet) found in the Radiant core standard tags"
  url "http://webadvocate.com"

  def activate
    Page.class_eval do
      include TagsTooTags
    end
  end
end