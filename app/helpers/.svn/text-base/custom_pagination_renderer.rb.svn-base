class CustomPaginationRenderer < WillPaginate::LinkRenderer
  @@id = 1
  def to_html
    links = @options[:page_links] ? windowed_links : []
    # previous/next buttons
    links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
    links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
    html = links.join(@options[:separator])
    html += goto_box
    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
  end

#  def to_html
#    links = @options[:page_links] ? windowed_links : []
#    # previous/next buttons
#    links.unshift page_link_or_span(@collection.previous_page, 'disabled prev_page', @options[:previous_label])
#    links.push    page_link_or_span(@collection.next_page,     'disabled next_page', @options[:next_label])
#
#    html = links.join(@options[:separator])
#    @options[:container] ? @template.content_tag(:div, html, html_attributes) : html
#  end

  private
  def goto_box
    @@id += 1
    @@id = 1 if @@id > 100
  <<-GOTO
    <input type="text" maxlength="5" size="3" id="page#{@@id}" />
    <input type="submit" onclick="goto_page#{@@id}()" value="确定"/>
    <script type="text/javascript">
      function goto_page#{@@id}()
      {
        page = Number($('page#{@@id}').value)
        total = #{total_pages}
        if(page < 1 || page > total)
        {
          alert('Please enter a number between 1 and ' + total + '!')
          return;
        }
        var link = '#{url_for("_page")}'
        var new_link = link.replace("_page", page)
        window.location.assign(new_link)
      }
    </script>
    GOTO
  end

    # Returns URL params for +page_link_or_span+, taking the current GET params
    # and <tt>:params</tt> option into account.
    def url_for(page)
      page_one = page == 1
      unless @url_string and !page_one
        @url_params = {}
        # page links should preserve GET parameters
        stringified_merge @url_params, @template.params if @template.request.get?
        stringified_merge @url_params, @options[:params] if @options[:params]

        if complex = param_name.index(/[^\w-]/)
          page_param = (defined?(CGIMethods) ? CGIMethods : ActionController::AbstractRequest).
            parse_query_parameters("#{param_name}=#{page}")

          stringified_merge @url_params, page_param
        else
          @url_params[param_name] = page_one ? 1 : 2
        end

        url = @template.url_for(@url_params)
        return url if page_one

        if complex
          @url_string = url.sub(%r!((?:\?|&amp;)#{CGI.escape param_name}=)#{page}!, '\1@')
          return url
        else
          @url_string = url
          @url_params[param_name] = 3
          @template.url_for(@url_params).split(//).each_with_index do |char, i|
            if char == '3' and url[i, 1] == '2'
              @url_string[i] = '@'
              break
            end
          end
        end
      end
      # finally!
      @url_string.sub '@', page.to_s
    end

end
