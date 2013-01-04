module Embedder
  def embed_urls(content, include_titles=true)
    if content
      urls = URI.extract(ActionView::Base.full_sanitizer.sanitize(content))
      unless urls.empty?
        urls.each do |url|
          uri = URI.parse url
          if uri.path =~ /(\.png|\.jpg|\.gif)$/

            repl = '<img src="\1" class="embed-urls"/>'
            content.gsub! /[^"'=](http[s]*:\/\/\S+(\.png|\.jpg|\.gif))/, repl
            urls.delete url
          end
        end
      end
      unless urls.empty?
        embedly_api = Embedly::API.new :user_agent => 'Mozilla/5.0 (compatible; 1kplus/1.0; team@1kpl.us)', :key => '1294316ebbf54647985e969e842cc530'
        objs = embedly_api.oembed(
          :urls => urls.dup,
          :maxwidth => 850,
          :wmode => 'transparent',
          :method => 'after'
        )

        h = Hash[urls.zip(objs)]
        h.each do |url, embed|

          #self.title = embed.title unless self.title
          content.gsub! url, embed_tpl(embed, include_titles)
          urls.delete url
        end
      end
      unless urls.empty?
        #urls.each do |url|
        #  repl = '<a href="\1" class=\"embed-urls\" target="_blank">\1</a>'
        #  content.gsub! /[^"'=](http[s]*:\/\/\S+)/, repl
        #  urls.delete url
        #end
      end


    end
    content
  end

  def embed_tpl(e, include_titles = true)
    rv =   ""
    rv +=  "<div class=\"embed-title\"><a href=\"#{e.url}\"class=\"embed-url\" target=\"_blank\">#{e.title}</a></div>" if include_titles

    if e.thumbnail_url && e.type != "video"
      rv += "<img src=\"#{e.thumbnail_url}\" height=\"#{e.thumbnail_height}\" width=\"#{e.thumbnail_width}\" class=\"embed-thumbnail\"/>"
    end
    if e.html
      rv += "<div class=\"embed-html\">#{e.html}</div>"
    else
      rv += "<p class=\"embed-description\">#{e.description}</p>"
    end
    "<div class=\"embed-container\">#{rv}</div>"
  end
end