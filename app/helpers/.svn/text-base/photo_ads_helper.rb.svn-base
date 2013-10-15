module PhotoAdsHelper
  def page_title
    if controller.controller_name == "photo_ads" && controller.action_name == "index"
      "图库广告"
    elsif controller.controller_name == "photo_ads" && controller.action_name == "new"
      "添加图库广告"
    elsif controller.controller_name == "photo_ads" && controller.action_name == "edit"
      "编辑图库广告"
    elsif controller.controller_name == "photo_ads" && controller.action_name == "show"
      "显示图库广告"
    end
  end

  def common_actions
    actions = ""
		if controller.controller_name == "photo_ads"
			actions << "#{link_to '添加广告代码', new_photo_ad_path}"
    end
  end

  # This helper method is used to generate the javascript to execute on the client
  # It assumes that the function update_select_options is already in the open document
  #
  # Options
  # :text - The method to use on collection objects to get the text for the option
  # :value - The method to use on collection objects to get the value attribute for the option
  # :include_blank - Includes a blank option at the top of cascaded boxes
  # :clear - An array that contains the dom id's of select boxes to clear when target_dom_id changes
  def update_select_box(target_dom_id, collection, options={})
    # Set the default options
    options[:text] ||= 'name'
    options[:value] ||= 'id'
    options[:include_blank] = true if options[:include_blank].nil?
    options[:clear] ||= []
    pre = options[:include_blank] ? [['','']] : []

    out = "update_select_options( $('" << target_dom_id.to_s << "'),"
    out << "#{(pre + collection.collect{ |c| [c.send(options[:text]), c.send(options[:value])]}).to_json}" << ","
    out << "#{options[:clear].to_json} )"
  end
end
